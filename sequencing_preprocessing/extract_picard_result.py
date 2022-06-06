#!/usr/bin/env python3
# python3 .py $1 $prefix 0.4      # python3 .py $1 $prefix 0.6


import csv
import os
import sys

import operator

from pathlib import *


def extract_from_picard_metrics(picard_output_file, *columns):
    g1 = operator.methodcaller('split', '\t')
    g2 = operator.itemgetter(*columns)
    with open(picard_output_file, 'r') as f:  # return list(map(g2, map(g1, f.readlines()[7:8])))
        data = list(g2(g1(f.readlines()[7])))
        print(data[:-1] + [data[-1].rstrip()])
        return data[:-1] + [data[-1].rstrip()]    # header, results

def main():
    g = operator.attrgetter('name')
    sample_list = list(map(g, Path().resolve().glob("./V*")))

    try:
        with open('picard_insert_size_metrics.csv', 'w+', newline='') as fw:
            writer = csv.writer(fw)
            writer.writerow(['Samples', 'MEDIAN_INSERT_SIZE', 'MIN_INSERT_SIZE', 'MAX_INSERT_SIZE', 'MEAN_INSERT_SIZE', 'STANDARD_DEVIATION'])
            for i in Path().resolve().glob("./picard/*insert_size_metrics*"):
                sample_name = i.name.split('.')[0]
                writer.writerow([sample_name] + extract_from_picard_metrics(i, 0, 2, 3, 4, 5))
        with open('picard_estimated_complexity_metrics.csv', 'w+', newline='') as fw:
            writer = csv.writer(fw)
            writer.writerow(['Samples', 'READ_PAIRS_EXAMINED', 'READ_PAIR_DUPLICATES', 'PERCENT_DUPLICATION', 'ESTIMATED_LIBRARY_SIZE'])
            for i in Path().resolve().glob("./picard/*estimated_complexity_metrics*"):
                sample_name = i.name.split('.')[0]
                writer.writerow([sample_name] + extract_from_picard_metrics(i, 2, 6, 8, 9))
    except FileNotFoundError as e:
        print(e)


if __name__ == '__main__':
    # print(sys.argv)
    main()
