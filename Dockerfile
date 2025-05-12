FROM ubuntu@sha256:dc17125eaac86538c57da886e494a34489122fb6a3ebb6411153d742594c2ddc

ENV DEBIAN_FRONTEND=noninteractive

# Set these variables specific to your challenge
ENV CHALL_PORT=1337
ENV CHALL_PATH=/chall/challenge.sh

# Install container setup dependencies
RUN apt-get update && \
    apt-get install -y socat openssh-server coreutils bash sudo

# Create SSH users and set passwords, and change login shell to bash
RUN useradd -m user && echo "user:password" | chpasswd
RUN useradd -m admin && echo "admin:password" | chpasswd
RUN chsh -s /bin/bash user && \
    chsh -s /bin/bash admin
RUN usermod -aG sudo user
RUN usermod -aG sudo admin
RUN echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/user && chmod 440 /etc/sudoers.d/user

# Configure SSH
RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Create SSH keys
RUN ssh-keygen -A

# Install challenge-specific dependencies
# Fill in as necessary

# Copy challenge files into container and configure as necessary
COPY chall /chall

# Run challenge. fork a new process every time a user connects to the socket,
# and send stdin and stdout on the socket.
# Change if creating a challenge that hosts its own server, like a web
# challenge.
CMD bash -c "\
    /usr/sbin/sshd && \
    socat -T 30 \
    TCP-LISTEN:$CHALL_PORT,nodelay,reuseaddr,fork \
    EXEC:\"stdbuf -i0 -o0 $CHALL_PATH\""
