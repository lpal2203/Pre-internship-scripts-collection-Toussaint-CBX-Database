#!/bin/bash
while read LIST; do
    SAMPLE=$(echo ${LIST} | cut -d "," -f 2)
ln -s Exact_path_to_the_SAMPLE Exact_path_to_output_directory


find . -xtype l | sort > LIBRARY_check.list
find . -xtype l -delete
