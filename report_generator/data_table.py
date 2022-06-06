#!/usr/bin/env python3

# NOTE: python3 /share/Pipelines/cWGS_Filter/Filter/FilterV1.4/main.py project_path

import os
import sys
import pathlib



def read_stat(seq_qual_stat_file):
    data = [0] * 5
    with open(seq_qual_stat_file, 'rt') as f:
        for i in f:
            if "Read length" in i:
                data[4] = int(float(i.split('\t')[1]))
            elif 'Total number of bases' in i:
                data[3] = int(i.split('\t')[2].split(' ')[0])+int(i.split('\t')[4].split(' ')[0])
            elif ('Number of base C' in i) or ('Number of base G' in i):
                data[2] += int(i.split('\t')[2].split(' ')[0])+int(i.split('\t')[4].split(' ')[0])
            elif 'Q30 number' in i:
                data[1] = int(i.split('\t')[2].split(' ')[0])+int(i.split('\t')[4].split(' ')[0])
            elif 'Q20 number' in i:
                data[0] = int(i.split('\t')[2].split(' ')[0])+int(i.split('\t')[4].split(' ')[0])
    return data



def normalize(data, size):
    return list(map(round, [data[0]/data[3], data[1]/data[3], data[2]/data[3], data[3]/2/10 ** 9, data[4]/size], [5]*3+[2, None]))




def dict2html(field):
    th=f"""<tr>
   <th width="10%">Sample ID</th>
   <th width="10%">Q20 (%)</th>
   <th width="10%">Q30 (%)</th>
   <th width="10%">GC (%)</th>
   <th width="10%">Total Bases (G)</th>
   <!--<th width="10%">Insert Size (bp)</th>-->
   <th width="10%">Read length (bp)</th>
 </tr>"""
    td = ""

    for i in field.keys():
        td += "<tr>\n"
        td += "<td>{}</td>\n".format(i)
        for j, k in enumerate(field[i]):
            if j <= 2:
                 td += "<td>{:.2%}</td>\n".format(k)
            else:
                 td += "<td>{}</td>\n".format(k)
        td += "</tr>\n"
    print(th+td.strip())



def main():
    sample_list = os.listdir(sys.argv[1] + "/Reads/Clean")
    p = pathlib.Path(sys.argv[1] + "/Reads/Clean")

    D = {}.fromkeys(sample_list, [])

    for i in sample_list:
        z = zip(*[read_stat(_.resolve().parent / "Basic_Statistics_of_Sequencing_Quality.txt") for _ in list(p.glob(i + '/*'))])
        D.update({i:normalize([sum(_) for _ in z], len(list(p.glob(i + '/*'))))})
    dict2html(D)



if __name__ == "__main__":
    # print(sys.argv)
    main()

