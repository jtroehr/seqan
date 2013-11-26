#!/bin/sh
#
# We create variants from a randomly generated genome.

GENOME=../../../../../seqan-git-build/debug/bin/mason_genome
METHYLATION=../../../../../seqan-git-build/debug/bin/mason_methylation
VARIATOR=../../../../../seqan-git-build/debug/bin/mason_variator
MATERIALIZER=../../../../../seqan-git-build/debug/bin/mason_materializer
SIMULATOR=../../../../../seqan-git-build/debug/bin/mason_simulator

# ============================================================
# mason_genome
# ============================================================

echo "${GENOME} -l 1000 -o genome.test1.fasta >genome.test1.stdout 2>genome.test1.stderr"
${GENOME} -l 1000 -o genome.test1.fasta >genome.test1.stdout 2>genome.test1.stderr
echo "${GENOME} -s 1 -l 1000 -l 100 -o genome.test2.fasta >genome.test2.stdout 2>genome.test2.stderr"
${GENOME} -s 1 -l 1000 -l 100 -o genome.test2.fasta >genome.test2.stdout 2>genome.test2.stderr
echo $?

# ============================================================
# mason_methylation
# ============================================================

echo "${METHYLATION} --seed 33 -i random.fasta -o random_meth1.fasta 1>methylation.test1.stdout 2>methylation.test2.stderr"
${METHYLATION} --seed 33 -i random.fasta -o random_meth1.fasta 1>methylation.test1.stdout 2>methylation.test2.stderr
echo $?

# ============================================================
# mason_variator
# ============================================================

# Generating methylation in variator.
echo "${VARIATOR} -n 2 -ir random.fasta -ov random_var1.vcf -of random_var1.fasta --snp-rate 0.001 --small-indel-rate 0.001 --sv-indel-rate 0.001 --sv-inversion-rate 0.001 --sv-translocation-rate 0.001 --sv-duplication-rate 0.001 --min-sv-size 50 --max-sv-size 100 --methylation-levels --meth-fasta-out random_var1_meth.fasta --out-breakpoints random_var1_bp.txt >random_var1.vcf.stdout 2>random_var1.vcf.stderr"
${VARIATOR} -n 2 -ir random.fasta -ov random_var1.vcf -of random_var1.fasta --snp-rate 0.001 --small-indel-rate 0.001 --sv-indel-rate 0.001 --sv-inversion-rate 0.001 --sv-translocation-rate 0.001 --sv-duplication-rate 0.001 --min-sv-size 50 --max-sv-size 100 --methylation-levels --meth-fasta-out random_var1_meth.fasta --out-breakpoints random_var1_bp.txt >random_var1.vcf.stdout 2>random_var1.vcf.stderr
echo $?

# Loading methylation into variator.
echo "${VARIATOR} -n 2 -ir random.fasta -ov random_var2.vcf -of random_var2.fasta --snp-rate 0.001 --small-indel-rate 0.001 --sv-indel-rate 0.001 --sv-inversion-rate 0.001 --sv-translocation-rate 0.001 --sv-duplication-rate 0.001 --min-sv-size 50 --max-sv-size 100 --methylation-levels --meth-fasta-in random_meth1.fasta --meth-fasta-out random_var2_meth.fasta --out-breakpoints random_var2_bp.txt >random_var2.vcf.stdout 2>random_var2.vcf.stderr"
${VARIATOR} -n 2 -ir random.fasta -ov random_var2.vcf -of random_var2.fasta --snp-rate 0.001 --small-indel-rate 0.001 --sv-indel-rate 0.001 --sv-inversion-rate 0.001 --sv-translocation-rate 0.001 --sv-duplication-rate 0.001 --min-sv-size 50 --max-sv-size 100 --methylation-levels --meth-fasta-in random_meth1.fasta --meth-fasta-out random_var2_meth.fasta --out-breakpoints random_var2_bp.txt >random_var2.vcf.stdout 2>random_var2.vcf.stderr
echo $?

