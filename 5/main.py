#!/usr/bin/python3

#
#

import sys

lines = map(lambda line: line.strip(), sys.stdin.readlines())
lines = list(lines)

seeds = [int(x) for x in lines[0].split(' ')[1:]]
print(seeds)
