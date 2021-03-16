%% This code will allow us to do all the analysis we require for the Meisner effect exploration in Sn.
% As with the critical magnetic field analysis, we will need to read in all
% of the data files recorded at different pressures to see how the flux
% passing through the probe coil changes as a function of applied field.

%We will start by creating a list of pressures at which measurements were
%taken.
pressures = [1010,720,690,590,540,525,490,480,470,440,410,390,360,320,270,238,220,190,165,132,98,80,58,41,20,2];
% again, we'll determine the tempereatures these occur at using the formula
% from Duriex and Rusby
x = log10(pressures);
T = 1.24177 + 0.23793*x + 0.36207*x.^2 -0.33188*x.^3 +0.20738*x.^4 -0.05294*x.^5 +0.00552*x.^6;
% These variables are the turning number and area of the coil [mm^2]
n = 676;
A = 181.46;
% goes through the file for each of the pressures and gets the data for it.
for i = 1:size(pressures,2)
    filename = strcat('ProbeB',int2str(pressures(i)),'mbar.dat');
    data = importfile(filename, 3, 242); 
    t = data.t;
    shuntV = data.shuntV;
    sampleV = data.sampleV;
    integratedV = data.integratedV;  
    % having read in the data, the shunt voltage can be converted into a
    % magnetic field measurement via its relation to the current, and that
    % to the flux density
    Bapplied = (0.018/0.5)*shuntV;
    % we can also convert the integrated voltage into an internal flux
    % density in the tin probe. Using formula 3 in the lab script, letting
    % t1 be the start time, and saying that B1 ~= 0, we get
    Binternal = 1/(n*A) * integratedV;
    %this creates a plot of the sample voltage against the shunt voltage (which is proportional to the applied electric field)
    f = figure();
    % roughly cuts the data in half so we can plot the up and down sweep
    % seperately.
    changeIndex = floor(size(shuntV,1)/2);
    hold on
    plot(Bapplied(1:changeIndex)*10^3,Binternal(1:changeIndex)*10^9,'LineWidth',1.5);
    plot(Bapplied(changeIndex+1:end)*10^3,Binternal(changeIndex+1:end)*10^9,'LineWidth',1.5);
    legend('Upsweep','Downsweep');
    xlabel("Applied magnetic field, B [ \mu T ]");
    ylabel("Internal magnetic field, B_{int} [ \mu T ]");
    title("Internal magnetic field of Sn sample, B_{int}, in response to an external magnetic field, B, at fixed temperature T = " + num2str(round(T(i),2)) + "K");
    set(findall(gcf,'-property','FontSize'),'FontSize',15);
    hold off
end
%% This section is to test the Bc ~ T^2 relation as described in equation 1 in the lab script
% The temperatures at which we could measure the critical magnetic field [Kelvin]
T = [1.34,1.86,2.10,2.24,2.48,2.64,2.76,2.85,2.94,2.99,3.08,3.2,3.29,3.35,3.39,3.45,3.5,3.52,3.54,3.59,3.62];
% The observed magnetic fields, and their uncertanties [micro Tesla]
Bc = [25.3,21.4,19.0,18,15.3,13.6,12.4,11.5,10.4,9.7,8.6,7.1,6.1,5.4,4.6,4.0,3,3,2.9,1.8,1.55];
uncert = [.5,.5,.5,.2,.5,.2,.3,.3,.3,.3,.3,.3,.5,.2,.2,.3,.2,.3,.2,.5,.2];
% We want to plot B vs T^2 to get a relation of the form Bc = B0(1 - (T/Tc))
T2 = T.^2;
p = errorbar(T2,Bc,uncert,'+');
xlabel("T^2 [ K ]");
ylabel("B_C [ \mu T ]");
title("Plot of B_C vs. T^2");
set(findall(gcf,'-property','FontSize'),'FontSize',20);
p.LineWidth = 2;
%plot(T2,Bc,'+');