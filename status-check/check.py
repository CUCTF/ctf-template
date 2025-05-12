#!/usr/bin/env python3

from pwn import *
import random
import string
import sys

# Check arguments
if len(sys.argv) != 3:
    print(f"Usage: {sys.argv[0]} <ip> <port>")
    sys.exit(1)

ip = sys.argv[1]
port = int(sys.argv[2])

# Generate a random string
rand_bytes = bytes(random.choices((string.ascii_letters + string.digits).encode(), k=16))

# Connect to the remote service
conn = remote(ip, port)

conn.recvuntil(b'Enter input: ')

# Send the random string
conn.sendline(rand_bytes)

# Read the response
conn.recvuntil(b'You entered: ')
response = conn.recvline().strip()
expected = rand_bytes

conn.close()

if response == expected:
    print("Success")
    sys.exit(0)
else:
    print("Failure")
    sys.exit(1)
