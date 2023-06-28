##basics
2+2
2*2
2/2
2^2
##modular arith.
7%%5
##storage
##vectors
X = c(1,2,3,4,5)
Y = c(1:5)
Z = c(X,Y)
X
2*X
X + Y
X*Y
Z[7]
sort(Z)
sum(Z)
prod(Z)
##can be numbers or strings
Fruit = c("a","a","a","b","b","a","a","g","g","a","s")
table(Fruit)
##matrices
I = diag(3)
A = cbind(c(1,2,3),c(2,4,6),c(10,20,30))
B = rbind(c(1,2,3),c(2,4,6),c(10,20,30))
A[2,2]
A%*%B
A%*%I
A+2
A*2
##inverse example
M = cbind(c(5,2,1),c(2,4,.5),c(1,.5,2))
solve(M)
##loop
n = 10
P = numeric(n)
c = 0
for (j in 1:n)
{
c = c+1
P[j] = c + c^2
}
##see also while, if then, etc. will show later
##import and export
##read.csv
##read.table
##write.csv
##write.table
###once you import the file use the attach command to be able to refer to
the columns directly
#i.e data1 = read.csv(blahblahblah), then use attach(data1)
##some basic statistics
#make up some data
X = ceiling(rnorm(100, 70,20))
##mean, variance, minimum, maximum, median
mean(X)
var(X)
sum((Z - mean(Z))^2)/(length(Z)-1)
var(Z)
sum(Z)/length(Z)
mean(Z)
min(X)
max(X)
median(X)
##Stem and Leaf plot
stem(X)
hist(X, main = "histogram", xlab = "label for x axis!", ylab = "label for
y axis", sub = "a sub label!")
