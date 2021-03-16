## run from anaconda prompt window
import matplotlib.pyplot as plt
import numpy as np
import scipy.stats as sc

x = [782,808,616,324,422]
B = [6.071,6.563,2.893,-2.673,-0.773]
dB = [0.081,0.038,0.014,0.032,0.041]

y = [252,678,727,636,764]
A = [-4.120,4.147,5.059,3.310,5.760]
dA = [0.064,0.032,0.033,0.051,0.032]

#plt.rcParams.update({
#    "text.usetex": True,
#    "font.family": "sans-serif",
#    "font.sans-serif": ["Helvetica"]})


plt.figure()
plt.errorbar(y,A,dA,linestyle='None',linewidth=2,capthick=25,label="Data")
plt.xlabel("y [pixels]")
plt.ylabel(r"$\alpha$ [$^\circ$]") # LATEX!!!! put r before opening " and internal $$ it seems to work

# attempt linear regression on the data points
linReg = sc.linregress(y,A)
print(linReg[0],linReg[1],linReg[2])
linRegX = np.linspace(250,850,num = 3)
linRegB = linRegX*linReg[0] + linReg[1]
plt.plot(linRegX,linRegB,label="Regression",linewidth=1)

plt.title(r"Plot of y against $\alpha$")
plt.legend()

plt.show()
print("Figure created")






