setwd("E:/NMt/Emax")
source("PRED.R")

nID = 4
IDs = 1:nID
Rep = 3
LogConc = rep(-4:1,Rep)
Conc = 10**sort(LogConc)
nConc = length(Conc)
nDV = nID*nConc

THETA = c(3, 80)
OMEGA = 0.01
SIGMA = 9

set.seed(20120825)
ETA = rnorm(nID, mean=0, sd=sqrt(OMEGA))
EPS = rnorm(nDV, mean=0, sd=sqrt(SIGMA))

ColNames = c("ID", "CE", "DV")
DataAll = matrix(nrow=0, ncol=length(ColNames))

for (i in 1:nID) {
  ID   = rep(IDs[i], nConc)
  CE   = Conc
  DATi = cbind(ID, CE)
  ETAi = ETA[i]
  Fi   = PRED(THETA, ETAi, DATi)[,"F"]
  DV   = round(Fi + EPS[((i-1)*nConc+1):(i*nConc)], 3)
  DataAll = rbind(DataAll,cbind(ID, CE, DV))
}

DataAll

write.csv(DataAll, file="SimData.CSV", quote=FALSE, row.names=FALSE)
