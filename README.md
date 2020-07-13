# BIG_Summer_2020
My work in viewing the connection between eQTL analysis and transcript quantification method, done under supervision of Professor Harold Pimentel at UCLA's BIG Summer 2020 Program.

## Programs Needed
snakemake must be installed to use snakefiles\
STAR must be used to create genome index + align reads\ 
featureCounts must be used to generate countMatrices\ 

## Workflow 
Basic pipeline:\
annotation files -> STAR -> genomeIndex\ 
genomeIndex + .fastq.gz files -> STAR -> BAM files\ 
genomeIndex + BAM files -> featureCounts -> count matrices + summary files\ 

## Files 
run.sh -> run on tmux session with `source run.sh`\
Snakefile -> assumes genome index created in `tempGenomeDir`; aligns reads + generates count matrices; doesn't delete files produced by alignment; output in `featureCountInfo`\
star_Snakefile -> creates genome index `tempGenomeDir` and aligns reads (aligned read info in `starOutputDir`)\
