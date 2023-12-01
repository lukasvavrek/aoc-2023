#!/usr/bin/python3

import sys

total = 0

for line in sys.stdin.readlines():
    d = 0

    for ch in line:
        if ch.isnumeric():
            d = 10 * int(ch)
            break

    for ch in line[::-1]:
        if ch.isnumeric():
            d += int(ch)
            break

    total += d

print(total)

