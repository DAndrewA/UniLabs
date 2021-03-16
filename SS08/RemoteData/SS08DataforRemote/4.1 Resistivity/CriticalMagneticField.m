%% This script is for the critical magnetic field strnegth vs T analysis.
% We will need to read in each of the given files (recording time, voltage
% and integrated voltage at fixed pressure) and determine the critical
% magnetic field strength from each visually via a plot

%Here we take the pressures in mBar that the data was recorded at
pressures = [1010,890,630,610,595,570,560,540,520,500,473,450,430,400,370,330,290,250,210,170,130,92,74,58,43,21,3];
% next, we'll determine the tempereatures these occur at using the formula
% from Duriex and Rusby
x = log10(pressures);
T = 1.24177 + 0.23793*x + 0.36207*x.^2 -0.33188*x.^3 +0.20738*x.^4 -0.05294*x.^5 +0.00552*x.^6;

for i = 1:size(pressures,2)
    filename = strcat('ProbeA',int2str(pressures(i)),'mB');
    data = importfile(filename, 3, 242);
    
    t = data.t;
    shuntV = data.shuntV;
    sampleV = data.sampleV;
    integratedV = data.integratedV;
    
    % having read in the data, the shunt voltage can be converted into a
    % magnetic field measurement via its relation to the current, and that
    % to the flux density
    B = (0.018/0.5)*shuntV;
    
    %this creates a plot of the sample voltage against the shunt voltage (which is proportional to the applied electric field)
    f = figure();
    changeIndex = floor(size(shuntV,1)/2);
    hold on
    plot(B(1:changeIndex),sampleV(1:changeIndex),'LineWidth',1.5);
    plot(B(changeIndex+1:end),sampleV(changeIndex+1:end),'LineWidth',1.5);
    legend('Upsweep','Downsweep');
    xlabel("Applied magnetic field, B [T]");
    ylabel("Sample Voltage, V_{sample} [V]");
    title("Sample resistance, R \propto V_{sample} in response to an external magnetic field, B, at fixed temperature T = " + num2str(round(T(i),2)) + "K");
    set(findall(gcf,'-property','FontSize'),'FontSize',20);
    hold off
end


%% This section will take our critical magnetic field values as a function of temperature
% The temperatures at which we could measure the critical magnetic field [Kelvin]
T = [1.41 ,1.87,2.12,2.24,2.34,2.45,2.63,2.78,2.91,3.03,3.13,3.22,3.31,3.37,3.43,3.46,3.51,3.55,3.59,3.62];

% The observed magnetic fields, and their uncertanties [milli Tesla]
Bc = [27,23,20.5,19,17.8,16.5,14.5,12.5,11.4,9.5,8.2,7.3,6.2,5.0,4.2,3.6,3.1,2.4,1.8,1.3];
uncert = [.5,1,1,1,.5,.5,.5,1,.5,1,.5,.5,.5,.4,.5,.5,.3,1,.5,.5];

% We want to plot B vs T^2 to get a relation of the form Bc = B0(1 - (T/Tc))
T2 = T.^2;
p = errorbar(T2,Bc,uncert,'+');
xlabel("T^2 [ K ]");
ylabel("B_C [ mT ]");
title("Plot of B vs. T^2");
set(findall(gcf,'-property','FontSize'),'FontSize',20);
p.LineWidth = 2;
%plot(T2,Bc,'+');