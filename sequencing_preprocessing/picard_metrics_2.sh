#!/bin/bash
#
# qsub -cwd -l num_proc=4 -l mem_free=70G -l h_vmem=80G -l virtual_free=100M -l h_rt=80:00:00 -N post -j y -terse picard_metrics_2.sh

date; echo ----START----




export PATH=/share/Pipelines/cWES/software:$PATH


# java -Xmx64G -jar /share/Pipelines/cWES/software/picard.jar FastqToSam FASTQ=/home/wangsiyuan/swang/qut_data/V300086849/L01/V300086849_L01_read_1.fq.gz FASTQ2=/home/wangsiyuan/swang/qut_data/V300086849/L01/V300086849_L01_read_2.fq.gz OUTPUT=/home/wangsiyuan/swang/qut_data/picard/V300086849_L01_R1R2.unmapped.bam SAMPLE_NAME=V300086849_L01 SORT_ORDER=coordinate

java -Xmx64G -Djava.io.tmpdir=$PWD/picard_2 -jar /share/Pipelines/cWES/software/picard.jar CollectInsertSizeMetrics I=$PWD/bwa/${1}_${2}.sorted.markdup.bam O=$PWD/picard_2/${1}_${2}.insert_size_metrics.txt H=$PWD/picard_2/${1}_${2}.insert_size_histogram.pdf M=0.5
java -Xmx64G -Djava.io.tmpdir=$PWD/picard_2 -jar /share/Pipelines/cWES/software/picard.jar EstimateLibraryComplexity I=$PWD/bwa/${1}_${2}.sorted.markdup.bam O=$PWD/picard_2/${1}_${2}.estimated_complexity_metrics.txt 

# -a adapter.txt    --adapter1    --adapter2




# md5sum $3_L04_588_* > V350022685.md5






echo ----END----; date