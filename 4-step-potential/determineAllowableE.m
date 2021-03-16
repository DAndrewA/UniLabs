%{
The aim of this function is to go through and determine allowable values of
E that can be used to determine energy eigenfunctions. For unbound
solutions, the values E can take become continuous, so this will only work
for bound solutions (i.e E < V(1),V(end)).

The allowed energy eigenvalues will be caluclated by minimising the final A
coefficient. Because the solution is bound, this must be 0 so as no to blow
up at infinity, so we will select E at local minima of this A value and
take them as the eigenvalues. 

~~~ INPUTS ~~~
V: [1xN vector] the vector containng the potential values at each step.
   Same as all the other functions.
X: [1x(N-1) vector] the vector containing the x values of the potential
   boundaries. Same as the other functions.
a: [float] scaling constant, same as used in genCalcCoefficients.
dE: [float] determines the increments in E which should be tested.

~~~ OUTPUTS ~~~
eigenE: [1xM vector] a vector containing the determined allowable energy
        eigenvalues.
plotValues: [2xP matrix] a matrix containing the energy values tested (1,:)
            and the calculated Aend coefficients (2,:). This is for 
            demonstration purposes only. 

%}
function[eigenE, plotValues] = determineAllowableE(V,X,a,dE)
    % this defaults the initial values of the wavefunctions coefficients.
    % For an unormalised wavefunction, this simply adjusts the scaling of
    % the wavefunction. Because the solution is bounded, we know that B1 =
    % 0, otherwise the wavefunction would explode at x = - infinity.
    co1 = [1,0];
    
    % this determines the minimum bound energy for a particle. A particle
    % with a globally lower energy than the potential can't exist.
    boundEnergyLow = min(V);
    
    % determines the maximum bound energy possible, which is the lowest of
    % V(1) and V(end)
    if V(1) < V(end)
        boundEnergyMax = V(1);
    else
        boundEnergyMax = V(end);
    end
    
    % determines the values of E that should be tested given the bounding
    % energies. Also instantiates the vector to store the coefficient
    % values.
    energies = boundEnergyLow:dE:boundEnergyMax;
    AEndValues = zeros(size(energies));
    
    % goes through all te enrgy values and appends the calculated final A 
    % value to the list.
    for j = 1:size(energies,2)
        E = energies(j);
        [co,k] = genCalcCoefficients(V,X,E,a,co1);
        % takes the absolute value of the A value in question.
        A = abs(co(end,1));
        AEndValues(j) = A;
    end
    % stores the plottable values in the output variable.
    plotValues = [energies;AEndValues];
    
    % goes through all the A values and looks for local minima. Then stores
    % those E values in the eigenE vector.
    eigenE = [];
    for j = 2:size(energies,2)-1
        if AEndValues(j) < AEndValues(j+1) && AEndValues(j) < AEndValues(j-1)
            eigenE = [eigenE,energies(j)];
        end
    end
end