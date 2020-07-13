#!/bin/bash
#$ -V
#$ -cwd

module load STAR #need to source module command, hence 'source run.sh' vs './run.sh'
#for one sample: 
#~20min for alignment with STAR
#~5 min for counting with featureCounts

#insufficient RAM with 10 gigs -- trying with 50 gigs works correctly 
snakemake -j 99 --cluster "qsub -l h_data=50G,h_rt=04:00:00 -cwd -V"
