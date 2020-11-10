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

# helper functions to read  binary files from s3
read_bin_files_s3 <- function(bin_file, file_name){
    writeBin(bin_file, con = file_name)
    rds_file <- readRDS(file_name)
    unlink(file_name)
    return (rds_file)
}

#helper functions to write binary files to s3
write_bin_files_s3 <- function(r_object, file_name){
    saveRDS(r_object, file = file_name)
    # Load the file as a raw binary
    read_file <- file(file_name, "rb")
    bin_file <- readBin(read_file, "raw", n = file.size(file_name))
    unlink(file_name)
    return(bin_file)
}
# `load()` R objects from S3
frags <- s3$get_object(Bucket = aws_bucket_name, 
                       Key = "Navarro2016_DIA_DIAumpire_input_FragSummary.RDS")
frags <- read_bin_files_s3(frags$Body, "frags.rds")

pepts <- s3$get_object(Bucket = aws_bucket_name,
                       Key = "Navarro2016_DIA_DIAumpire_input_PeptideSummary.RDS")
pepts <- read_bin_files_s3(pepts$Body, "pepts.rds")

prots <- s3$get_object(Bucket = aws_bucket_name,
                       Key = "Navarro2016_DIA_DIAumpire_input_ProtSummary.RDS")
prots <- read_bin_files_s3(prots$Body, "prots.rds")

dia_annot <- s3$get_object(Bucket = aws_bucket_name,
                           Key = "Navarro2016_DIA_DIAumpire_input_annotation.RDS")
dia_annot <- read_bin_files_s3(dia_annot$Body, "dia_annot.rds")

diau <- MSstatsdev::DIAUmpiretoMSstatsFormat(frags, pepts, prots, dia_annot)
diau_v3 <- MSstats::dataProcess(as.data.frame(unclass(diau)), MBimpute = TRUE)
diau_v4 <- MSstatsdev::dataProcess(diau, MBimpute = TRUE)

# to check if we can store the rds object to S3
s3$put_object(Body = write_bin_files_s3(diau_v4, "dia_annot.rds"), 
              Bucket = aws_bucket_name, Key = "from-ec2.RDS")

rm(list=ls(all=TRUE))