#!/bin/bash

# SCRIPT: bamCoverage_deepTool.sh
# AUTHOR: Mark Boltengagen
# VERSION: v23-04-2018
# OS: Linux Ubuntu 16.04 LTS
# DESCRIPTION: Compair BigWigs and make a new bigwig with ratio diffrence
# USED TOOLS: deepTools

### PARAMETERS
exppath='/home/suvar/Projects/006_ChIPseq_HDACs/'
outpath=${exppath}output/
threads=4

##### DeepTools coverage of bam files
cd ${outpath}bw
mkdir ${outpath}bdg_ratio
{
##### BedGraph to BigWig conversion
## Fist file is a control
bw_control=$( ls | head -1 )

for bw_treat in *.bw
	do
		printf "$(date)\tBigWig compair of ${bw_treat} with ${bw_control}\n"
            #  ratio( bigwig1 / bigwig 2) = ( treatment / control )
            bigwigCompare --bigwig1 ${bw_treat} \
                  --bigwig2 ${bw_control} \
                  --operation ratio \
                  --binSize 1 \
                  --outFileName ${outpath}bdg_ratio/${bw_treat%.bw}.bdg \
                  --outFileFormat bedgraph \
                  -p ${threads}

        printf "$(date)\tCompleted BigWig compair of ${bw_treat} with ${bw_control}\n\n"

	done
printf "=%.0s" {1..70}; printf "\n\n"

##### BDG SORTING

cd ${outpath}bdg_ratio

for item in *.bdg
	do
	## Sort bdg file
        LC_COLLATE=C sort -k1,1 -k2,2n $item | gzip > ${outpath}bdg_ratio/${item}.gz
        rm $item
	done
printf "=%.0s" {1..80}; printf "\n\n"
#####=======================================================

} 2>&1 | tee ${outpath}bdg_ratio/log.txt
