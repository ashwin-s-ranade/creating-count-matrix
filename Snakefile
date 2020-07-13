BASE = '/u/project/zarlab/hjp/geuvadis_data' 
OUTPUT_DIR = '/u/home/a/asr123/project-zarlab'
N_THREADS = 8
STAR_DIR = OUTPUT_DIR + '/starOutputDir' 
FEATURE_DIR = OUTPUT_DIR + '/featureCountsData'

SAMPLE_KEYS = sorted(os.listdir(BASE + '/rna'))

rule getAllCounts: 
    input: 
        expand(FEATURE_DIR + '/{sample}/{sample}_counts.txt', sample=SAMPLE_KEYS)
    shell: 
        "rm snakejob*"

#align reads with STAR (assume tempGenomeDir already created) 
rule align_reads: 
    input: 
        left = BASE + '/rna/{sample}/{sample}_1.fastq.gz',
        right = BASE + '/rna/{sample}/{sample}_2.fastq.gz',   
        genome_dir = OUTPUT_DIR + '/tempGenomeDir'
    params: 
        output_folder = STAR_DIR + '/{sample}/' 
    output:
        STAR_DIR + '/{sample}/Aligned.sortedByCoord.out.bam'
    shell: 
        "STAR --runThreadN {N_THREADS}"
        " --runMode alignReads" 
        " --genomeDir {input.genome_dir}"
        " --readFilesCommand zcat"
        " --readFilesIn {input.left} {input.right}"
        " --outFileNamePrefix {params.output_folder}"
        " --outSAMtype BAM SortedByCoordinate"        

rule generateCountMatrices:
    input:
        STAR_DIR + '/{sample}/Aligned.sortedByCoord.out.bam'
    params:
        anno = BASE + '/annotation/gencode.v34.annotation.gff3'
    output:
        FEATURE_DIR + '/{sample}/{sample}_counts.txt'
    shell:
        "featureCounts -p -a {params.anno}"
        " -o {output}"
        " {input}"
 
