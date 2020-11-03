#!/usr/bin/env Rscript


if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

if (!requireNamespace("devtools", quietly = TRUE))
    install.packages("devtools")

if (!requireNamespace("aws.s3", quietly = TRUE))
    install.packages("aws.s3", repos = "https://cloud.R-project.org")

BiocManager::install("MSstats")
devtools::install_github("Vitek-Lab/MSstats-dev", ref = "refactoring")

library(aws.s3)
source("/home/rstudio/code/config.R")

bucket <- aws.s3::get_bucket(
    bucket = aws_bucket_name,
    key = aws_key,
    secret = aws_secret
)

# `load()` R objects from the file
frags = aws.s3::s3readRDS(object = "Navarro2016_DIA_DIAumpire_input_FragSummary.RDS", bucket = "nu-ov-lab-datasets")
pepts = aws.s3::s3readRDS(object = "Navarro2016_DIA_DIAumpire_input_PeptideSummary.RDS", bucket = "nu-ov-lab-datasets")
prots = aws.s3::s3readRDS(object = "Navarro2016_DIA_DIAumpire_input_ProtSummary.RDS", bucket = "nu-ov-lab-datasets")
dia_annot = aws.s3::s3readRDS(object = "Navarro2016_DIA_DIAumpire_input_annotation.RDS", bucket = "nu-ov-lab-datasets")
diau = MSstatsdev::DIAUmpiretoMSstatsFormat(frags, pepts, prots, dia_annot)

diau_v3 = MSstats::dataProcess(as.data.frame(unclass(diau)), MBimpute = TRUE)
diau_v4 = MSstatsdev::dataProcess(diau, MBimpute = TRUE)

aws.s3::s3saveRDS(x = diau_v4, bucket = aws_bucket_name, object = "from-ec2.rds")
