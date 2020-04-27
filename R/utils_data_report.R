#' @include utils_classes.R

setGeneric("initialDataReport", function(input, print_pdf, pdf_path = ".", 
                                         pdf_name = "MSstats_data_report.pdf", 
                                         ...) {
    standardGeneric("initialDataReport")
}, signature = "input")

setMethod("initialDataReport", signature = "MSstatsLabelFree", 
          function(input, print_pdf, pdf_path = ".", 
                   pdf_name = "MSstats_data_report.pdf", 
                   ...) {
    
})

setMethod("initialDataReport", signature = "MSstatsLabeled", 
          function(input, print_pdf, pdf_path = ".", 
                   pdf_name = "MSstats_data_report.pdf", 
                   ...) {
    
})

setMethod("initialDataReport", signature = "MSstatsTMT", 
          function(input, print_pdf, pdf_path = ".", 
                   pdf_name = "MSstats_data_report.pdf", 
                   ...) {
    
})


# TODO: decide what we want to include
# # proteins, # peptides, # runs, etc
# # peptides per protein, # features per protein, # num proteins per peptide (if any shared)
# distribution of condition, bioreplicate etc (=design experiment) ?
# 