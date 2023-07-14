import numpy as np
import math
from operator import mul,add

n=100000

random_list = {"gr":[], "internal":[], "salvage": []}
results = []
best_per_round = {0: 0, 1:0, 2:0}

for i in range(n):
  gr = np.random.poisson(19.5)
  grr = (gr/100) + 1
  random_list["gr"].append(grr)
  internal = np.random.randint(480000,520001)
  random_list["internal"].append(internal)
  salvage = np.random.randint(0,100001)
  random_list["salvage"].append(salvage)
  pv_salvage = (1.04**-5) * random_list["salvage"][i]

  cost_option1 = [200*1.0286,200*1.0226**2,200*1.02**3,200*1.0197**4,200*1.02**5]
  cost_option2 = [230,230,230,230,230]
  cost_option3 = [60*1.0286,60*1.0226**2,60*1.02**3,60*1.0197**4,60*1.02**5]

  num = [2007*random_list["gr"][i],2007*random_list["gr"][i]**2,2007*1.02**3,2007*random_list["gr"][i]**4,2007*random_list["gr"][i]**5]
  equip_cost = [450000*1.0286,450000*1.0226**2,450000*1.02**3,450000*1.0197**4,450000*1.02**5]

  pvf = [1.04**-1,1.04**-2,1.04**-3,1.04**-4,1.04**-5]

  conum1 = list(map(mul,cost_option1,num))
  conum2 = list(map(mul,cost_option2,num))
  conum3 = list(map(mul,cost_option3,num))
  NPV1 = list(map(mul,conum1,pvf))
  NPV2 = list(map(mul,conum2,pvf))
  NPV3_1 = list(map(mul,conum3,pvf))
  current_option = sum(NPV1)
  results.append([])
  results[i].append(current_option)
  service_option = sum(NPV2)
  results[i].append(service_option)

  NPV3_2 = list(map(mul,equip_cost,pvf))
  NPV3 = list(map(add,NPV3_1,NPV3_2))
  internal_option = sum(NPV3) + (random_list["internal"][i] - pv_salvage)
  results[i].append(internal_option)
  best_per_round[results[i].index(max(results[i]))] += 1

print("current: " + str(best_per_round[0]))
print("service: " + str(best_per_round[1]))
print("internal: " + str(best_per_round[2]))
