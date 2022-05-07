#!/usr/bin/env python3
# python3 .py $1 $prefix 0.4      # python3 .py $1 $prefix 0.6


import os
import sys

import pandas as pd

from pathlib import *



def extract_vcf_info_from_anno2xlsx_tier(path, prefix, threshold):
    print(Path(path))
    df = pd.read_excel(Path(path + os.sep + prefix + ".out.ACMG.updateFunc.Tier1.xlsx"), 0, engine = "openpyxl")
    
    data = df.loc[0:, ['#Chr', 'Start', 'Stop', 'Transcript', 'A.Ratio']][df['A.Ratio'] > threshold]      # 0.4 0.6

    with open(Path(path / (prefix + ".out.ACMG.updateFunc.Tier1.bed"))), 'w', newline="") as f:
        f.write(pd.DataFrame.to_csv(data, sep='\t', header=False, index=False))


def main():
    extract_vcf_info_from_anno2xlsx_tier(*sys.argv[1:4])


if __name__ == '__main__':
    print(sys.argv)
    main()