  source /local/anaconda3/bin/activate
    conda activate /home/cody/.conda/envs/blastn


#!/bin/bash   
while read LIST; do
    SAMP=$(echo ${LIST} | cut -d "/" -f 3 | cut -d "." -f 1)
    blastn -db /home/liam/Toussaint_UCE/2_BARCODES/CARABARCODES/Scripts/barcode_clean.fasta \
        -query Symlink/LIBRARY/${SAMP}.fasta \
        -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qseq salltitles" \
        -max_target_seqs 10 \
        -max_hsps 1 \
        -evalue 1e-25 \
        -num_threads 4 \
        -out Bed_and_BlastN/LIBRARY/${SAMP}.blastn;
     awk '$4>max { max=$4; out=$0} END {print out}' Bed_and_BlastN/LIBRARY/${SAMP}.blastn | cut -f 1,7,8  > Bed_and_BlastN/LIBRARY/${SAMP}.bed;
    done < Symlist/symlink_LIBRARY.list


    # that go on Empty file folder
    find ./Bed_and_BlastN/LIBRARY -type f -empty > ./Bed_and_BlastN/Empty_file/empty_blast_calosomalib1.list
    find ./Bed_and_BlastN/LIBRARY -type f -empty -delete


    # cerating a list of all bed files that survive the cleaning
    ls  Bed_and_BlastN/LIBRARY/*.bed > ListSymlink/LIBRARY_bed.list




    conda deactivate;
    conda activate /home/cody/.conda/envs/sam-bam-bedtools;




    while read LIST; do
    SAMP=$(echo ${LIST} | cut -d "/" -f 2 | cut -d "." -f 1)
    bedtools getfasta \
        -fi Symlink/LIBRARY/${SAMP}.fasta \
        -bed Bed_and_BlastN/LIBRARY/${SAMP}.bed \
        > Barcodes/LIBRARY/${SAMP}_barcode.fasta;
    done < Symlist/LIBRARY_bed.list
