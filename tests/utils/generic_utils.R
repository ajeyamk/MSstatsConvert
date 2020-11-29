library(data.table)

rename_column <- function(df, old_names, new_names){
  setnames(df, old = old_names, new = new_names)
  return(df)
}

merge_dataframes <- function(df1, df2, col_names){
  return(merge(df1, df2, by = setdiff(colnames(df1), col_names), 
               all.x = T, all.y = T))
}