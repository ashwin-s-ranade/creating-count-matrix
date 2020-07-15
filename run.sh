#!/bin/bash
#$ -V
#$ -cwd

#for one sample: 
#~20min for alignment with STAR
#~5 min for counting with featureCounts

#insufficient RAM with 10 gigs -- trying with 50 gigs works correctly
#requires '-pe shared' * 'h_data' data, trying 4 * 10 = 40G right now  
#'-pe shared 4' = 4 threads
snakemake -j 99 -p --cluster "qsub -pe shared 4 -l h_data=10G,h_rt=01:00:00 -cwd -V" 
mail -s "snakemake finished" asr123@ucla.edu
