data hospital;
   input site patient_load x_ray bed_days area_pop avg_stay labor_hours;
datalines;
01 15.57 2463 472.92 18.0 4.45 566.52
02 44.02 2084 1339.75 9.5 6.92 696.82
03 20.42 3940 620.25 12.8 4.28 1033.15
04 18.74 6505 568.33 36.7 3.90 1603.62
05 49.20 5723 1497.60 35.7 5.50 1611.37
06 44.92 11520 1365.83 24.0 4.60 1613.27
07 55.48 5779 1687.00 43.3 5.62 1854.17
08 59.28 5969 1639.92 46.7 5.15 2160.55
09 94.39 8461 2872.33 78.7 6.18 2305.58
10 128.02 20106 3655.08 180.5 6.15 3503.93
11 96.00 13313 2912.00 60.9 5.88 3571.89
12 131.42 10771 3921.00 103.7 4.88 3741.40
13 127.21 15543 3865.67 126.8 5.50 4026.52
14 252.90 36194 7684.10 157.7 7.00 10343.81
15 409.20 34703 12446.33 169.4 10.78 11732.17
16 463.70 39204 14098.40 331.4 7.05 15414.94
17 510.22 86533 15524.00 371.6 6.35 18854.45
;
proc print;
   title1 'Naval hospital usage data';
;
proc corr;
   var patient_load x_ray bed_days area_pop avg_stay;
   with labor_hours;
;
proc reg;
   model labor_hours = patient_load x_ray bed_days area_pop avg_stay;
   title2 'All predictors in model';
;
proc rsquare CP adjrsq;
   model labor_hours = patient_load x_ray bed_days area_pop avg_stay;
   title2 'All possible models';
;
proc reg plots(label)=(CooksD RStudentByLeverage DFFITS DFBETAS);
   model labor_hours = patient_load x_ray bed_days area_pop avg_stay / P selection=CP;
   id site;
   title2 'Model selection based on best Mallows CP';
;
proc reg plots(label)=(CooksD RStudentByLeverage DFFITS DFBETAS);
   model labor_hours = patient_load x_ray bed_days area_pop avg_stay / P selection=ADJRSQ;
   id site;
   title2 'Model selection based on best Adjusted R Square';
;
run;
quit;
