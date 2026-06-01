#!/bin/bash
CORES=$1
 source /local/anaconda3/bin/activate
 conda activate /home/cody/.conda/envs/assembly


 #awk 'FNR==1{lib=FILENAME;sub(/_IDs\.list$/,"",lib)}{print lib "," $1}' Calosoma_lib1_IDs.list > ./2_BARCODES/samples_Calosoma_lib1.list




 # getorganelle
 # basically the same process but comparing the two analyses will be useful
 WORKING=/data/work/Toussaint_UCE
 while read LIST; do
    SAMP=$(echo ${LIST} | cut -d "," -f 2)
    LIB=$(echo ${LIST} | cut -d "," -f 1)
    DATAPATH=${WORKING}/1_ASSEMBLED/${LIB}/trimmed # from LIST
    REFPATH=${WORKING}/2_BARCODES/CARABARCODES
   
    # removed this flag, it seems useful for barcodes rather than whole mtDNA genomes
    #   --max-extending-len 100 \
    get_organelle_from_reads.py \
        -1 ${DATAPATH}/${SAMP}_r1.fastq.gz \
        -2 ${DATAPATH}/${SAMP}_r2.fastq.gz \
        -o ${REFPATH}/NAMEOFTHEGENUS_libX_GO/${SAMP}_GO/ \
        -P 0 \
        -F anonym \
        -s ${REFPATH}/Scripts/reference.fasta \
        --genes ${REFPATH}/Scripts/reference.fasta \
        --expected-max-size 20000 \
        -t ${CORES};
 done < ${WORKING}/2_BARCODES/CARABARCODES/samples_NAMEOFTHEGENUS_libX.list
