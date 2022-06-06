#!/bin/bash
#
# find ./ -type f -name "*.qc.sge" -exec qsub -wd /share/Data01/swang/qut_data -l num_proc=8 -l mem_free=70G -l h_vmem=80G -l virtual_free=100M -l h_rt=18:00:00 -N qc_analysis -m be -M c-siyuan.wang@genomics.cn -j y -terse {} \;

date; echo ----START----


script_generator() {
 cat << EOF > ./shell/$1_$2.sge   
date; echo ----START----
export PATH=/share/Pipelines/cWES/software:$PATH
export LD_LIBRARY_PATH=/home/tianwei/SelfInstalled/zlib-1.2.11:$LD_LIBRARY_PATH:/share/Pipelines/cWES/software/oracle_lib:$LD_LIBRARY_PATH:/share/app/gcc-5.2.0/lib64

pwd

# /share/app/FastQC-0.11.3/fastqc -t 8 -o $PWD/fastqc -f fastq $PWD/$1/$2/*.fq.gz

/share/Data01/tianwei/Bin/SOAPnuke2/SOAPnuke-master/SOAPnuke filter -1 $PWD/$1/$2/$1_$2_read_1.fq.gz -2 $PWD/$1/$2/$1_$2_read_2.fq.gz --trim 0,0,0,0 --outDir $PWD/clean/$1/$2/ -C $1_$2_1.trimmed.fq.gz -D $1_$2_2.trimmed.fq.gz -T 8 --lowQual 10    # --log $PWD

/share/app/FastQC-0.11.3/fastqc -t 8 -o $PWD/fastqc -f fastq $PWD/clean/$1/$2/$1_$2_*.trimmed.fq.gz

echo ----END----; date
EOF
}





for i in `ls | grep -e "V[0-9]\{9\}"`; do
  for j in L0{1..4}; do
    echo $i, $j
    script_generator $i $j
  done
done


# -a adapter.txt    --adapter1    --adapter2




# md5sum $3_L04_588_* > V350022685.md5






echo ----END----; date