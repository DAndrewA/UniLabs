%% This section will be concerning the hysteresis loop measured at 4.2K.
% first, we will read in the required data file
data = importfile('ProbeC_4.2K.dat', 1, 489);
shuntV = data.ShuntVoltageV;
sampleV = data.SampleVoltageV;
integratedV = data.IntegratedSampleVoltageV;
% having read in the data, the shunt voltage can be converted into a
% magnetic field measurement via its relation to the current, and that
% to the flux density. This is in Tesla
Bapplied = (0.018/0.5)*shuntV;
% from the data file, the search coil's effective area is given as [in m^2]
A = 0.0755012;
Binternal = 1/A * integratedV;

%% This section will be concerning the hysteresis loop measured at 1.34.
% first, we will read in the required data file
data = importfile('ProbeC_1.34K.dat', 1, 489);
shuntV = data.ShuntVoltageV;
sampleV = data.SampleVoltageV;
integratedV = data.IntegratedSampleVoltageV;
% having read in the data, the shunt voltage can be converted into a
% magnetic field measurement via its relation to the current, and that
% to the flux density. This is in Tesla
Bapplied = (0.018/0.5)*shuntV;
% from the data file, the search coil's effective area is given as [in m^2]
A = 0.0755012;
Binternal = 1/A * integratedV;

%% This section will be concerning the hysteresis loop measured at pressure 1010mbar.
% first, we will read in the required data file
data = importfile('ProbeC1010mbarafter1.34Kpump.dat', 1, 489);
shuntV = data.ShuntVoltageV;
sampleV = data.SampleVoltageV;
integratedV = data.IntegratedSampleVoltageV;
% having read in the data, the shunt voltage can be converted into a
% magnetic field measurement via its relation to the current, and that
% to the flux density. This is in Tesla
Bapplied = (0.018/0.5)*shuntV;
% from the data file, the search coil's effective area is given as [in m^2]
A = 0.0755012;
Binternal = 1/A * integratedV;
%% Change plot title as necessary
plot(Bapplied,Binternal,'LineWidth',1.5);
xlabel("Applied magnetic field, B [ T ]");
ylabel("Internal magnetic field, B_{int} [ T ]");
title("Hysteresis of lead probe at P=1010mbar for a changing applied field");
set(findall(gcf,'-property','FontSize'),'FontSize',15);