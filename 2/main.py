#!/usr/bin/python3

# 2727

import sys

possible_ids = []

for line in sys.stdin.readlines():
    line = line.strip()

    game, draws = line.split(':')
    game = int(game.split(' ')[1])
    draws = draws.split(';')

    possible = True

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

    print(f'Game {game} is possible {possible}')
    if possible:
        possible_ids.append(game)

print(sum(possible_ids))