# Variation without methylation.
echo "${VARIATOR} -n 2 -ir random.fasta -ov random_var3.vcf -of random_var3.fasta --snp-rate 0.001 --small-indel-rate 0.001 --sv-indel-rate 0.001 --sv-inversion-rate 0.001 --sv-translocation-rate 0.001 --sv-duplication-rate 0.001 --min-sv-size 50 --max-sv-size 100 --out-breakpoints random_var3_bp.txt >random_var3.vcf.stdout 2>random_var3.vcf.stderr"
${VARIATOR} -n 2 -ir random.fasta -ov random_var3.vcf -of random_var3.fasta --snp-rate 0.001 --small-indel-rate 0.001 --sv-indel-rate 0.001 --sv-inversion-rate 0.001 --sv-translocation-rate 0.001 --sv-duplication-rate 0.001 --min-sv-size 50 --max-sv-size 100 --out-breakpoints random_var3_bp.txt >random_var3.vcf.stdout 2>random_var3.vcf.stderr
echo $?

# Variation that crashed previously.
echo "${VARIATOR} -ir adeno_virus.fa -ov random_var9.vcf -of random_var9.fasta --sv-indel-rate 0.01 --sv-inversion-rate 0.01 --sv-duplication-rate 0.01 --min-sv-size 20  --max-sv-size 300 >random_var9.vcf.stdout 2>random_var9.vcf.stderr"
${VARIATOR} -ir adeno_virus.fa -ov random_var9.vcf -of random_var9.fasta --sv-indel-rate 0.01 --sv-inversion-rate 0.01 --sv-duplication-rate 0.01 --min-sv-size 20  --max-sv-size 300 >random_var9.vcf.stdout 2>random_var9.vcf.stderr
echo $?

# ============================================================
# mason_materializer
# ============================================================

# Without methylation levels.
echo "${MATERIALIZER} -ir random.fasta -iv random_var1.vcf -o materializer.random_var1.fasta >materializer.random_var1.stdout 2>materializer.random_var1.stderr"
${MATERIALIZER} -ir random.fasta -iv random_var1.vcf -o materializer.random_var1.fasta >materializer.random_var1.stdout 2>materializer.random_var1.stderr
rm -f materializer.random_var1.fasta  # we'll compare against variator output
echo $?
# With methylation levels.
echo "${MATERIALIZER} -ir random.fasta -iv random_var2.vcf -o materializer.random_var2.fasta --meth-fasta-in random_meth1.fasta --meth-fasta-out materializer.random_meth2.fasta >materializer.random_var2.stdout 2>materializer.random_var2.stderr"
${MATERIALIZER} -ir random.fasta -iv random_var2.vcf -o materializer.random_var2.fasta --meth-fasta-in random_meth1.fasta --meth-fasta-out materializer.random_meth2.fasta >materializer.random_var2.stdout 2>materializer.random_var2.stderr
rm -f materializer.random_var2.fasta materializer.random_meth2.fasta  # we'll compare against variator output
echo $?

# ============================================================
# mason_simulator
# ============================================================

# ------------------------------------------------------------
# Illumina Tests
# ------------------------------------------------------------

# Without VCF variants, FASTQ output, with SAM alignments, paired-end
echo "${SIMULATOR} -n 1000 -ir random.fasta -o simulator.left1.fq -or simulator.right1.fq -oa simulator.out1.sam >simulator.out1.stdout 2>simulator.out1.stderr"
${SIMULATOR} -n 1000 -ir random.fasta -o simulator.left1.fq -or simulator.right1.fq -oa simulator.out1.sam >simulator.out1.stdout 2>simulator.out1.stderr
echo $?

