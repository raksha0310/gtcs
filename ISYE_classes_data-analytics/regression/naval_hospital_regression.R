hospital <- read.table(file.choose(), header=TRUE)
hospital
# alternative method of checking data
fix(hospital)

attach(hospital)
summary(hospital)
cor(hospital)

nlist <- names(hospital)
for (i in 2:(ncol(hospital)-1)) 
{
   correl <- cor.test(labor_hours, hospital[ ,i], method="pearson")
   cv <- sprintf("%15s r = %7.4f t = %7.4f p = %7.4f", nlist[i], correl$estimate, correl$statistic, correl$p.value)
   print(cv)
}
reg.model <- lm(labor_hours ~ patient_load + x_ray + bed_days + area_pop + avg_stay)
summary(reg.model)

# install.packages("olsrr")
library(olsrr)

# olsrr package documentation
# https://cran.r-project.org/web/packages/olsrr/vignettes/intro.html
# https://cran.r-project.org/web/packages/olsrr/vignettes/variable_selection.html
# https://cran.r-project.org/web/packages/olsrr/vignettes/regression_diagnostics.html
# https://cran.r-project.org/web/packages/olsrr/vignettes/influence_measures.html
# https://cran.r-project.org/web/packages/olsrr/vignettes/residual_diagnostics.html


ols_regress(labor_hours ~ patient_load + x_ray + bed_days + area_pop + avg_stay, data=hospital)

ols_coll_diag(model)
ols_plot_diagnostics(model)

ols_step_all_possible(model)
ols_step_best_subset(model)

ols_step_both_p(model)
