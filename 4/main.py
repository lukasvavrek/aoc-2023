#!/usr/bin/python3

# 26914
# 13080971

import sys

lines = map(lambda line: line.strip(), sys.stdin.readlines())
lines = list(lines)


class Card:
    def __init__(self, id, winning, owned):
        self.id = id
        self.winning = winning
        self.owned = owned
        self.count = 1

    def __str__(self):
        return f'Card {self.id}: {self.worth()}P -> {self.winning} | {self.owned}'

    def points(self):
        points = filter(lambda x: x in self.winning, self.owned)
        return len(list(points))

    def worth(self):
        points = self.points()
        if points == 0:
            return 0
        return pow(2, points - 1)

    def copy(self, count=1):
        self.count += count


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


cards = [parse_card(line) for line in lines]
print(sum(map(lambda c: c.worth(), cards)))

for i in range(len(cards)):
    if cards[i].worth() == 0:
        continue

    for j in range(i + 1, i+1+cards[i].points()):
        cards[j].copy(cards[i].count)

print(sum([card.count for card in cards]))
