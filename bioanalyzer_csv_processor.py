#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import csv


import math
import random

import os
import sys
import pathlib
import time


def process_bioanalyzer_csv(csvfile):
    with open(csvfile, 'rt') as reader:
        file = csv.reader(reader)
        process_bioanalyzer_csv.header = []
        L = []
        for i in file:
            if 'Sample Name' in i:
                L += i[1:2]
            elif 'Region 1' in i:
                L += i[5:6] + i[7:9]
            elif 'Data File Name' in i:
                process_bioanalyzer_csv.header = i[0:4]
        return L


def separator(data, size):
    for i in range(0, len(data), size):
        yield data[i:i + size]


def generate_result_csv(filename, iter_data, header = None):
    with open(filename, 'w+', newline='') as fw:
        writer = csv.writer(fw)
        if header:
            writer.writerow(header)
            writer.writerow(['Sample Name', 'Average Size [bp]', 'Conc. [pg/µl]', 'Molarity [pmol/l]'])
        for i in iter_data:
            writer.writerow(i)


def main():
    path, fn = os.path.split(sys.argv[1])
    out_path = os.path.dirname(path) + os.sep + '2100_simplified_CSV'
    # print(out_path)
    # print(path,'\t', os.path.normpath(path))

    if not os.path.exists(out_path):
        os.mkdir(out_path)

    processed_csv_rows = separator(process_bioanalyzer_csv(sys.argv[1]), 4)
    generate_result_csv(out_path + os.sep + fn, processed_csv_rows, process_bioanalyzer_csv.header)
    print('Processed {} to {}'.format(fn, out_path))

#


if __name__ == "__main__":
    # print(sys.argv)
    #time.sleep(2)
    main()
