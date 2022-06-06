#!/bin/bash
#
#
# ./demultiplexing_pe.sh V300108513 200 210 barcode_v1


date; echo ----START----


# cat << EOF > ${1}.${2}_${3}.sge
# date; echo ----START----
# /share/app/glibc-2.17/lib/ld-linux-x86-64.so.2 \
# --library-path "/share/app/glibc-2.17/lib":$LD_LIBRARY_PATH:/usr/lib64:/lib64 \
# /share/Data01/tianwei/ForLab/Bin/DeMultiplexing/splitBarcode_V2.0.0_release_4_basecallLite_MGI/splitBarcode_V2.0.0_release/linux/bin/splitBarcode -t 16 -m 100 \
# -B ./${3} -1 ./data/V300108513_L01_read_1.fq.gz -2 ./data/V300108513_L01_read_2.fq.gz -o ./${1}.${2}_${3} -b ${1} 10 1 -b ${2} 10 1
# echo ----END----; date
# EOF

for i in {1..4}; do
  mkdir -p ${1}_L0${i}.${2}_${3}       # ${1}_L0{i}.${2}_${3}.rc
  cat << EOF > ${1}_L0${i}.${2}_${3}.sge
date; echo ----START----
/share/app/glibc-2.17/lib/ld-linux-x86-64.so.2 \
--library-path "/share/app/glibc-2.17/lib":$LD_LIBRARY_PATH:/usr/lib64:/lib64 \
/share/Data01/tianwei/ForLab/Bin/DeMultiplexing/splitBarcode_V2.0.0_release_4_basecallLite_MGI/splitBarcode_V2.0.0_release/linux/bin/splitBarcode -t 16 -m 100 \
-B ./${4} -1 ./data/${1}_L0${i}_read_1.fq.gz -2 ./data/${1}_L0${i}_read_2.fq.gz -o ./${1}_L0${i}.${2}_${3} -b ${2} 10 1 -b ${3} 10 1 -r
echo ----END----; date
EOF

  qsub -cwd -l num_proc=16 -l mem_free=125G -l h_vmem=135G -l virtual_free=200M -l h_rt=08:00:00 -N de${i} -j y -terse ${1}_L0${i}.${2}_${3}.sge
  sleep 1
done

#

# qsub -cwd -l num_proc=16 -l mem_free=125G -l h_vmem=135G -l virtual_free=200M -l h_rt=08:00:00 -N de.rc -j y -terse ${1}.${2}_${3}.rc.sge





echo ----END----; date