# With VCF variants, FASTQ output, with SAM alignment, paired-end
echo "${SIMULATOR} -n 1000 -ir random.fasta -iv random_var1.vcf -o simulator.left2.fq -or simulator.right2.fq -oa simulator.out2.sam >simulator.out2.stdout 2>simulator.out2.stderr"
${SIMULATOR} -n 1000 -ir random.fasta -iv random_var1.vcf -o simulator.left2.fq -or simulator.right2.fq -oa simulator.out2.sam >simulator.out2.stdout 2>simulator.out2.stderr
echo $?

# With VCF variants, FASTA output, with SAM alignments, single-end
echo "${SIMULATOR} -n 1000 -ir random.fasta -iv random_var1.vcf -o simulator.left7.fa -oa simulator.out7.sam >simulator.out7.stdout 2>simulator.out7.stderr"
${SIMULATOR} -n 1000 -ir random.fasta -iv random_var1.vcf -o simulator.left7.fa -oa simulator.out7.sam  >simulator.out7.stdout 2>simulator.out7.stderr
echo $?

# Without VCF variants, FASTA output, no SAM alignments, paired-end
echo "${SIMULATOR} -n 1000 -ir random.fasta -o simulator.left3.fa -or simulator.right3.fa >simulator.out3.stdout 2>simulator.out3.stderr"
${SIMULATOR} -n 1000 -ir random.fasta -o simulator.left3.fa -or simulator.right3.fa >simulator.out3.stdout 2>simulator.out3.stderr
echo $?

# Without VCF variants, FASTA output, no SAM alignments, single-end
echo "${SIMULATOR} -n 1000 -ir random.fasta -o simulator.left4.fa -oa simulator.out4.sam >simulator.out4.stdout 2>simulator.out4.stderr"
${SIMULATOR} -n 1000 -ir random.fasta -o simulator.left4.fa -oa simulator.out4.sam >simulator.out4.stdout 2>simulator.out4.stderr
echo $?

# Without VCF variants, FASTQ output, no SAM alignment, paired-end, BS-seq.
echo "${SIMULATOR} -n 1000 -ir random.fasta --meth-fasta-in random_meth1.fasta --methylation-levels --enable-bs-seq -o simulator.left5.fq -or simulator.right5.fq >simulator.out5.stdout 2>simulator.out5.stderr"
${SIMULATOR} -n 1000 -ir random.fasta --meth-fasta-in random_meth1.fasta --methylation-levels --enable-bs-seq -o simulator.left5.fq -or simulator.right5.fq >simulator.out5.stdout 2>simulator.out5.stderr
echo $?

# Without VCF variants, FASTQ output, no SAM alignment, paired-end, BS-seq.
echo "${SIMULATOR} -n 1000 -ir random.fasta --meth-fasta-in random_meth1.fasta -iv random_var1.vcf --methylation-levels --enable-bs-seq -o simulator.left6.fq -or simulator.right6.fq >simulator.out6.stdout 2>simulator.out6.stderr"
${SIMULATOR} -n 1000 -ir random.fasta --meth-fasta-in random_meth1.fasta -iv random_var1.vcf --methylation-levels --enable-bs-seq -o simulator.left6.fq -or simulator.right6.fq >simulator.out6.stdout 2>simulator.out6.stderr
echo $?

# ------------------------------------------------------------
# 454 Tests
# ------------------------------------------------------------

# Without VCF variants, FASTQ output, with SAM alignments, paired-end
echo "${SIMULATOR} -v --seq-technology 454 -n 1000 -ir random.fasta -o simulator.left8.fq -oa simulator.out8.sam --fragment-mean-size 800 --454-read-length-mean 200 --454-read-length-stddev 20 >simulator.out8.stdout 2>simulator.out8.stderr"
${SIMULATOR} -v --seq-technology 454 -n 1000 -ir random.fasta -o simulator.left8.fq -oa simulator.out8.sam --fragment-mean-size 800 --454-read-length-mean 200 --454-read-length-stddev 20 >simulator.out8.stdout 2>simulator.out8.stderr
echo $?
