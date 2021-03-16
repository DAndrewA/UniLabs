% CURRENT ISSUE - THIS DOESN'T WORK IN THE CASE OF OVER-RELAXATION, SETTING
% ALPHA ANYTHING ABOVE 1 MAKES THE SOLUTION OSCILLATE RAPIDLY AND GROW TO
% STUPID LEVELS.


% Author: Andrew Martin , Date: 02/09/2020

% This function solves Poissons equation using the method of
% over-relaxation. It can take an input function f (for f = 0 this becomes
% Laplace's equation), and a mask which allows for internal as well as
% external boundary conditions.

% ~~~ INPUTS ~~~
%
% initPsi : [nxm matrix] this will be a matrix defining the initial values
%           of the solution for each spatial location on a grid.
%
% BCPsi : [nxm matrix] the matrix containing values for the boundary
%         conditions on the solution of psi. This can either be set to the 
%         analytical solution or have values particularly at specified
%         boundaries .
%
% mask : [nxm matrix][ones and zeros] the matrix defining where the
%        boundaries of the solution are. If 1, that position on the grid
%        will be treated as a boundary and new psi values will not be
%        calculated. If 0, it will be treated as normal on the grid.
%        
%        NOTE : ALL edge values of this matrix must be 1, otherwise the
%        calculations will fail.
%
% f : [nxm matrix] the matrix defining the values of the function f that
%     appears in Poisson's equation. If uniformly 0, this gives Laplace's
%     equation.
%
% dx : [float] the spatial distance between grid points. For simplicity,
%      this will be the same in the x and y directions.
%
% nIter : [integer] the number of itterations the relaxation process will
%         go through before returning the solution psi


function [psi] = solvePoisson(initPsi,BCPsi,mask,f,dx,nIter)
    % The first step is to instantiate psi and impose the correct boundary
    % conditions on it.
    psi = initPsi + mask.*(BCPsi - initPsi);
    
    % we the create the inverse of the mask to define all the points on the
    % grid that should be allowed to have their value vary.
    invMask = ones(size(mask)) - mask;

    % This section of code calculates the optimum value of alpha to use,
    % from the formula provided in the lab script (7)
    % Alpha defines the over-relaxation constant used when calculating the
    % values of psi.
    p = size(psi,1);
    q = size(psi,2);
    alpha = 1;%2/(1 + sqrt( 1 - ((cos(pi/p) + cos(pi/q))^2)/4 ));

    % when calculating new values of psi, we can use the form
    % psi_new = psi_old + alpha*R/4 - f_eff
    % where R is defined in equation (6) and f_eff is the last term in
    % equation (10). As f_eff doesn't change throughout the computation, we
    % can caluclate it beforehand to speed up the calculation.
    fEff = f*(dx^2)/4;
    
    % we now begin the itterations to calculate the new values of psi
    for itt = 1:nIter
        % This starts by getting the new R matrix using the getR function
        % (see below)
        R = getR(psi);
        
        % We then apply these residuals to all parts of the grid that
        % aren't defined as a boundary (using the inverse mask). This way, 
        % we don't need to continually reimpose the boundary conditions.
        psi = psi + invMask.*( (alpha/4) * R - fEff );
    end
end



% Inspiration taken from function of same name in solve_laplace, however,
% calculate a matrix of R values in one go to speed up caluclation.
% AUTHOR: Andrew Martin
% DATE: 02/09/2020

% DESCRIPTION: This function calculates the R_{ij} value for each over-relaxation
% computation

% ~~~INPUTS ~~~
% p: [nxm matrix] grid of values from which R_{ij} is calculated (in our case, the psi matrix)

% ~~~ OUTPUTS ~~~
% R: [nxm matrix] matrix containing all R values for each spatial position.
function [R] = getR(p)
    % this gives us the dimensions of the psi matrix, which will be
    % required to calculate the shift matrices.
    [n,m] = size(p);

    % in order to create the matrix in one go, we need to displace the psi
    % matrix by one unit in each direction (up, down, left, right). I will
    % call these the shift matrices.
    shiftUp = [p(2:end,:) ; zeros(1,m)];
    shiftDown = [zeros(1,m) ; p(1:end-1,:)];
    
    shiftLeft = [p(:,2:end) zeros(n,1)];
    shiftRight = [zeros(n,1) p(:,1:end-1)];

    % now we can calculate the R matrix as an addition of these matrices
    R = shiftUp + shiftDown + shiftLeft + shiftRight - 4*p;
end