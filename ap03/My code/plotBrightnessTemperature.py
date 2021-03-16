# plots the brightness temperature against pixel count
import matplotlib.pyplot as plt
import numpy as np


### INPUTS ###
# channel : [int] the channel the data is being plotted for
# wl : [float] the channels characteristic wavelength (in microns)
# a : [float] the a parameter in R~P
# b : [float] the be parameter in R~P
# pRange : [1x2 array, float] the inclusive endpoints of P values to be plotted
# n : [int] the number of P values to be plotted on the graph
# calibrationPoint : [2x1 array, float] The specific point used to calibrate the model, in the form [P,T]
def plotBT(channel,wl,a,b,pRange,n,calibrationPoint):
    # creates all p values to be plotted
    p = np.linspace(pRange[0],pRange[1],n)
    # using the inverted plank distribution, we get T (see lab script)
    T = 14309/(wl * np.log(1 + (1.19e8)/(wl**5 * (a*p + b))))

    plt.figure()
    plt.plot(p,T,label=r"$T_I(P)$") # plots the T~P curve
    plt.scatter(calibrationPoint[0],calibrationPoint[1],marker='+',label="Calibration Point") # plots the specific calibration point for the curve
    plt.xlabel(r"Pixel count, $P$")
    plt.ylabel(r"Brightness temperature, $T_I$ [K]")
    plt.title(r"Plot of $T_I$~$P$ for channel " + str(channel))
    plt.legend()
    plt.show()

    return p,T

# A function to plot the Noise Equivelent Delta Temperature
### INPUTS ###
# channel : [int] the channel the data is being plotted for
# p : [1xn linspace] the p values that NEDT is to be calculated for
# T : [1xn array] the T values for the given pixel counts P
# sigP : [float] the standard deviation defining the noise on the P values
# tempCalc : [1xm array] temperature values at which NEPD should be calculated
def plotNEDT(channel, p, T, sigP, tempCalc):
    dP = p[1] - p[0]
    # Does a basic 1st order calculation for the differential of T wrt P
    NEDT = sigP * (T[1:len(T)] - T[0:len(T)-1])/dP

    plt.plot(p[1:],NEDT,label=r"NE%\Delta%T")
    plt.xlabel("Pixel Count")
    plt.ylabel(r"Noise Equivelent Delta Temperature, NE$\Delta$T [K]")
    plt.title(r"Numerical solution for NE$\Delta$T in channel " + str(channel))
    plt.show()
    return NEDT

p9,T9 = plotBT(9,10.788,-0.071857,17.413,[0,270],2701,[115.30,294.6])
p10,T10 = plotBT(10, 11.943,-0.062984,15.325,[0,270],2701,[112.51,292.1])
n9 = plotNEDT(9,p9,T9,0.86,[1])
n10 = plotNEDT(10,p10,T10,0.98,[1])



"""
# STRING LITTERAL FOR MULTILINE COMMENT


# an analytic calulation of the NEDT value
a9 = -0.071857
b9 = 17.413
k9 = 1.19e8/(10.788**5)
NEDT9 = 0.86*(T9/np.log(1+ k9/(a9*p9 + b9)))* ((k9*a9)/((a9*p9+b9)**2))/(1+k9/(a9*p9+b9))
plt.plot(p9,NEDT9)
plt.xlabel("Pixel count")
plt.ylabel(r"Noise Equivelent Delta Temperature, NE$\Delta$T [K]")
plt.title(r"Analytic solution for NE$\Delta$T in channel 9")
plt.show()


plt.plot(p9[1:],NEDT9[1:]-n9)
plt.title(r"Residuals between analytic and numerically caluclated NE$\Delta$T")
plt.show()

# Plots both channels on same axis
plt.plot(p9,T9,label=r"$T^{(9)}_I(P)$")
plt.plot(p10,T10,label=r"$T^{(10)}_I(P)$")
plt.xlabel(r"Pixel count, $P$")
plt.ylabel(r"Brightness temperature, $T_I$ [K]")
plt.title(r"Plot of $T_I$~$P$ for both channels")
plt.legend()
plt.show()

# plots the T~P with area shaded between T+- NEDT
plt.fill_between(p9[1:],T9[1:] + n9, T9[1:] - n9,alpha=0.5,color="orange")
plt.plot(p9,T9)
plt.show()


"""
    
