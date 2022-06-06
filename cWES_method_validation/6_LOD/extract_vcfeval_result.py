#!/usr/bin/env python3
# python3 .py snp.txt

import csv
import os
import sys

from pathlib import *





def vcfeval_extract_with_nested_data(rtg_vcfeval_result_file):
    D = {i:[] for i in ['90v10_1', '90v10_2', '90v10_3', '80v20_1', '80v20_2', '80v20_3', '60v40_1', '60v40_2', '60v40_3', '50v50_1', '50v50_2', '50v50_3', '25v75_1', '25v75_2', '25v75_3', '25v75_4', '25v75_5', '25v75_6', '20v80_1', '20v80_2', '20v80_3', '15v85_1', '15v85_2', '15v85_3', '12.5v87.5_1', '12.5v87.5_2', '12.5v87.5_3', '10v90_1', '10v90_2', '10v90_3', '5v95_1', '5v95_2', '5v95_3']}
    with open(rtg_vcfeval_result_file, 'r') as f:
        for i in f:
            if "summary.txt" in i:
                sample_name = i.split()[0].split('/')[0]
                data = i.split()[0].split("/")[1:2] + list(map(int, [i.split()[2], i.split()[5]])) + [i.split()[7]]
                D[sample_name].append(data)

    with open('out.csv', 'w+') as fw:
        writer = csv.writer(fw)
        writer.writerow(['Materials','VariantType','TP','FN','Sensitivity'])
        for i, j in D.items():
            print(i, *j, sep = ', ')
            for k in j:
                writer.writerow([i]+k)


def main():
    vcfeval_extract_with_nested_data(sys.argv[1])



if __name__ == '__main__':
    # print(sys.argv)
    main()