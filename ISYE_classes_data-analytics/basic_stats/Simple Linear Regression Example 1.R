## input the data
X = c(117.8,84.6, 67.5, 118.4, 63.5)
Y = c(358.9, 327.6, 303.2, 371.1, 321.8)
#do a scatter plot
plot(X,Y, main = "Scatterplot of Length vs. Weight", xlab = "Length", ylab = "Weight")

#find the coefficients
a = lm(Y ~ X)
summary(a)
##here's the coefficients
a$coef
a$fit
a$res

##here's a scatter plot with the fitted line drawn as well
plot(X,Y, main = "Scatterplot of Length vs. Weight", xlab = "Length", ylab = "Weight")
abline(a$coef[1],a$coef[2])


###Analysis of variance
anova(a)



####Example 2
X2 = c(270.2,101.8,167.1,175.7,55.6,220.5,285.1,254.9,145.0,276.2,271.0,340.7
,240.5,78.5,106.6,289.1,246.7,187.4,199.5,124.8,357.4,350.2,88.8,335.3
,379.3,19.0,108.4,164.9,194.5,112.7,139.2,319.2,187.7,287.4,220.4,259.6
,127.5,251.9,120.0,323.2,13.8,245.9,289.4,342.7,228.0,358.7,350.1,29.6
,187.9,279.9)



Y2 = c(807.2,403.6,544.9,616.9,253.5,679.7,845.7,762.3,495.7,827.9
,818.1,965.3,730.2,354.6,441.2,852.3,759.2,618.0,633.1,440.2
,983.1,995.3,363.3,941.9,1074.2,169.8,417.3,567.5,622.5,415.5
,478.1,888.5,587.5,840.4,638.2,782.2,462.3,737.9,450.1,921.7
,168.1,743.4,820.5,980.7,686.4,1002.1,998.9,239.9,575.0,804.0)

plot(X2,Y2, main = "Scatter Plot of X2 vs. Y2")
a2 = lm(Y2~X2)
summary(a2)
anova(a2)


X3 = X2^(1/8)
a3 = lm(Y2~X3)
plot(X3,Y2, main = "Scatter Plot of X3 vs Y with Fitted Line")
abline(a3$coef[1], a3$coef[2], col = "red")

plot(a3$res, main = "Plot of the Residuals")
plot(X3,a3$res, main = "Plot of the Regressor vs. the Residuals")
plot(Y2,a3$res, main = "Plot of the Response Variable vs. the Residuals")





