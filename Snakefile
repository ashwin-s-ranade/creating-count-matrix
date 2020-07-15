BASE = '/u/project/zarlab/hjp/geuvadis_data' 
OUTPUT_DIR = '/u/home/a/asr123/project-zarlab'
N_THREADS = 4

STAR_DIR = OUTPUT_DIR + '/starOutputDir'
GENOME_DIR = OUTPUT_DIR + '/tempGenomeDir'
FEATURE_DIR = OUTPUT_DIR + '/featureCountsData'

ANNO = BASE + '/annotation/Homo_sapiens.GRCh37.87.gtf' 
FASTA = BASE + '/annotation/Homo_sapiens.GRCh37.dna_sm.primary_assembly.fa'

SAMPLE_KEY_FILE = BASE + '/annotation/yri_sample_intersection.txt'

SAMPLE_KEYS = sorted([line.rstrip() for line in open(SAMPLE_KEY_FILE, 'r')])

SAMPLE_KEYS = SAMPLE_KEYS[:1]

print(SAMPLE_KEYS)

rule getAllCounts:
    input:
        expand(FEATURE_DIR + '/{sample}/{sample}_counts.txt', sample=SAMPLE_KEYS)
    shell:
        "rm snakejob*"

#align reads with STAR
rule align_reads: 
    input: 
        GENOME_DIR,
        left = BASE + '/rna/{sample}/{sample}_1.fastq.gz',
        right = BASE + '/rna/{sample}/{sample}_2.fastq.gz'   
    params: 
        output_folder = STAR_DIR + '/{sample}/' 
    output:
        STAR_DIR + '/{sample}/Aligned.sortedByCoord.out.bam'
    shell: 
        "STAR --runThreadN {N_THREADS}"
        " --runMode alignReads" 
        " --genomeDir {GENOME_DIR}"
        " --readFilesCommand zcat"
        " --readFilesIn {input.left} {input.right}"
        " --outFileNamePrefix {params.output_folder}"
        " --outSAMtype BAM SortedByCoordinate"         

#get genome indices with STAR
rule get_indices: 
    input:
        FASTA,
        ANNO
    output: 
        genome_dir = directory(GENOME_DIR)
    shell: 
        "mkdir {GENOME_DIR}" 
        "&&"
        "STAR --runThreadN {N_THREADS}"
        " --runMode genomeGenerate"
        " --genomeDir {GENOME_DIR}"
        " --genomeFastaFiles {FASTA}"
        " --sjdbGTFfile {ANNO}"
        " --sjdbOverhang 100"

#get count matrices
rule generateCountMatrices:
    input:
        STAR_DIR + '/{sample}/Aligned.sortedByCoord.out.bam'
    output:
        FEATURE_DIR + '/{sample}/{sample}_counts.txt'
    shell:
        "featureCounts -p -a {ANNO}"
        " -o {output} -T {N_THREADS}"
        " {input}"

 
