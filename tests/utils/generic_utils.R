library(xlsx)

rename_column <- function(df, old_names, new_names){
  setnames(df, old = old_names, new = new_names)
  return(df)
}

merge_dataframes <- function(df1, df2, col_names){
  return(merge(df1, df2, by = setdiff(colnames(df1), col_names), 
               all.x = T, all.y = T))
}

generate_success_xlsx <- function(success_df, file_name){
  write.xlsx(success_df$master_processed_data, file=file_name, 
             sheetName=success_df$data_type, row.names=FALSE)
  write.xlsx(success_df$master_run_level_data, file=file_name, 
             sheetName=success_df$data_type, append=TRUE, row.names=FALSE)
}

generate_error_xlsx <- function(err_df, file_name){
  write.xlsx(err_df, file=file_name, sheetName="exceptions", row.names=FALSE)
}