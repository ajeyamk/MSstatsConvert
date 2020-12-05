library(data.table)

invoke_dataprocess<-function(input_file, summary_method="linear", mb_impute=FALSE,
                             censored_int="0"){
  # parameterized data process function
  
  #against stable version
  output_stable = MSstats::dataProcess(as.data.frame(unclass(input_file)), 
                                       summaryMethod=summary_method, 
                                       MBimpute=mb_impute, 
                                       censoredInt=censored_int)
  #against dev version
  output_dev = MSstatsdev::dataProcess(input_file, 
                                       summaryMethod=summary_method, 
                                       MBimpute=mb_impute, 
                                       censoredInt=censored_int)
  return(list(stable=output_stable, dev=output_dev))
}

compare_values_processed_data <- function(input_df){
  #couldn't make this logic work. Saving for later
  #this logic is overkilled for now. Need to handle columns more flexibly
  input_df$match.orgint <- input_df$INTENSITY.x == input_df$INTENSITY.y
  input_df$match.abn <- input_df$ABUNDANCE.x == input_df$ABUNDANCE.y
  input_df$match.censored <- input_df$censored.x == input_df$censored.y
  input_df$match.ftrslct <- input_df$feature_quality.x == input_df$feature_quality.y
  input_df$match.otr <- input_df$is_outlier.x == input_df$is_outlier.y
  return(input_df)
}

compare_values_runlevel_data <- function(input_df){
  #this logic is overkilled for now. Need to handle columns more flexibly
  input_df$match.int <- input_df$LogIntensities.x == input_df$LogIntensities.y
  input_df$match.perc <- input_df$MissingPercentage.x == input_df$MissingPercentage.y
  input_df$match.numimpf <- input_df$NumImputedFeature.x == input_df$NumImputedFeature.y
  input_df$match.nummsrf <- input_df$NumMeasuredFeature.x == input_df$NumMeasuredFeature.y
  return(input_df)
}

handle_na_values_processed_data <- function(input_df ){
  ## if both NA, they also match.
  input_df[is.na(
    input_df$INTENSITY.x) & is.na(input_df$INTENSITY.y), 'match.orgint'] <- TRUE
  input_df[is.na(
    input_df$ABUNDANCE.x) & is.na(input_df$ABUNDANCE.y), 'match.abn'] <- TRUE
  input_df[is.na(
    input_df$censored.x) & is.na(input_df$censored.y), 'match.censored'] <- TRUE
  input_df[is.na(
    input_df$feature_quality.x) & is.na(input_df$feature_quality.y), 'match.ftrslct'] <- TRUE
  input_df[is.na(
    input_df$is_outlier.x) & is.na(input_df$is_outlier.y), 'match.otr'] <- TRUE
  
  ## others, should be FALSE : if one of them NA, match column NA -> change to FALSE
  input_df[is.na(input_df$match.orgint), 'match.orgint'] <- FALSE
  input_df[is.na(input_df$match.abn), 'match.abn'] <- FALSE
  input_df[is.na(input_df$match.censored), 'match.censored'] <- FALSE
  input_df[is.na(input_df$match.ftrslct), 'match.ftrslct'] <- FALSE
  input_df[is.na(input_df$match.otr), 'match.otr'] <- FALSE
  return(input_df)
}

handle_na_values_runlevel_data <- function(input_df){
  input_df[is.na(input_df$LogIntensities.x) & is.na(
    input_df$LogIntensities.y), 'match.int'] <- TRUE
  input_df[is.na(input_df$MissingPercentage.x) & is.na(
    input_df$MissingPercentage.y), 'match.perc'] <- TRUE
  input_df[is.na(input_df$NumImputedFeature.x) & is.na(
    input_df$NumImputedFeature.y), 'match.numimpf'] <- TRUE
  input_df[is.na(input_df$NumMeasuredFeature.x) & is.na(
    input_df$NumMeasuredFeature.y), 'match.nummsrf'] <- TRUE
  
  ## others, should be FALSE : if one of them NA, match column NA -> change to FALSE
  input_df[is.na(input_df$match.int), 'match.int'] <- FALSE
  input_df[is.na(input_df$match.perc), 'match.perc'] <- FALSE
  input_df[is.na(input_df$match.numimpf), 'match.numimpf'] <- FALSE
  input_df[is.na(input_df$match.nummsrf), 'match.nummsrf'] <- FALSE
  return(input_df)
}

