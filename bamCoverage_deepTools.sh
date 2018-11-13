#!/bin/bash

# SCRIPT: bamCoverage_deepTool.sh
# AUTHOR: Mark Boltengagen
# VERSION: v12-04-2018
# OS: Linux Ubuntu 16.04 LTS
# DESCRIPTION: Count reads depth in a bam file, return bedgraph file
# USED TOOLS: deepTools

### PARAMETERS
exppath='/home/suvar/Projects/006_ChIPseq_HDACs/'
outpath=${exppath}output/
threads=8

bin=500

{
##### DeepTools coverage of bam files

cd ${outpath}fbam
mkdir ${outpath}bam_cov
printf "$(date)\tBAM COVERAGE STARTS\n\n"

for item in *.bam
	do
		if [[ ! -e "${item}.bai" ]]
        then
        printf "$(date)\tStarted index of bam ${item}\n"
		samtools index $item -@ ${threads}
        fi

        printf "$(date)\tStarted bam coverage of ${item}\n"
        bamCoverage --bam $item -o ${outpath}bam_cov/${item%.bam}.bg \
            -p ${threads} \
            --binSize $bin  \
            --normalizeUsing RPKM  \
            --effectiveGenomeSize 12122800  \
            --outFileFormat bedgraph

		
        printf "$(date)\tStarted splitting merged bins of ${item%.bam}.bg \n\n"
        # Split merged regions per bin
        awk -v bin="$bin" '{ for (i = 1; i <= ($3-$2)/bin; i++) {
            start=$2+i*bin-bin
            end=$2+i*bin
            print $1 "\t" start "\t" end "\t" $4 } }' ${outpath}bam_cov/${item%.bam}.bg | gzip > ${outpath}bam_cov/${item%.bam}_bins.bg.gz
        
        # Remove bg files with merged regions
        rm ${outpath}bam_cov/${item%.bam}.bg

        printf "$(date)\tCompleted bam coverage of ${item}\n\n"

	done
printf "=%.0s" {1..70}; printf "\n\n"

} 2>&1 | tee ${outpath}bam_cov/bam_coverage.log
