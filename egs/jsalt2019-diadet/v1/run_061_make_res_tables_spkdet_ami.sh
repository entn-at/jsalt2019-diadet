#!/bin/bash
# Copyright      2018   Johns Hopkins University (Author: Jesus Villalba)
#
# Apache 2.0.
#
. ./cmd.sh
. ./path.sh
set -e

config_file=default_config.sh

. parse_options.sh || exit 1;
. $config_file

score_dir0=exp/scores/$nnet_name/${be_name}
name0="$nnet_name $be_name"

#energy VAD
conds=(plda plda_adapt plda_adapt_snorm \
	    plda_spkdetdiar_nnet${nnet_name}_thrbest \
	    plda_adapt_spkdetdiar_nnet${nnet_name}_thrbest \
            plda_adapt_snorm_spkdetdiar_nnet${nnet_name}_thrbest)
conds_name=("no-adapt e-vad no-diar" "adapt e-vad no-diar" "adapt-snorm e-vad no-diar" \
				     "no-adapt e-vad auto-diar" "adapt e-vad auto-diar" "adapt-snorm e-vad auto-diar")


echo "Energy VAD"
args="--print-header true"
for((i=0;i<${#conds[*]};i++))
do
    score_dir=$score_dir0/${conds[$i]}_cal_v1
    name="$name0 ${conds_name[$i]}"
    local/make_table_line_spkdet_jsalt19_xxx.sh $args "$name" ami $score_dir
    args=""
done
echo ""

#####

#GT VAD
conds=(plda_gtvad plda_adapt_gtvad plda_adapt_snorm_gtvad \
	    plda_spkdetdiar_nnet${nnet_name}_thrbest_gtvad \
	    plda_adapt_spkdetdiar_nnet${nnet_name}_thrbest_gtvad \
            plda_adapt_snorm_spkdetdiar_nnet${nnet_name}_thrbest_gtvad)
conds_name=("no-adapt gt-vad no-diar" "adapt gt-vad no-diar" "adapt-snorm gt-vad no-diar" \
				     "no-adapt gt-vad auto-diar" "adapt gt-vad auto-diar" "adapt-snorm gt-vad auto-diar")


echo "Ground Truth VAD"
args="--print-header true"
#print EER table
for((i=0;i<${#conds[*]};i++))
do
    score_dir=$score_dir0/${conds[$i]}_cal_v1
    name="$name0 ${conds_name[$i]}"
    local/make_table_line_spkdet_jsalt19_xxx.sh $args "$name" ami $score_dir
    args=""
done
echo ""

#####

#GT diarization
conds=(plda_gtdiar plda_adapt_gtdiar plda_adapt_snorm_gtdiar)
conds_name=("no-adapt gt-diar" "adapt gt-diar" "adapt-snorm gt-diar")


echo "Ground Truth diarization"
args="--print-header true"
for((i=0;i<${#conds[*]};i++))
do
    score_dir=$score_dir0/${conds[$i]}_cal_v1
    name="$name0 ${conds_name[$i]}"
    local/make_table_line_spkdet_jsalt19_xxx.sh $args "$name" ami $score_dir
    args=""
done
echo ""

