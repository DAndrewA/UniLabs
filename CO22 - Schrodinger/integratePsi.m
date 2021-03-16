% Author: Andrew Martin , Date: 21/01/2020
%    ~~~ DESCRIPTION ~~~
%    The function to calculate psi for x in [0,x1], and then plot both the
%    analytic and caluclated solutions. It will then numerically integrate
%    psi over that range, and calculate the RMSE value between the two
%    solutions.
%
%
%    ~~~ INPUTS ~~~
%    deltaX: [float] the difference between different x values at which psi
%            will be caluclated.
%
%    x1: [float > 0] the max value at which psi will be calculated.
%
%    n: [integer] the value of n for which 
%
%    E: [1xm vector] a vector containing all the enrgy values to be tested 
%       in solve_numerov. To get the energy eigenstates, E should take the value 2n+1.
%
%
%   ~~~ NOTES ~~~
%   This function makes use of Chad A. Greene's legappend function, for
%   appending items to the legend on the graph.
%
%
function [] = integratePsi(deltaX,x1,n,E)
    % using the input arguments creates a 1xN vector for all the x values
    xSpace = 0:deltaX:x1;
    
    % This creates the symbolic variable y for use in creating the
    % different anonymous function handles for use in solve_numerov
    syms y;
    
    % creates the initial anonymous function handle for the analytical
    % solution. This is however, not normalised compared to the caluclated
    % solution.
    h = @(y) hermiteH(n,y).*exp(-(y.^2)/2);
    
    % determines whether the analytical solution should be odd(1) or even(0)
    parity = mod(n,2);
    % based on the parity of the solution, determine psi0, dpsi0 and normalise the
    % analytical solution.
    if parity
        % for odd-parity solutions, psi0 = 0
        psi0 = 0;
        % the normalisation constant for the analytical solution, N, can be
        % found by finding the value of its differential at x = 0
        hDiff = eval(['@(y)' char(diff(h(y)))]);
        N = 1/hDiff(0);
    else
        % this is for the even parity case.
        psi0 = 1;
        % the normalisation is different in the even-parity case. It
        % instead can be found as
        N = 1/h(0);
    end
    dpsi0 = 1-psi0;
    clear y;
    
    % this is the analytical solution, scaled to match the values of psi
    % being calculated at x=0
    analyticPsiFunction = @(y) N*h(y);
    analyticPsi = analyticPsiFunction(xSpace);
    % this also plots the analytic value of psi, and ensures the other
    % caluclated versions can be plotted on the same set of axis. Also
    % begins the array to store the legend labels
    plot(xSpace,analyticPsi);
    legendArray = '\Psi [analytic]';
    hold on;
    
    for e = E
        % creates the anonymous function handle f for use in solve_numerov
        % based on the current energy value e
        f = @(y) y^2 - e;
        
        % uses the solve_numerov function to calculate values for psi
        calcPsi = solve_numerov(f,xSpace,psi0,dpsi0);
    
        % this caluclates the root-mean-square value of the error in
        % calculatedPsi and then outputs it to the command line
        RMSE = (sum((calcPsi - analyticPsi).^2)/length(xSpace))^(1/2);
        disp("E-value: " + e + "; RMSE value: " + RMSE);
        
        % This plots the current caluclated psi values, and adds the
        % description to the legend
        plot(xSpace,calcPsi);
        legendArray = [legendArray;'\Psi for E = ' + string(e)];
    end
    title("Plot of the analytic and caluclated solutions for n = " + n + " and E \in " + mat2str(E));
    legend(legendArray);
    xlabel("x [natural units]");
    ylabel("\psi [unnormalised]");
    hold off;
end