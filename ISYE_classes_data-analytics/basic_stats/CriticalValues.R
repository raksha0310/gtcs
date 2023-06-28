##For all of these examples, assume alpha = 0.05, n = 50
alpha = 0.05
n = 50
##how to find z_alpha/2
z_.025 = qnorm(1-alpha/2)
##how to find t_alpha/2,(n-1)
t_.025_49 = qt(1 - alpha/2,n-1)
##how to find chi^2_alpha/2, (n-1) and chi^2_(1-alpha/2),(n-1)
chi2_.025_49 = qchisq(1-alpha/2,n-1)
chi2_.975_49 = qchisq(alpha/2,n-1)
##how to find f_(alpha/2,n1-1, n2-1)
n1 = 30
n2 = 40
qf(1-alpha/2, 30-1, 40-1)
##how to find f_(1alpha/2,n1-1, n2-1)
qf(alpha/2, 30-1, 40-1)
