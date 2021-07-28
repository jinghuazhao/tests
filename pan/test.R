dyn.load("pan.so")
source("pan.R")
YData <- read.csv('YData.csv', header = TRUE)
N <- dim(YData)[1] ; P <- dim(YData)[2]
X <- cbind(YData$Type.t == 2, YData$Type.t == 3, YData$Type.t == 4, YData$time)
# YData : A dataset. 
# Response variables are : Y1, Y2, Y3, and Y4.
# Type.t and time are predictors.
# X : design matrix of predictors

M <- 10 # number of imputations
prior <- list(a=1, Binv=1, c=1, Dinv=1) # Specified priors
PAN.y1 <- matrix(0, N, M)

# The place where errors occur #
options(echo=FALSE,width=200)
for (m in 1:M){
  cat("m =",m,"\n")
  result <- pan(YData$Y1, YData$ID, X, 1:4, 4, prior, seed=m, iter=100)
  print(result)
  PAN.y1[,m] <- result$y
}
colnames(PAN.y1) <- paste0("y",1:10)
options(digits=3)
head(PAN.y1)
write.table(format(PAN.y1,digits=3),file="PAN.txt",quote=FALSE,row.names=FALSE)
save.image("test.rda")
