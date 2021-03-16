%{
The idea of this function is to determine the coefficients to a generalised
exponential solution to a stepped potential.
The function will be able to solve for N steps in the potential with any
energy value for the particle - with MATLABs ability to compute complex
roots of numbers, this will generalise to any potential. If V(1) and V(N) are
greater than the energy input, then the function should be normalisable.

~~~ INPUTS ~~~
V: [1xN vector] the vector containing all the values of the potential for
   the individual steps.
X: [1x(N-1) vector] the vector containing all the boundary locations for
   the steps. The values contained should be in ascending order.
E: [float] the energy of the particle. This is in the same units as V 
   (whatever theat may be), so for good solutions, the values should be
   same order of magnitude.
a: [float] a sclaing constant. In the caluclations, this will equate to
   sqrt(2m/hbar^2). 
co1: [1x2 vector] a vector whose components are A1 and B1. These will give
     the starting point for calculating the other coefficients. For
     solutions that will be normalisable (i.e V1 > E), B1 should be 0.


~~~ OUTPUTS ~~~
genCoefficients: [Nx2 matrix] this is a matrix where each row, j, contains
                 the Aj and Bj coefficients for the wavefunction.
k: [1xN vector] the vector containing all the values of k calculated for 
   each part of the potential well. 
%}
function[genCoefficients,k] = genCalcCoefficients(V,X,E,a,co1)
    % we'll start by caluclating all the values of k for the different
    % regions of the solution. Because MATLAB can caluclate complex roots,
    % the equation applied is generalised.
    k = zeros(1,size(V,2));
    for j = 1:size(V,2)
        k(j) = a*sqrt(V(j)-E);
    end

    % this instantiates the matrix which will contain the coefficients. The
    % first row of the matrix is the set to the initial values provided for
    % A1 and B1.
    genCoefficients = zeros(size(V,2),2);
    genCoefficients(1,:) = co1;
    
    % the function will then go through all subsequent j and caluclate the
    % j+1 coefficients
    for j = 1:size(V,2)-1
        % here, we define some constants to help make the caluclation more
        % readable.
        delta = k(j)*X(j);
        beta = k(j)/k(j+1);
        gamma = k(j+1)*X(j);
        % we define primed coefficients for Aj and Bj, to make the
        % calculation even further readable.
        Ajp = genCoefficients(j,1)*exp(delta);
        Bjp = genCoefficients(j,2)*exp(-delta);
        
        % we now caluclate the next two coefficients. We will drop the j+1
        % subscript for the variable names, for simplicity of typing.
        A = (1/2) * exp(-gamma) * ( Ajp*(1+beta) + Bjp*(1-beta) );
        B = (1/2) * exp(gamma) * ( Ajp*(1-beta) + Bjp*(1+beta) );
        
        % this now sets the new coefficients in the matrix
        genCoefficients(j+1,:) = [A,B];
    end
    
end