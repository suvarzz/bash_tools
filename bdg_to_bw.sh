#!/bin/bash

# SCRIPT: bamCoverage_deepTool.sh
# AUTHOR: Mark Boltengagen
# VERSION: v12-04-2018
# OS: Linux Ubuntu 16.04 LTS
# DESCRIPTION: Convert BedGraph of peaks to BigWig
# USED TOOLS: bedGraphtoBigWIg

### PARAMETERS
exppath='/home/suvar/Projects/007_ChIPseq_HU-SR/'
inpath=${exppath}output/bdg_log2/
outpath=${exppath}output/bdg_log2/
chromsize='/home/suvar/Projects/Sources'
threads=4

##### DeepTools coverage of bam files
cd ${outpath}
{
##### BedGraph to BigWig conversion
for item in *.bdg.gz; do gunzip -k $item; done

for item in *.bdg
	do
		printf "$(date)\tBedGraph to BigWig conversion of ${item}\n"
        bedGraphToBigWig ${item} ${chromsize}sacCer3.chrom.sizes ${outpath}${item%.bdg}.bw
        printf "$(date)\tCompleted BedGraph to BigWig conversion of ${item}\n\n"

	done
printf "=%.0s" {1..70}; printf "\n\n"
for item in *.bdg; do rm $item; done

} 2>&1 | tee ${outpath}bdg_to_bw.txt

