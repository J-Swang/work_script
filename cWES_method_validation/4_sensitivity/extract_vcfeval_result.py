#!/usr/bin/env python3
# python3 .py snp.txt

import csv
import os
import sys

from pathlib import *


def vcfeval_extract(rtg_vcfeval_result_file):
    D = {}.fromkeys(['NA12878', 'NA12891', 'NA12892', 'NA24143', 'NA24149', 'NA24385', 'NA24631', 'NA24694', 'NA24695'])
    with open(rtg_vcfeval_result_file, 'r') as f:
        for i in f:
            if "summary.txt" in i:
                sample_name = i.split()[0].split('/')[1][0:7]
                data = list(map(int, [i.split()[2], i.split()[5]]))
                if D[sample_name]:
                    D[sample_name] = [sum(_) for _ in zip(D[sample_name], data)]
                    D[sample_name].append(round(D[sample_name][0]/(D[sample_name][0] + D[sample_name][1]), 4))
                else:
                    D[sample_name] = data

        for i, j in D.items():
            print(i, *j, sep = ', ')


def vcfeval_extract_with_nested_data(rtg_vcfeval_result_file):
    D = {i:[] for i in ['NA12878', 'NA12891', 'NA12892', 'NA24143', 'NA24149', 'NA24385', 'NA24631', 'NA24694', 'NA24695']}
    with open(rtg_vcfeval_result_file, 'r') as f:
        for i in f:
            if "summary.txt" in i:
                sample_name = i.split()[0].split('/')[0]
                data = i.split()[0].split("/")[1:3] + list(map(int, [i.split()[2], i.split()[5]])) + [i.split()[7]]
                D[sample_name].append(data)

    with open('out.csv', 'w+') as fw:
        writer = csv.writer(fw)
        writer.writerow(['Materials','VariantType','ConfidenceClass','TP','FN','Sensitivity'])
        for i, j in D.items():
            print(i, *j, sep = ', ')
            for k in j:
                writer.writerow([i]+k)



def main():
    if sys.argv[2] == 'n':
        vcfeval_extract_with_nested_data(sys.argv[1])
    else:
        vcfeval_extract(sys.argv[1])

        
if __name__ == "__main__":
    # print(sys.argv)
    main()