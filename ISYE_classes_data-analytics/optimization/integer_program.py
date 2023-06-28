!pip install gurobipy
from gurobipy import GRB
import gurobipy as grb
#create empty model
m = grb.Model()
#Add variables
x1 = m.addVar(vtype = GRB.BINARY , name = 'x1')
x2 = m.addVar(vtype = GRB.BINARY , name = 'x2')
x3 = m.addVar(vtype = GRB.BINARY , name = 'x3')
x4 = m.addVar(vtype = GRB.BINARY , name = 'x4')
x5 = m.addVar(vtype = GRB.BINARY , name = 'x5')
x6 = m.addVar(vtype = GRB.BINARY , name = 'x6')
x7 = m.addVar(vtype = GRB.BINARY , name = 'x7')
x8 = m.addVar(vtype = GRB.BINARY , name = 'x8')
x9 = m.addVar(vtype = GRB.BINARY , name = 'x9')
#Set objective function
m.setObjective(0, GRB.MAXIMIZE)
#Add constraints
c1 = m.addConstr(x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9 == 1)
c2 = m.addConstr(x8 + x9 + x2 + x3 + x4 + x5 + x6 == 0)
c3= m.addConstr(x1 + x7 <=1)
#Solve model
m.optimize()
print(m.display())
for v in m.getVars():
print(v.varName, v.x)
