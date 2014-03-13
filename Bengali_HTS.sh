#!/bin/sh
# Bengali HTS starter script

# Sankar Mukherjee
# CET, IITKGP
# sankar1535@gmail.com
# for more updates ==> https://github.com/sankar-mukherjee/Bengali-HTS
#=================================================================================================
# Has two voices 
# 1)bng_BIG_hts with CRBLP corpus  2) bng_hts_engine with CDAC corpus


current_dir=$(pwd)

# change sampling frequency 32000
#hts_filepath=$current_dir/bng_BIG_hts

# change sampling frequency 22050
hts_filepath=$current_dir/bng_hts_engine

td=$hts_filepath/tree-dur.inf
tm=$hts_filepath/tree-mgc.inf
tf=$hts_filepath/tree-lf0.inf
md=$hts_filepath/dur.pdf
mf=$hts_filepath/lf0.pdf
mm=$hts_filepath/mgc.pdf
df1=$hts_filepath/lf0.win1
df2=$hts_filepath/lf0.win2
df3=$hts_filepath/lf0.win3
dm1=$hts_filepath/mgc.win1
dm2=$hts_filepath/mgc.win2
dm3=$hts_filepath/mgc.win3
cf=$hts_filepath/gv-lf0.pdf
cm=$hts_filepath/gv-mgc.pdf
ef=$hts_filepath/tree-gv-lf0.inf
em=$hts_filepath/tree-gv-mgc.inf
k=$hts_filepath/gv-switch.inf

tmp="$1_1"
temp="$1_2"

java -classpath $current_dir/HTS_frontend/hts_FrontEnd.jar hts_frontend.Main $current_dir/HTS_frontend/beng.tagger $1 $tmp

perl $current_dir/HTS_frontend/genlab_new.pl $tmp $temp

$current_dir/bng_hts_engine/hts_engine -td $td -tm $tm -tf $tf -md $md -mf $mf -mm $mm -df $df1 -df $df2 -df $df3 -dm $dm1 -dm $dm2 -dm $dm3 -cf $cf -cm $cm -ef $ef -em $em -k $k -ow $2 -p 220.50 -s 22050  $temp

rm $tmp $temp
