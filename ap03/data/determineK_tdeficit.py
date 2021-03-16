# Code to get k9, k10 from the temperature defecit data via linear regression
import matplotlib.pyplot as plt
import numpy as np
import scipy.stats as sc

#increase plot font size
plt.rcParams.update({'font.size': 22})

f = open("tdeficit.txt","r")
data = f.read()
f.close()

# splits the data into rows
data = data.split("\n")[1:]

# goes through each row, and appends data into relevant arrays
x = []
dt9 = []
dt10 = []
for row in data:
    # strips leading whitespace from data
    row = row.lstrip()
    row = row.split(" ")

    # removes all the empty elements due to uneven white-spacing
    row = [value for value in row if value != ""]

    x.append(float(row[0]))
    dt9.append(float(row[1]))
    dt10.append(float(row[2]))


delta = [dt10[a] - dt9[a] for a in range(len(x))]

# order of values [slope, intercept, correlation, pvalue, std_error on slope, std_error on intercept]
linReg9 = sc.linregress(x,dt9)
linReg10 = sc.linregress(x,dt10)
linRegDelta = sc.linregress(x,delta)
#creates linspace data for the regression lines
xLin = np.linspace(0,100,5)
regLine9 = linReg9[0]*xLin + linReg9[1]
regLine10 = linReg10[0]*xLin + linReg10[1]
regLineDelta = linRegDelta[0]*xLin + linRegDelta[1]

# plots the scatter graphs
plt.scatter(x,dt9,label=r"Ch.9 (11$\mu$m)",color="blue")
plt.scatter(x,dt10,label=r"Ch.10 (12$\mu$m)",color="red")
plt.scatter(x,delta,label=r"Ch.10 - Ch.9",color="black")
# plots the linear regression lines
plt.plot(xLin,regLine9,color="blue",label=r"$xk_9$")
plt.plot(xLin,regLine10,color="red",label=r"$xk_{10}$")
plt.plot(xLin,regLineDelta,color="black",label=r"$x(k_{10} - k_{9})$")
# axis labelling
plt.xlabel(r"Water Vapour Collumn, $x$")
plt.ylabel(r"$\Delta$T [K]")
plt.title("Temperature defecit as a function of WVC")

plt.legend()

plt.show()

print(linReg9)
print(linReg10)
print(linRegDelta)

    
