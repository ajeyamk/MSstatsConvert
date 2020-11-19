library(data.table)
# Navarro DIAUmpire
frags = readRDS("./processed_data/DIA-Navarro2016-DIAUmpire/Navarro2016_DIA_DIAumpire_input_FragSummary.RDS")
pepts = readRDS("./processed_data/DIA-Navarro2016-DIAUmpire/Navarro2016_DIA_DIAumpire_input_PeptideSummary.RDS")
prots = readRDS("./processed_data/DIA-Navarro2016-DIAUmpire/Navarro2016_DIA_DIAumpire_input_ProtSummary.RDS")
dia_annot = readRDS("./processed_data/DIA-Navarro2016-DIAUmpire/Navarro2016_DIA_DIAumpire_input_annotation.RDS")

diau = MSstatsdev::DIAUmpiretoMSstatsFormat(frags, pepts, prots, dia_annot)
saveRDS(diau, "diau_input.RDS")
# diau_v3 = MSstats::dataProcess(as.data.frame(unclass(diau)), MBimpute = FALSE)
diau_v3 = MSstats::dataProcess(as.data.frame(unclass(diau)), MBimpute = TRUE)
saveRDS(diau_v3, "diau_v3_dp.RDS")
# diau_v4 = MSstatsdev::dataProcess(diau, MBimpute = FALSE)
diau_v4 = MSstatsdev::dataProcess(diau, MBimpute = TRUE)
saveRDS(diau_v4, "diau_v4_dp.RDS")
# Navarro OpenSWATH
os_input = readRDS("./processed_data/DIA-Navarro2016-OpenSWATH/Navarro2016_DIA_OpenSWATH_input.RDS")
os_annot = readRDS("./processed_data/DIA-Navarro2016-OpenSWATH/Navarro2016_DIA_OpenSWATH_annotation.RDS")
os = MSstatsdev::OpenSWATHtoMSstatsFormat(os_input, os_annot)
saveRDS(os, "os_input.RDS")
# os_v3 = MSstats::dataProcess(as.data.frame(unclass(os)), MBimpute = FALSE,
#                              censoredInt = "0")
os_v3 = MSstats::dataProcess(as.data.frame(unclass(os)), MBimpute = TRUE,
                             censoredInt = "0")
saveRDS(os_v3, "os_v3_dp.RDS")
# os_v4 = MSstatsdev::dataProcess(os, MBimpute = FALSE, censoredInt = "0")
os_v4 = MSstatsdev::dataProcess(os, MBimpute = TRUE, censoredInt = "0")
saveRDS(os_v4, "os_v4_dp.RDS")
# Navarro Skyline
sl_input = readRDS("./processed_data/DIA-Navarro2016-Skyline/Navarro2016_DIA_Skyline_input.RDS")
# sl_input = sl_input[sl_input$ProteinName %in% c("1/sp|C8ZAS4|SEC11_YEAS8", "4/sp|P00330|ADH1_YEAST/tr|D3UEP0|D3UEP0_YEAS8/tr|C8ZFH1|C8ZFH1_YEAS8/tr|C8ZHN0|C8ZHN0_YEAS8"), ]
sl_annot = readRDS("./processed_data/DIA-Navarro2016-Skyline/Navarro2016_DIA_Skyline_annotation.RDS")
sl = MSstatsdev::SkylinetoMSstatsFormat(sl_input, sl_annot)
saveRDS(sl, "sl_input.RDS")
# sl_v3 = MSstats::dataProcess(as.data.frame(unclass(sl)), MBimpute = FALSE,
#                              censoredInt = "0")
sl_v3 = MSstats::dataProcess(as.data.frame(unclass(sl)), MBimpute = TRUE,
                             censoredInt = "0")
saveRDS(sl_v3, "sl_v3_dp.RDS")
# sl_v4 = MSstatsdev::dataProcess(sl, MBimpute = FALSE, censoredInt = "0")
sl_v4 = MSstatsdev::dataProcess(sl, MBimpute = TRUE, censoredInt = "0")
saveRDS(sl_v4, "sl_v4_dp.RDS")
# Navarro Spectronaut
sn_input = readRDS("./processed_data/DIA-Navarro2016-Spectronaut/Navarro2016_DIA_Spectronaut_input.RDS")
sn_annot = readRDS("./processed_data/DIA-Navarro2016-Spectronaut/Navarro2016_DIA_Spectronaut_annotation.RDS")
sn = MSstatsdev::SpectronauttoMSstatsFormat(sn_input, sn_annot)
saveRDS(sn, "sn_input.RDS")
# sn_v3 = MSstats::dataProcess(as.data.frame(unclass(sn)), MBimpute = FALSE,
#                              censoredInt = "0")
sn_v3 = MSstats::dataProcess(as.data.frame(unclass(sn)), MBimpute = TRUE,
                             censoredInt = "0")
saveRDS(sn_v3, "sn_v3_dp.RDS")
# sn_v4 = MSstatsdev::dataProcess(sn, MBimpute = FALSE, censoredInt = "0")
sn_v4 = MSstatsdev::dataProcess(sn, MBimpute = TRUE, censoredInt = "0")
saveRDS(sn_v4, "sn_v4_dp.RDS")
# sn = MSstatsdev::SpectronauttoMSstatsFormat(sn_input[sn_input$PG.ProteinAccessions %in% unique(sn_input$PG.ProteinAccessions)[1:1000], ], sn_annot)
# sn_df = as.data.frame(unclass(sn))
# microbenchmark::microbenchmark(
#     old = MSstats::dataProcess(sn_df, MBimpute = FALSE),
#     new = MSstatsdev::dataProcess(sn, MBimpute = FALSE),
#     times = 3
# )
#
# library(MSstatsdev)
# input = MSstatsPrepareForDataProcess(as.data.frame(unclass(sn)), 2)
# # Normalization, Imputation and feature selection ----
# input = MSstatsNormalize(input, "EQUALIZEMEDIANS") # MSstatsNormalize
# input = MSstatsMergeFractions(input)
# input = MSstatsHandleMissing(input, "TMP", TRUE,
#                              "0", 0.999)
# input = MSstatsSelectFeatures(input, "topN", 100)
# summarized = MSstatsSummarize(input, "TMP", TRUE, "minFeature", "0", FALSE, TRUE, FALSE,
#                               remove_uninformative_feature_outlier = FALSE,
#                               clusters = NULL, message.show = FALSE)
# MSstatsSummarizationOutput(input, summarized,"TMP")