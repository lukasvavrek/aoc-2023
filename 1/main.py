#!/usr/bin/python3

import sys

map = {
    'one': "1",
    'two': "2",
    'three': "3",
    'four': "4",
    'five': "5",
    'six':  "6",
    'seven': "7",
    'eight': "8",
    'nine': "9",
}

def process_line(line):
    i = 0
    while i < len(line):
        if line[i:i+3] in map.keys():
            yield map[line[i:i+3]]
            i += 2
        elif line[i:i+4] in map.keys():
            yield map[line[i:i+4]]
            i += 3
        elif line[i:i+5] in map.keys():
            yield map[line[i:i+5]]
            i += 4
        else:
            yield line[i]
            i += 1

def first_number(line):
    for ch in line:
        if ch.isnumeric():
            return int(ch)

    return 0

t1 = 0
t2 = 0

for line in sys.stdin.readlines():
    d = 10 * first_number(line)
    d += first_number(line[::-1])

    t1 += d

    line = ''.join(process_line(line.strip().lower()))

    d = 10 * first_number(line)
    d += first_number(line[::-1])

    t2 += d

print(t1)
print(t2)