possible_feature_columns = c("PeptideSequence", "PeptideModifiedSequence",
                             "PrecursorCharge", "Charge", "FragmentIon", "ProductCharge")

count_features = function(df) {
  cols = intersect(colnames(df), possible_feature_columns)
  uniqueN(df[, cols, with = FALSE])
}

count_proteins = function(df) {
  uniqueN(df[, "ProteinName", with = FALSE])
}

count_peptides = function(df) {
  pep_col = intersect(colnames(df), c("PeptideSequence", "PeptideModifiedSequence"))
  uniqueN(df[, pep_col, with = FALSE])
}

get_features_per_protein = function(df) {
  paste_ = function(...) paste(..., sep = "_")
  # df = as.data.table(as(as(df, "MSstatsValidated"), "data.frame"))
  cols = intersect(colnames(df), possible_feature_columns)
  df$feature = do.call("paste_", as.list(df[, cols, with = FALSE]))
  df[, .(n_features = uniqueN(feature)), by = "ProteinName"]
}

get_mean_features_per_protein = function(features_df) {
  mean(features_df$n_features, na.rm = TRUE)
}

count_missing_values = function(df) {
  sum(is.na(df$Intensity), na.rm = TRUE)
}

count_infinite = function(df) {
  sum(!is.finite(df$Intensity))
}

count_zero_values = function(df) {
  sum(abs(df$Intensity) < 1e-6, na.rm = TRUE)
}

count_exactly_zero = function(df) {
  sum(df$Intensity == 0, na.rm = TRUE)
}

get_ram_size = function(df) {
  pryr::object_size(df)
}

get_disk_size = function(file_path) {
  file.info(file_path)$size / 1e6
}

count_rows = function(df) {
  nrow(df)
}

count_cols = function(df) {
  ncol(df)
}

count_measurements = function(df) {
  paste_ = function(...) paste(..., sep = "_")
  cols = intersect(colnames(df), possible_feature_columns)
  df$feature = do.call("paste_", as.list(df[, cols, with = FALSE]))
  count_by = intersect(colnames(df), c("ProteinName", cols, "Run", "Channel"))
  df[, .(n_measurement = .N), by = count_by]
}

count_fractions = function(df) {
  if (is.element("Fraction", colnames(df))) {
    uniqueN(df$Fraction)
  } else {
    NA
  }
}

count_design = function(df, col) {
  if (is.element(col, colnames(df))) {
    uniqueN(df[, col, with = FALSE])
  } else {
    NA
  }
}

count_larger_than = function(df, threshold) {
  sum(df$Intensity > threshold, na.rm = TRUE)
}

count_01 = function(df) {
  sum(!is.na(df$Intensity) & df$Intensity > 0 & df$Intensity <= 1)
}

getStatsSingleVersion = function(df, version) {
  data.table(
    version = version,
    n_features = count_features(df),
    n_proteins = count_proteins(df),
    n_peptides = count_peptides(df),
    n_infinite = count_infinite(df),
    n_missing = count_missing_values(df),
    n_zero = count_zero_values(df),
    n_exactly_zero = count_exactly_zero(df),
    n_greater_than_0 = count_larger_than(df, 0),
    n_greater_than_1 = count_larger_than(df, 1),
    n_between_0_1 = count_01(df),
    n_rows = count_rows(df),
    n_cols = count_cols(df),
    n_conditions = count_design(df, "Condition"),
    n_bioreps = count_design(df, "BioReplicate"),
    n_runs = count_design(df, "Run"),
    n_tech_replicates = count_design(df, "TechRep"),
    n_tech_rep_mixture = count_design(df, "TechRepMixture"),
    n_fractions = count_fractions(df),
    n_channels = count_design(df, "Channel"))
}
getStats = function(v3, v4) {
  rbindlist(
    list(getStatsSingleVersion(as.data.table(v3), "v3"),
         getStatsSingleVersion(as.data.table(as(v4, "data.frame")), "v4"))
  )
  # list(class(v3), class(v4))
}