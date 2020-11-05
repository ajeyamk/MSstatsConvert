#!/usr/bin/env Rscript


if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

if (!requireNamespace("devtools", quietly = TRUE))
    install.packages("devtools")

if (!requireNamespace("paws", quietly = TRUE))
    install.packages("paws")

BiocManager::install("MSstats")
devtools::install_github("Vitek-Lab/MSstats-dev", ref = "refactoring")

#load all the config settings/credentials
source("/home/rstudio/code/config.R")

#set aws session variables
Sys.setenv(
    AWS_ACCESS_KEY_ID = aws_key,
    AWS_SECRET_ACCESS_KEY = aws_secret,
    AWS_REGION = aws_region
)
#initialise s3 object
s3 <- paws::s3()
# quick smoke test to check bucket contents
s3$list_buckets()

# `load()` R objects from S3
frags = s3$get_object(Bucket = aws_bucket_name,Key = "Navarro2016_DIA_DIAumpire_input_FragSummary.RDS")
pepts = s3$get_object(Bucket = aws_bucket_name,Key = "Navarro2016_DIA_DIAumpire_input_PeptideSummary.RDS")
prots = s3$get_object(Bucket = aws_bucket_name,Key = "Navarro2016_DIA_DIAumpire_input_ProtSummary.RDS")
dia_annot = s3$get_object(Bucket = aws_bucket_name,Key = "Navarro2016_DIA_DIAumpire_input_annotation.RDS")

diau = MSstatsdev::DIAUmpiretoMSstatsFormat(frags, pepts, prots, dia_annot)
diau_v3 = MSstats::dataProcess(as.data.frame(unclass(diau)), MBimpute = TRUE)
diau_v4 = MSstatsdev::dataProcess(diau, MBimpute = TRUE)

# to check if we can store the rds object to S3
s3$put_object(Body = diau_v4, Bucket = aws_bucket_name, Key = "from-ec2.rds")
# aws.s3::s3saveRDS(x = diau_v4, bucket = aws_bucket_name, object = "from-ec2.rds")
