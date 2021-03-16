%% ResistivityDataRemote analysis
% This section requires us to determine the resistance of our sample at
% different temperatures and constant current. The file has the inputs of 
% pressure, v+ and v- (voltages for diffferent current bias)

% SPECIFICALLY, this section will read in the data and convert it into an
% appropriate format

% The below data was taken at current I = 1.002A
I = 1.002;
%gets the helium vapour pressure in mbar
p = ResistivityDataRemote.Heliumpressure;
% gets the positive voltage measurement in millivolts, which we will
% convert into volts
vmax = (1/1000)*ResistivityDataRemote.V;
% gets the reversed voltage measurement in millivolts, which we will
% convert into volts
vmin = (1/1000)*ResistivityDataRemote.V1;

% we calculate the average voltage value to better determine the resistance
vbar = (vmax - vmin)/2;

% here we use the empirical formula to change the pressures into a
% temperature based on trhe measurements made by Duriex and Rusby:
x = log10(p);
T = 1.24177 + 0.23793*x + 0.36207*x.^2 -0.33188*x.^3 +0.20738*x.^4 -0.05294*x.^5 +0.00552*x.^6;

%% In this section we will compute the resistances and plot them against temperature
R = vbar./I;

p = plot(T,R);

xlabel("Temperature [K]");
ylabel("Sample resistance [\Omega]");
title("Resistance of Sn sample as a function of temperature");
set(findall(gcf,'-property','FontSize'),'FontSize',20);
p.LineWidth = 2;