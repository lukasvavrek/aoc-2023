#!/usr/bin/python3

# 2727
# 56580

import sys

possible_ids = []
powers = []

for line in sys.stdin.readlines():
    line = line.strip()

    game, draws = line.split(':')
    game = int(game.split(' ')[1])
    draws = draws.split(';')

    possible = True
    count_map = {'red': 0, 'green': 0, 'blue': 0}

    for draw in draws:
        draw = draw.strip()
        takes = draw.split(',')

        for take in takes:
            cnt, color = take.strip().split(' ')
            cnt = int(cnt)

            if color == 'red' and cnt > 12:
                possible = False
            elif color == 'green' and cnt > 13:
                possible = False
            elif color == 'blue' and cnt > 14:
                possible = False

            count_map[color] = max(count_map[color], cnt)

    # print(f'Game {game} is possible {possible}')
    if possible:
        possible_ids.append(game)

    # print(f'Count map {count_map}')

    power = 1
    for cnt in count_map.values():
        power *= cnt
    powers.append(power)

print(sum(possible_ids))
print(sum(powers))
