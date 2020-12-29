import numpy as np
a2 = [6,5,4,3,2,1]

a1 = [2,1,1,1,1,1]
print(np.multiply(a1, a2), sum(np.multiply(a1, a2)))

a1 = [2,1,2,2,2,2]
print(np.multiply(a1, a2), sum(np.multiply(a1, a2)))

a1 = [2,2,1,2,2,2]
print(np.multiply(a1, a2), sum(np.multiply(a1, a2)))

a1 = [2,2,2,1,2,2]
print(np.multiply(a1, a2), sum(np.multiply(a1, a2)))

a1 = [2,2,2,2,1,2]
print(np.multiply(a1, a2), sum(np.multiply(a1, a2)))

a1 = [2,2,2,2,2,1]
print(np.multiply(a1, a2), sum(np.multiply(a1, a2)))

a1 = [2,2,2,2,2,2]
print(np.multiply(a1, a2), sum(np.multiply(a1, a2)))

""" 
[-,+,-,-,-,-][2,3,4,5,0,1] 
[-,-,+,-,-,-][1,2,3,4,5,0] 
[-,-,-,+,-,-][0,1,2,3,4,5] 
[-,-,-,-,+,-][5,0,1,2,3,4] 
[-,-,-,-,-,+][4,5,0,1,2,3] 
"""



# -------
a2 = [10,9,8,7,6,5,4,3,2,1]

a1 = [2,1,1,1,1,1,1,1,1,1]
print(np.multiply(a1, a2), sum(np.multiply(a1, a2)))
a1 = [2,2,2,2,2,2,2,2,2,2]
print(np.multiply(a1, a2), sum(np.multiply(a1, a2)))


print('---------')

a1 = [3,1,1,1,1,1,1,1,1,1]
print(np.multiply(a1, a2), sum(np.multiply(a1, a2)))

a1 = [3,1,1,1,1,3,2,1,1,1]
print(np.multiply(a1, a2), sum(np.multiply(a1, a2)))

a1 = [3,2,1,1,1,3,1,1,1,1]
print(np.multiply(a1, a2), sum(np.multiply(a1, a2)))

a1 = [3,1,3,1,1,1,3,1,3,1]
print(np.multiply(a1, a2), sum(np.multiply(a1, a2)))

a1 = [3,1,3,1,3,1,3,1,1,1]
print(np.multiply(a1, a2), sum(np.multiply(a1, a2)))

a1 = [3,3,3,3,3,3,3,3,3,3]
print(np.multiply(a1, a2), sum(np.multiply(a1, a2)))
