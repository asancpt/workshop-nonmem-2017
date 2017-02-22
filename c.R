#!/SYSTEM/R/3.3.2/bin/Rscript

# Library -----------------------------------------------------------------

localLibPath <- c("./lib", .libPaths())
.libPaths(localLibPath)
.libPaths()

edisonlib <- c("nmw", "lattice")
lapply(edisonlib, function(pkg) {
    if (system.file(package = pkg) == '') install.packages(pkg)
})
lapply(edisonlib, library, character.only = TRUE) # if needed # install.packages(mylib, lib = localLibPath)

# Argument ----------------------------------------------------------------

Args <- commandArgs(trailingOnly = TRUE) # SKIP THIS LINE IN R if you're testing!
if (identical(Args, character(0))) Args <- c("-inp", "input.deck")

if (Args[1] == "-inp") InputParameter <- Args[2] # InputPara.inp

inputFirst <- read.table(InputParameter, row.names = 1, sep = "=", 
                         comment.char = ";",
                         strip.white = TRUE,
                         stringsAsFactors = FALSE)

library(compiler)
enableJIT(3)
require(nmw)

setwd("C:/NMW2017/03-Emax")
DataFile = "SimData.CSV"
DataAll = read.csv(DataFile)

require(lattice)
xyplot(DV ~ log(CE) | ID, data=DataAll, type="b")

nTheta = 2
nEta = 1
nEps = 1

THETAinit = c(10, 100)
OMinit = matrix(0.2, nrow=nEta, ncol=nEta)
SGinit = matrix(1, nrow=nEps, ncol=nEps)

LB = rep(0, nTheta)
UB = rep(1000000, nTheta)

#######
METHOD = "ZERO"
InitPara = InitStep(DataAll, THETAinit=THETAinit, OMinit=OMinit, SGinit=SGinit, nTheta=nTheta, LB=LB, UB=UB, METHOD=METHOD, PredFile="PRED.R")
(EstRes = EstStep())           # 0.6200359 secs, 0.4930282 secs
(CovRes = CovStep())

PostHocEta() # FinalPara from EstStep()
