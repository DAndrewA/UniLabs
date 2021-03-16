%{
This script will contain some examples for the other functions.
%}
%% This will be an example of the setup used in the exam question.

V = [10,6,4,12];
X = [0,3,6];
a = 1;
dE = 0.0001;
[eigenEnergies,plottable] = determineAllowableE(V,X,a,dE);
disp("Eigen-energy values:");
disp(eigenEnergies);
displayPotential(V,X,eigenEnergies);

[co,k] = genCalcCoefficients(V,X,eigenEnergies(3),a,[1,0]);
plotWavefunction(co,k,X,0.05,eigenEnergies(3));
%% This will use the same potential as above, but will display the first four energy eigenfunctions.
% For the second energy eigenvalue, this demonstrates the long-wavelength
% nature when the energy and potential are very close to each other.
V = [10,6,4,12];
X = [0,3,6];
a = 1;
dE = 0.0001;
[eigenEnergies,plottable] = determineAllowableE(V,X,a,dE);
disp("Eigen-energy values:");
disp(eigenEnergies);
displayPotential(V,X,eigenEnergies);

for j = 5:-1:1
    [co,k] = genCalcCoefficients(V,X,eigenEnergies(j),a,[1,0]);
    plotWavefunction(co,k,X,0.001,eigenEnergies(j));
end

%% This section will demonstrate a potential well that is much larger and more complicated than the previous examples.
% the first two plotted eigenfunctions demonstrate well the limitations of
% this set of functions. For the low energy limit, rounding errors mean
% that the plotted function aquires an unfavorable coefficient for A(end)
% and thus explode.

V = [10,5,4,8,6,7,8,10];
X = [0,2,5,7,9,10,11];
a = 1;
dE = 0.0001;

[eigenEnergies,plottable] = determineAllowableE(V,X,a,dE);
disp("Eigen-energy values:");
disp(eigenEnergies);
displayPotential(V,X,eigenEnergies);

for j = 1:7
    [co,k] = genCalcCoefficients(V,X,eigenEnergies(j),a,[1,0]);
    plotWavefunction(co,k,X,0.001,eigenEnergies(j));
end

%% This section will demonstrate a split potential, where the barrier separating the two halves is considerably stronger than the gaps between them.
% This well will be symmetric to demonstrate the parity of solutions.
% This demonstrates the limnitations of the functions well. Using a smaller
% dE can yield considerably better reuslts and can lead to the emergence of
% the parity symettry.

V = [10,2,20,2,10];
X = [0,8,10,18];
a=1;
dE = 0.0001;

[eigenEnergies,plottable] = determineAllowableE(V,X,a,dE);
disp("Eigen-energy values:");
disp(eigenEnergies);
displayPotential(V,X,eigenEnergies);

for j = 1:size(eigenEnergies,2)
    [co,k] = genCalcCoefficients(V,X,eigenEnergies(j),a,[1,0]);
    plotWavefunction(co,k,X,0.001,eigenEnergies(j));
end

%% This section is just gonna contain a generally funky potential.
% for the highest energy wavefunctions, it works quite well, but much below
% that and it struggles.

V = [10,8,7,6,0,2,3,4,8,30,15,12,10,2,3,4,5,6,10];
X = [0,3,5,6,8,12,15,18,20,21,22,24,27,29,33,35,37,40];
a=1;
dE = 0.00002;

[eigenEnergies,plottable] = determineAllowableE(V,X,a,dE);
disp("Eigen-energy values:");
disp(eigenEnergies);
displayPotential(V,X,eigenEnergies);

disp("Select which eigenfunctions you want to display.");
disp("Please enter one at a time.");
disp("Stop selecting and display by entering 0");

J = [];
while true
    x = input("Eigenfunction: ");
    if (x > 0)
        J = [J,x];
    else
        break;
    end
end
for j = J
    [co,k] = genCalcCoefficients(V,X,eigenEnergies(j),a,[1,0]);
    plotWavefunction(co,k,X,0.001,eigenEnergies(j));
end

%% This section will try to create an approximation of an  attractive Coulomb potential.


V = [0,-1,-2,-4,-8,-16,-32,-64,-32,-16,-8,-4,-2,-1,0];
X = [,-7.5,-6.5,-5.5,-3.5,-2.5,-1.5,-0.5,0.5,1.5,2.5,3.5,5.5,6.5,7.5];
a=1;
dE = 0.0001;

[eigenEnergies,plottable] = determineAllowableE(V,X,a,dE);
disp("Eigen-energy values:");
disp(eigenEnergies);
displayPotential(V,X,eigenEnergies);

for j = [14,15]
    [co,k] = genCalcCoefficients(V,X,eigenEnergies(j),a,[1,0]);
    plotWavefunction(co,k,X,0.001,eigenEnergies(j));
end

[co,k] = genCalcCoefficients(V,X,2,a,[1,0]);
plotWavefunction(co,k,X,0.001,eigenEnergies(j));