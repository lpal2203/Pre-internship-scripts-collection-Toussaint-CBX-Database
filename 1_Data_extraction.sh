#!/bin/bash


    conda activate /home/cody/.conda/envs/sratoolkit
    #Searching a reference mitochondrial genomes in first GenBank format and then fasta format
    esearch -db nuccore -query "\"mitochondrion\"[All Fields] AND (\"Carabidae\"[Organism]) AND (refseq[filter] AND mitochondrion[filter] AND (\"12000\"[SLEN] : \"20000\"[SLEN]))" | efetch -format gbwithparts > reference.gb
    esearch -db nuccore -query "\"mitochondrion\"[All Fields] AND (\"Carabidae\"[Organism]) AND (refseq[filter] AND mitochondrion[filter] AND (\"12000\"[SLEN] : \"20000\"[SLEN]))" | efetch -format fasta > reference.fasta
    #Searching for barcodes (of exactly 658 nucletides) in fasta format
    esearch -db nuccore -query "barcode (Carabidae[Organism]) 658[SLEN]" | efetch -format fasta > barcode.fasta


    # record which sequences are excluded
    awk '/^>/{if(NR>1&&p)printf "%s",r; r=$0 ORS; p=0; next} $0~/[Nn-]/{p=1} {r=r $0 ORS} END{if(p)printf "%s",r}' barcode.fasta > barcode_gaps.fasta
    # now exclude
    awk '/^>/{if(NR>1&&p)printf "%s",r; r=$0 ORS; p=1; next} $0~/[Nn-]/{p=0} {r=r $0 ORS} END{if(p)printf "%s",r}' barcode.fasta > tmp.fasta
    # identify taxnomic uncertainty
    awk '/^>/{if(NR>1&&p)printf "%s",r; r=$0 ORS; p=($0~/(Carabidae|Coleoptera) sp\./); next} {r=r $0 ORS} END{if(p)printf "%s",r}' tmp.fasta > barcode_taxanomic_uncertainty.fasta
    # final clean script
    awk '/^>/{if(NR>1&&p)printf "%s",r; r=$0 ORS; p=($0!~/(Carabidae|Coleoptera) sp\./); next} {r=r $0 ORS} END{if(p)printf "%s",r}' tmp.fasta > barcode_clean.fasta


    awk 'FNR==1{lib=FILENAME;sub(/_IDs\.list$/,"",lib)}{print lib "," $1}' FILENAME_IDs.list > samples_FILENAME.list
