#!/usr/bin/python3

# 533775
#

import sys


class Number:
    def __init__(self, sidx, yidx):
        self.sidx = sidx
        self.yidx = yidx
        self.value = 0

    def __add__(self, number):
        self.value = self.value * 10 + number
        return self

    def __len__(self):
        return len(str(self.value))

    def __repr__(self):
        return f"({self.value}, yidx: {self.yidx}, sidx: {self.sidx}, len: {len(self)})"


def extract_numbers(line, yidx):
    numbers = []

    number = None

    i = 0
    while i < len(line):
        if line[i].isdigit():
            if number is None:
                number = Number(i, yidx)
                number += int(line[i])
            else:
                number += int(line[i])
        else:
            if number is not None:
                numbers.append(number)
                number = None
        i += 1

    return numbers


lines = map(lambda line: line.strip(), sys.stdin.readlines())
lines = list(lines)

# append dots around whole map
x = '.' * len(lines[0])
lines.insert(0, x)
lines.append(x)

lines = map(lambda line: '.' + line + '.', lines)
lines = list(lines)


def flatten(list):
    return [item for sublist in list for item in sublist]


numbers = [extract_numbers(line, yidx) for yidx, line in enumerate(lines)]
numbers = filter(lambda x: len(x) > 0, numbers)
numbers = flatten(numbers)
numbers = list(numbers)


def print_lines(lines):
    print('====================')
    for line in lines:
        print(line)
    print('====================')


def get_border(number, lines):
    x1 = number.sidx-1
    x2 = number.sidx + len(number)

    border = ''
    border += lines[number.yidx - 1][x1: x2+1]
    border += lines[number.yidx + 1][x1: x2+1]
    border += lines[number.yidx][x1]
    border += lines[number.yidx][x2]

    print(f'{number} x1,x2=({x1}, {x2}) border = {border}')
    return border


def is_part_number(number, lines):
    border = get_border(number, lines)

    border = filter(lambda x: not x.isdigit(), border)
    return not all(map(lambda x: x == '.', border))


print_lines(lines)

part_numbers = filter(lambda x: is_part_number(x, lines), numbers)
part_numbers = map(lambda x: x.value, part_numbers)
print(sum(part_numbers))


def has_border_on(number, lines, x, y):
    x1 = number.sidx-1
    x2 = number.sidx + len(number)

    if y == number.yidx - 1 and x1 <= x <= x2:
        return True
    if y == number.yidx + 1 and x1 <= x <= x2:
        return True

    if y == number.yidx and x == x1:
        return True
    if y == number.yidx and x == x2:
        return True

    return False


gears = []

for y in range(len(lines)):
    for x in range(len(lines[y])):
        if lines[y][x] == '*':
            neighbors = filter(lambda number: has_border_on(number, lines, x, y), numbers)
            neighbors = list(neighbors)

            if len(neighbors) == 2:
                print(f'Gear at {x}, {y} => {neighbors[0]} and {neighbors[1]}')
                gears.append((neighbors[0].value, neighbors[1].value))

print(sum(map(lambda x: x[0] * x[1], gears)))
