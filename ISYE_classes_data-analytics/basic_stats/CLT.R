###CLT with Exponentials
n = 5
X = numeric(10000)
for (j in 1:10000)
{
X[j] = mean(rexp(n,1/10))
}
##estimated mean
mean(X)
##true mean
1/(1/10)
##estimated variance/n
var(X)
##true variance/n
(1/(1/10)^2)/n
hist(X, main = paste("Histogram of the Sample Mean, n = ",n))
