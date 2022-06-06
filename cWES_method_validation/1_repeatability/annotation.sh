#!/bin/bash

date; echo ----START----

export PATH=/share/Pipelines/cWES/software:$PATH
export BGICGA_HOME=/share/Pipelines/cWES/Annotation_pipelines/BGICG_Annotation_update
export LD_LIBRARY_PATH=/home/tianwei/SelfInstalled/zlib-1.2.11:$LD_LIBRARY_PATH:/share/Pipelines/cWES/software/oracle_lib:$LD_LIBRARY_PATH:/share/app/gcc-5.2.0/lib64

cfg=/share/Pipelines/cWES/Annotation_pipelines/xgentic_Annotation/config_BGI59M_CG_single.2019.pl
anno=/share/Pipelines/cWES/Annotation_pipelines/xgentic_Annotation/bgi_anno/bin/bgicg_anno.pl

acmg=/share/Pipelines/cWES/Annotation_pipelines/xgentic_Annotation/acmg2015/bin/anno.acmg.pl
func=/share/Pipelines/cWES/Annotation_pipelines/xgentic_Annotation/update.Function.pl


echo $1 $2

prefix=$(basename $2 | cut -d. -f1)


while :
do
    time /usr/bin/perl $anno $cfg -f -t vcf -n 5 -b 500 -o $1/${prefix}.out -q $2
    if(($? == 0)); then break; fi
    if(($count < 5)); then sleep 5; else     sleep 60; fi 
    ((count++))
done

/share/Data01/tianwei/Bin/Python-2.7.16/20190723/bin/python /share/Pipelines/cWES/Annotation_pipelines/MaxEntScan_pipeline/extract_info.py -i $1/${prefix}.out -o $1

time /usr/bin/perl $acmg $1/${prefix}.out > $1/${prefix}.out.ACMG

time /usr/bin/perl $func $1/${prefix}.out.ACMG > $1/${prefix}.out.ACMG.updateFunc

/share/Pipelines/cWES/Annotation_pipelines/xgentic_Annotation/anno2xlsx/anno2xlsx -snv $1/${prefix}.out.ACMG.updateFunc -list ${prefix} -gender M -prefix $1/${prefix}.out.ACMG.updateFunc \
                                               -redis -redisAddr 192.168.233.12:8080 -product all 
                                               -specVarList /share/Pipelines/cWES/Annotation_pipelines/xgentic_Annotation/anno2xlsx/db/spec.var.lite.list

cat $1/${prefix}.out | awk '{if (NR > 8) print}' | awk '{                                                   \
if (($9 == "snv") && ($13 > 40 && $14 > 0.4)) {printf "chr"$1 "\t" $2 "\t" $3 "\n"}                                  \
else if (( $9 == "ins" || $9 == "del") && ($13 > 60 && $14 > 0.45)) {printf "chr"$1 "\t" $2 "\t" $3 "\n"}            \
}' | sed 's/chrMT/chrM_NC_012920.1/g' > $1/${prefix}.ht.bed

bedtools merge -i $1/${prefix}.ht.bed > $1/${prefix}.ht.dedup.bed

bcftools view -i 'FILTER="PASS"' -R $1/${prefix}.ht.dedup.bed $2 -Oz -o $(dirname $1)/${prefix}.annotated.vcf.gz



echo ----END----; date
