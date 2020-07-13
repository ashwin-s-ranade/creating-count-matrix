#!/bin/bash
#$ -V
#$ -cwd

#module load STAR #need to source module command, hence 'source run.sh' vs './run.sh'
#for one sample: 
#~20min for alignment with STAR
#~5 min for counting with featureCounts

#insufficient RAM with 10 gigs -- trying with 50 gigs works correctly 
snakemake -j 99 -p --cluster "qsub -l h_data=50G,h_rt=01:00:00 -cwd -V" 
mail -s "snakemake finished" asr123@ucla.edu
