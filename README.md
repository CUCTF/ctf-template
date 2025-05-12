# CTF Template

This repository is a template for deploying Attack/Defend CTF challenges. It
contains an example challenge.

Contents
* `chall/`: contents that are copied into challenge container, and will be made
  available to competitors.
* `status-check/`: scripts for ensuring that the challenge is functioning as
  intended
* `exploit/`: scripts for exploiting vulnerable instances of the challenge

## Deployment

```
$ docker compose build
$ docker compose up
```

All challenges must reference a `/chall/flag.txt` file. The contents of this
file will be set at competition time.

## Functionality

This challenge implements an echo server. Any inputs sent to the challenge will
be echoed back to the user.

Check that the server is working with the status-check script:

```
$ python3 status-check/check.py
```

## Vulnerability

This challenge has a backdoor vulnerability. If the user sends the string
"deadbeef" to the echo server, it will print the flag.

## Exploit

To exploit the vulnerability and receive the flag, run the exploit script:

```
$ python3 exploit/exploit.py <ip> <port>
```

## Remediation

A user can patch the backdoor by editing the deployed `challenge.sh` script and
commenting out lines 12-19,21 to remove the backdoor while retaining the echo
server's functionality.

After modifying the challenge, confirm success by running the status-check
script (expect: success) and the exploit script (expect: no flag).
