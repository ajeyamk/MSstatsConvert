#!/usr/bin/env Rscript

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