	################
	# Load Library #
	################

library(lme4)
library(pan)

	####################
	## Import dataset ##
	####################

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
for (m in 1:M){
  result <- pan(YData$Y1, YData$ID, X, 1:4, 4, prior, seed=m, iter=100)
  PAN.y1[,m] <- result$y
}
