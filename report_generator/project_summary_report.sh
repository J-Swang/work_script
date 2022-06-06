#!/bin/bash


# ./ /share/Data01/BGIAU_Analysis/AutoQcAnalysis/2_AnalysisRoom/TGF/F21FTSECKF1193/DUGwezR_1/20210702/1_Basic_Analysis/F21FTSECKF1193_DUGwezR_1 /share/Data01/BGIAU_Analysis/AutoQcAnalysis/2_AnalysisRoom/TGF/F21FTSECKF1193/DUGwezR_1/20210702/1_Basic_Analysis/F21FTSECKF1193_DUGwezR_1/report
# ./ input_path output_path
# python3 required



date; echo ----START----



projectname=$(sed -n '5p' $1/BMS.info | cut -f2)
sub_project_id=$(sed -n '8p' $1/BMS.info | cut -f2)



cut_table() {
	L1=$(grep -n "<div class=seq_cn1>" $1/report/content.html | cut -f1 -d:)
	L2=$(($(grep -n "Data Quality Control</h1>" $1/report/content.html | cut -f1 -d:) - 1))
	# echo $L1 $L2
	sed -n "${L1},${L2}p" $1/report/content.html     # awk '{if (NR > $1) print }'
}


# read_stat_table=$(cut_table $1)

read_stat_table=$(python3 ./data_table.py $1)

if [[ ! -d $2/Images ]]; then mkdir -p $2/Images; fi
ln -sv ./Images/BGI-Xome.png $2/Images

ln -sv $1/report/css $2
ln -sv $1/report/js $2



cat > $2/summary_report.html << EOF
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>BGI Bioinformatics Report for Pure-sequencing Project</title>
<link href="css/report.css" rel="stylesheet" type="text/css">
<script language="javascript" src="js/jquery.js"></script>
<script language="javascript" src="js/report.js"></script>
<style type="text/css">
html{
	overflow:auto;
	}
body{
	position:relative;
	}
</style>
</head>
<body>
	<img src="/Images/BGI-Xome.png" width="153" height="58">
	<center><b><font size="4" face="Times">BGI HEALTH (AU)</font></b></center></br>
</br>
	<center><b><font size="3" face="Times">Whole Genome Sequencing Report</font></b></center></br>
	<div style="width:280px; height:35px; float:right"><font size="3" face="Times">Project name: $projectname
                                                                                       Subproject ID: $sub_project_id</font></div></br></br>
<div class=seq_cn1>
   <div class="top_btn1"></div>
   <p style="font-size:40px;color:white">----</p>
   <h1><a name="1"></a>1 Data Production</h1>
     <p>After sequencing ,the raw reads were filtered.Data filtering includes removing adaptor sequences, contamination and low-quality reads from raw reads.Next, we get the statistics of data production.Table 1-1 shows statistical results after data treatment.
	 <p>     
<p>
	   <center>
	   <p><strong>  Table 1-1</strong> Reads statistics results<p>
       </center><div>
<cnter>
<table width="70%">
$read_stat_table
  </table>
  </center>
  </div><h2>&nbsp;</h2>
<table>
<thead>
  <tr>
    <td><span style="font-style:italic">Signed by: </span></td>
    <td><span style="font-style:italic">Date: </span></td>
  </tr>
</thead>
</table>
  <hr>
<p>Laboratory Director   BGI HEALTH (AU)</p>
</br>
</br>
	<h2><a name="1.1"></a>1.1 Table content.</h2>
	<p>1. Sample ID</p>
	<p>2. Q20</p>
	<p>3. Q30</p>
	<p>4. GC content</p>
	<p>5. Total base count</p>
	<p>6. Read length</p>
</br>
</br>
<h1><a name="2"></a>2 Contact</h1>
	<p>Add: Level 6, CBCRC Building, 300 Herston Road, Herston QLD 4006</p>
	<p>Tel:  +61 7 3362 0476</p>
	<p>Service Hotline: 400-706-6615</p>
	<p>Customer Service: P_AUlab@genomics.cn</p>
	<p>Technical Support: tech@genomics.com.cn</p>
	<p>Complaint Hotline: +61 7 3362 0476 (Brisbane) 0755-25273291(Shenzhen)</p></body> 
</html>
EOF

/share/Pipelines/WGS_Filter/Filter/FilterV1.4/html2pdf.sh $2/summary_report.html $2/report_$projectname.pdf



echo ----END----; date