#!/bin/bash

# SCRIPT: bamCoverage_deepTool.sh
# AUTHOR: Mark Boltengagen
# VERSION: v20-05-2018
# OS: Linux Ubuntu 16.04 LTS
# DESCRIPTION: Compair BigWigs and make a new bigwig with ratio diffrence
# USED TOOLS: deepTools

### PARAMETERS
exppath='/home/suvar/Projects/006_ChIPseq_HDACs/'
outpath=${exppath}output/
threads=2

##### DeepTools coverage of bam files
cd ${outpath}bw
mkdir ${outpath}bdg_log2
{
##### BedGraph to BigWig conversion
## First file is a control
bw_control=$( ls | head -1 )

for bw_treat in *.bw
	do
		printf "$(date)\tBigWig compair of ${bw_treat} with ${bw_control}\n"
            #  log2( bigwig1 / bigwig 2) = log2 ( treatment / control )
            bigwigCompare --bigwig1 ${bw_treat} \
                  --bigwig2 ${bw_control} \
                  --operation log2 \
                  --binSize 1 \
                  --outFileName ${outpath}bdg_log2/${bw_treat%.bw}.bdg \
                  --outFileFormat bedgraph \
                  -p ${threads}

        printf "$(date)\tCompleted BigWig compair of ${bw_treat} with ${bw_control}\n\n"

	done
printf "=%.0s" {1..70}; printf "\n\n"

##### BDG SORTING

cd ${outpath}bdg_log2

for item in *.bdg
	do
	## Sort bdg file
        LC_COLLATE=C sort -k1,1 -k2,2n $item | sed '1 i\track type=bedGraph name='"'"$item"'"' visibility=FULL color=0,0,255 altColor=255,0,0 graphType=bar' | gzip > ${item}.gz
        rm ${item}
	done
printf "=%.0s" {1..80}; printf "\n\n"

} 2>&1 | tee ${outpath}bdg_log2/bdg_log2.log
