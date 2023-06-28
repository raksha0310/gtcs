!pip install gurobipy
from gurobipy import *
import gurobipy as grb

supply_stations = ['station_2','station_4','station_5','station_10']
demand_stations = ['station_1','station_3','station_6','station_7','station_8','station_9']
cost = {
    ('station_2','station_1'):350,
    ('station_2','station_3'):600,
    ('station_2','station_6'):500,
    ('station_2','station_7'):300,
    ('station_2','station_8'):350,
    ('station_2','station_9'):325,
    ('station_4','station_1'):475,
    ('station_4','station_3'):575,
    ('station_4','station_6'):350,
    ('station_4','station_7'):325,
    ('station_4','station_8'):455,
    ('station_4','station_9'):625,
    ('station_5','station_1'):525,
    ('station_5','station_3'):660,
    ('station_5','station_6'):445,
    ('station_5','station_7'):530,
    ('station_5','station_8'):545,
    ('station_5','station_9'):325,
    ('station_10','station_1'):300,
    ('station_10','station_3'):625,
    ('station_10','station_6'):400,
    ('station_10','station_7'):675,
    ('station_10','station_8'):355,
    ('station_10','station_9'):400
}
supply = {
    ('station_2'):5,
    ('station_4'):6,
    ('station_5'):4,
    ('station_10'):1
}
demand = {
    ('station_1'):5,
    ('station_3'):3,
    ('station_6'):1,
    ('station_7'):2,
    ('station_8'):1,
    ('station_9'):4
}
# Create model
m = grb.Model('Transport_problem')

# Create variables
flow = {}
for s in supply_stations:
  for d in demand_stations:
    flow[s,d] = m.addVar(obj = cost[s,d],name = 'flow%s_%s' % (s,d) )

m.update()

#add supply constraints
for s in supply_stations:
  m.addConstr(quicksum(flow[s,d] for d in demand_stations ) == supply[s], 'supply%s' % (s))


#add demand constraints
for d in demand_stations:
  m.addConstr(quicksum(flow[s,d] for s in supply_stations ) == demand[d], 'demand%s' % (d))

#optimize the model
m.optimize()
# print solution
if m.status == GRB.status.OPTIMAL:
  print("\noptimal flow") 
for s in supply_stations:
    for d in demand_stations:
      print(s,'->',d,':',flow[s,d].x) 
