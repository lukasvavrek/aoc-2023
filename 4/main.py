#!/usr/bin/python3

# 26914
#

import sys

lines = map(lambda line: line.strip(), sys.stdin.readlines())
lines = list(lines)


class Card:
    def __init__(self, id, winning, owned):
        self.id = id
        self.winning = winning
        self.owned = owned

    def __str__(self):
        return f'Card {self.id}: {self.worth()}P -> {self.winning} | {self.owned}'

    def worth(self):
        points = filter(lambda x: x in self.winning, self.owned)
        points = len(list(points))
        if points == 0:
            return 0
        return pow(2, points - 1)


def parse_nums(line):
    nums = line.split(' ')
    nums = filter(lambda x: len(x) > 0, nums)
    nums = map(lambda n: int(n), nums)
    return list(nums)


def parse_card(line):
    cn = line.split(':')
    id = int(cn[0].split(' ')[-1])

    nums = cn[1].split('|')
    winning = parse_nums(nums[0])
    owned = parse_nums(nums[1])

    return Card(id, winning, owned)


print(sum([parse_card(line).worth() for line in lines]))
