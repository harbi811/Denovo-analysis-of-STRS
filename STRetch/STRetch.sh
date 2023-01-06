#!/bin/bash

# generates a TSV for each samples while are merged into STRs.tsv

samples=`cat baylor_samples.txt | tr '\n' ' '`

STRetch/tools/bin/bpipe run -p \
    input_regions=reference_data/hg38.simpleRepeat_period1-6.dedup.sorted.bed \
    STRetch/pipelines/STRetch_wgs_bam_pipeline.groovy $samples
