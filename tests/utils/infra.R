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