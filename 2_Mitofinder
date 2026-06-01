#!/bin/bash
CORES=$1
 source /local/anaconda3/bin/activate
 conda activate /home/cody/.conda/envs/singularity


 WORKING=/data/work/Toussaint_UCE #singularity requires explicit paths, no symlinks!
 while read LIST; do
    SAMP=$(echo ${LIST} | cut -d "," -f 2)
    LIB=$(echo ${LIST} | cut -d "," -f 1)
    DATAPATH=${WORKING}/1_ASSEMBLED/${LIB}/spades/${SAMP} # from samples.lis
    REFPATH=${WORKING} # where the .gb files live


    singularity run -B ${DATAPATH}:${DATAPATH},${REFPATH}:${REFPATH} \
        ${WORKING}/2_BARCODES/mitofinder_v1.4.2.sif \
        -j ${SAMP}_MF \
        -r ${REFPATH}/2_BARCODES/reference.gb \
        -a ${DATAPATH}/contigs.fasta \
        -o 5 \
        -p ${CORES} \
        --rename-contig no;
 done < ${WORKING}/samples.list
