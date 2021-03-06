#' Check validity of parameters to the `MSstatsImport` function.
#' @inheritParams MSstatsImport
#' @return none, throws an error if any of the assertions fail
#' @keywords internal
.checkMSstatsParams = function(input, annotation, 
                               feature_columns,
                               remove_shared_peptides,
                               remove_single_feature_proteins,
                               feature_cleaning) {
    checkmate::assertDataTable(input)
    checkmate::assertTRUE(is.character(annotation) | 
                              inherits(annotation, "data.frame") | 
                              is.null(annotation))
    checkmate::assertCharacter(feature_columns, min.len = 1)
    checkmate::assertLogical(remove_shared_peptides)
    checkmate::assertLogical(
        feature_cleaning[["remove_features_with_few_measurements"]], 
        )
    checkmate::assertLogical(remove_single_feature_proteins)
    checkmate::assertLogical(feature_cleaning[["remove_psms_with_all_missing"]],
                             null.ok = TRUE)
    checkmate::assertFunction(feature_cleaning[["summarize_multiple_psms"]])
}


#' Select an available options from a set of possibilities
#' @param possibilities possible legal values of a variable
#' @param option_set set of values that includes one of the `possibilities`
#' @param fall_back if there is none of the `possibilities` in `option_set`,
#' or there are multiple hits, default to `fall_back`
#' @return same as option_set, usually character
#' @keywords internal
.findAvailable = function(possibilities, option_set, fall_back = NULL) {
    chosen = option_set[option_set %in% possibilities]
    if (length(chosen) != 1L) {
        if (is.null(fall_back)) {
            NULL
        } else {
            if (fall_back %in% possibilities) {
                fall_back
            } else {
                NULL
            }
        }
    } else {
        chosen
    }
}
