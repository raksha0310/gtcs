# -*- coding: utf-8 -*-
"""
Spyder Editor

Quiz 2
"""

from gurobipy import GRB,Model 
# Create the model
m = Model('mixtures') # Set parameters
m.setParam('OutputFlag',True)
# Add variables
x1 = m.addVar(name='x1')
x2 = m.addVar(name='x2')
p1 = m.addVar(name='p1')
p2 = m.addVar(name='p2')
# Add constraints
m.addConstr(x1 - p1  <= 400, name='c1')
m.addConstr(x2 + 0.6 * p1 - p2  <= 400, name='c2')
m.addConstr(0.4*p1 + 0.8*p2  <= 400, name='c3')
# Set the objective
m.setObjective(50*x1+70*x2+22*p1+20*p2, GRB.MAXIMIZE) # Optimize the model
m.optimize()
# Print the result
status_code =   {1:'LOADED', 2:'OPTIMAL', 3:'INFEASIBLE',\
                 4:'INF_OR_UNBD', 5:'UNBOUNDED'}
status = m.status
print('The optimization status is {}'.format(status_code[status]))
if status == 2:
    # Retrieve variables value
    print('Optimal solution:')
    for v in m.getVars():
         print('%s = %g' % (v.varName, v.x))
    print('Optimal objective value:\n{}'.format(m.objVal))
