#!/bin/bash
#
## |-- bwa
# |-- clean
# |   |-- V300086849
# |   `-- V300090612
# |-- fastqc
# |-- picard
# |-- shell
# |-- V300086849
# |-- V300090612

date; echo ----START----




export PATH=/share/Pipelines/cWES/software:$PATH



script_generator() {
 cat << EOF > ./shell/$1_$2.bwa.sge   
date; echo ----START----
export PATH=/share/Pipelines/cWES/software:$PATH

# bwa mem -t 12 /share/Pipelines/cWES/database/GenomeBWAIndex/hg19_chM_male_mask.fa $PWD/clean/$i/$j/${i}_${j}_1.trimmed.fq.gz $PWD/clean/$i/$j/${i}_${j}_2.trimmed.fq.gz > $PWD/bwa/${i}_${j}.sam && echo 2sam
# 
# samtools view -bS -@ 12 $PWD/bwa/${i}_${j}.sam -o $PWD/bwa/${i}_${j}.bam  && echo 2bam
# samtools sort -@ 12 $PWD/bwa/${i}_${j}.bam ${i}_${j} -o > $PWD/bwa/${i}_${j}.sorted.bam

# java -Xmx64G -jar /share/Pipelines/cWES/software/picard.jar SortSam I=$PWD/bwa/${i}_${j}.bam O=$PWD/bwa/${i}_${j}.sorted.bam SO=coordinate

# samtools index $PWD/bwa/${i}_${j}.sorted.bam && index
ls -lh $PWD/bwa/

java -Xmx64G -Djava.io.tmpdir=$PWD -XX:MaxPermSize=512m -XX:-UseGCOverheadLimit -jar /share/Pipelines/cWES/software/picard.jar MarkDuplicates I=$PWD/bwa/${i}_${j}.sorted.bam O=$PWD/bwa/${i}_${j}.sorted.markdup.bam M=$PWD/picard/${i}_${j}.marked_dup_metrics.txt REMOVE_DUPLICATES=false

echo ----END----; date
EOF
}


for i in `ls | grep -e "V[0-9]\{9\}"`; do
 for j in L0{1..4}; do
   if [[ ${i} != "V300090612" || ${j} != "L02" ]]; then
     echo $i, $j
     script_generator $i $j
     qsub -wd /share/Data01/swang/qut_data -l num_proc=4 -l mem_free=80G -l h_vmem=100G -l virtual_free=100M -l h_rt=120:00:00 -N dedup -m be -M c-siyuan.wang@genomics.cn -j y -terse /share/Data01/swang/qut_data/shell/${i}_${j}.bwa.sge
   fi
 done
done




# md5sum $3_L04_588_* > V350022685.md5






echo ----END----; date