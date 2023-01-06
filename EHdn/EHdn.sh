#!/bin/bash

# generating STR profiles. "locus.tsv, motif.tsv, str_profile.json"

for cram in `cat baylor_samples.txt`;
do
        ExpansionHunterDenovo profile \
                --reads $cram \
                --reference GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa \
                --output-prefix `basename $cram | cut -f1 -d"."` 

done


# merging STR profiles
ExpansionHunterDenovo merge \
        --manifest manifest.tsv \
        --reference ../../GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa \
        --output-prefix baylor_dataset 


# outlier analysis where each sample is labelled as a case

ExpansionHunterDenovo/scripts/outlier.py locus \
  --manifest manifest.tsv \
  --multisample-profile baylor_dataset.multisample_profile.json \
  --output baylor_dataset.outlier_locus.tsv

ExpansionHunterDenovo/scripts/outlier.py motif \
  --manifest manifest.tsv \
  --multisample-profile baylor_dataset.multisample_profile.json \
  --output baylor_dataset.outlier_motif.tsv

# annotation
ExpansionHunterDenovo/scripts/annotate_ehdn.sh \
        --ehdn-results baylor_dataset.outlier_locus.tsv \
        --ehdn-annotated-results annotated_outlier_locus.tsv \
        --annovar-annotate-variation annovar/annotate_variation.pl \
        --annovar-humandb ../humandb \
        --annovar-buildver hg38
