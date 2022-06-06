#!/bin/bash
#$ -N demultiplexing
#$ -m be
#$ -M c-siyuan.wang@genomics.cn
#$ -l num_proc=20
#$ -l mem_free=120G
#$ -l h_vmem=140G
#$ -l virtual_free=100M
#$ -l h_rt=12:00:00
#$ -j y

#
# ./demultiplexing_se.sh V300108513 100 barcode.i5

date; echo ----START----


for i in {1..4}; do
  mkdir -p ${1}_L0${i}.${2}_se       # ${1}_L0{i}.${2}_${3}.rc
  cat << EOF > ${1}_L0${i}.${2}_se.sge
date; echo ----START----
/share/app/glibc-2.17/lib/ld-linux-x86-64.so.2 \
--library-path "/share/app/glibc-2.17/lib":$LD_LIBRARY_PATH:/usr/lib64:/lib64 \
/share/Data01/tianwei/ForLab/Bin/DeMultiplexing/splitBarcode_V2.0.0_release_4_basecallLite_MGI/splitBarcode_V2.0.0_release/linux/bin/splitBarcode -t 16 -m 100 \
-B ./${3} -1 ./data/${1}_L0${i}_read_2.fq.gz -o ./${1}_L0${i}.${2}_se -b ${2} 10 1 -r
echo ----END----; date
EOF

  qsub -cwd -l num_proc=16 -l mem_free=125G -l h_vmem=135G -l virtual_free=200M -l h_rt=08:00:00 -N de${i} -j y -terse ${1}_L0${i}.${2}_se.sge
  sleep 0.2
done

echo ----END----; date
