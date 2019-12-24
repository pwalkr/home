#!/usr/bin/env python

import argparse
import csv


def parse_args():
    parser = argparse.ArgumentParser(description='Process ting usages.')

    parser.add_argument('usage', nargs='+', help='path[s] to CSV file containing usage[s]')

    return parser.parse_args()


def addValues(csvReader, nameIndex, valueIndex):
    devices = {}
    for entry in csvReader:
        if entry[nameIndex] not in devices:
            devices[ entry[nameIndex] ] = 0
        devices[ entry[nameIndex] ] += int(entry[valueIndex])
    for device in devices:
        print('    {}: {}'.format(device, devices[device]))


def countValues(csvReader, nameIndex):
    devices = {}
    for entry in csvReader:
        if entry[nameIndex] not in devices:
            devices[ entry[nameIndex] ] = 0
        devices[ entry[nameIndex] ] += 1
    for device in devices:
        print('    {}: {}'.format(device, devices[device]))


def indexMatches(list, index, match):
    return len(list) > index and list[index] == match

def main():
    args = parse_args()
    for usage in args.usage:
        with open(usage, 'r') as csvfile:
            csvReader = csv.reader(csvfile)
            headers = csvReader.__next__()
            if indexMatches(headers, 5, 'Kilobytes'):
                print('Kilobytes')
                addValues(csvReader, 3, 5)
            elif indexMatches(headers, 12, 'Duration (min)'):
                print('Minutes')
                addValues(csvReader, 5, 12)
            elif indexMatches(headers, 7, 'Sent/Received'):
                print('Messages')
                countValues(csvReader, 4)


if __name__ == "__main__":
    main()
