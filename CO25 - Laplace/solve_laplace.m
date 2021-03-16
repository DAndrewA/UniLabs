% Author: Andrew Martin , Date: 09/12/2019
% This function solves the Laplace's equation using the over-relaxation method
% Input:
% ? init_psi: 2D matrix containing the initial \psi, including boundaries.
% ? alpha: the coefficient of over?relaxation.
% ? N_iter: maximum number of iterations performed.
% convergenceParam: [float][OPTIONAL] allows the user to determine within what range the hist_values can be of each other before the program determines the solution has converged. If not provided, the value defaults to 0, and this isn't even taken into account. For optimum solutions, it should be set realtively low compared to the values of the analytic solution at that point. 

% Output:
% ? psi: 2D matrix of the value of \psi after (up to) N_iter iterations.
% ? hist_values: (N_iter x 3) matrix that contains historical values of 3 points during the iteration (1 in the upper half, 1 in the middle, and 1 in the lower half).
%
% Constraints:
% ? The boundaries of \psi are kept constant during the iterations.

% Example use:
% >> init_psi = zeros(7,7);
% >> % example of boundary conditions: all ones
% >> init_psi(1,:) = 1;
% >> init_psi(end,:) = 1;
% >> init_psi(:,1) = 1;
% >> init_psi(:,end) = 1;
% >> [psi, hist_vals] = solve_laplace(init_psi, 1.1, 30);
function [ psi , hist_values ] = solve_laplace ( init_psi , alpha , N_iter , convergenceParam)
    % determines if the optional parameter convergenceParam was used, and
    % if not, default it to 0 (as though it doesn't do anything)
    if ~exist('convergenceParam','var')
        convergenceParam = 0;
    end
    % creates the new psi variable, a matrix of the same dimensions as
    % init_psi, that will have its values changed.
    psi = init_psi;
    dims = size(psi);
    % determines the points on the grid at which 3 values are recorded for
    % determining the convergence characteristics of the grid
    histPos1 = [ceil(dims(1)/2),ceil(dims(2)/4)];
    histPos2 = [ceil(dims(1)/2),ceil(2*dims(2)/4)];
    histPos3 = [ceil(dims(1)/2),ceil(3*dims(2)/4)];
    
    %creates the histValues matrix with the initial values of the spaces
    hist_values = [psi(histPos1(1),histPos1(2)),psi(histPos2(1),histPos2(2)),psi(histPos3(1),histPos3(2))];
    % creates the boolean, running, which is used to determine when to halt
    % the itteration process
    running = 1;
    % creates the integer variable, itterations, which allows us to keep
    % track of the total itterations before the program terminates
    itterations = 0;
    while running
        %starts the two for loops that will itterate over all internal (non
        %boundary) values of psi. Not itterating over the edge values of the matrix means that
        %they never change the boundary values (they remain fixed).
        for x = dims(1)-1:-1:2
            for y = dims(2)-1:-1:2
               % using equation 5 in the lab script, this calculates the new,
               % over-relaxed value on the grid at position (i,j)
               psi(x,y) = psi(x,y) +alpha/4 * R(psi,x,y); 
            end
        end
        
        % adds the newly calculated values that are being recorded to the
        % historical record
        hist_values = [hist_values; psi(histPos1(1),histPos1(2)),psi(histPos2(1),histPos2(2)),psi(histPos3(1),histPos3(2))];
        % increments the itterations counter after the over-relaxation
        % process has occured, then checks to see if the limit is reached.
        % If it has, it changes the value of running, causing the loop to
        % terminate
        itterations = itterations + 1;
        if itterations >= N_iter
           running = 0; 
        end
        
        % calculates the difference in the two most recent hist_values, and
        % if they are within the convergenceParam, terminates the program
        diffs = hist_values(end,:) - hist_values(end-1,:);
        if abs(diffs(1)) < convergenceParam && abs(diffs(2)) < convergenceParam && abs(diffs(3)) < convergenceParam
            running = 0;
            disp("Terminating after " + string(itterations) + " itterations");
        end
    end
end



% AUTHOR: Andrew Martin
% DATE: 09/12/2019

% DESCRIPTION: This function calculates the R_{ij} value for each over-relaxation
% computation

% ~~~INPUTS ~~~
% p: [nxm matrix] grid of values from which R_{ij} is calculated (in our case, the psi matrix)
% x: [integer] the first index of the grid position for R_{ij} to be calculated at
% y: [integer] the second free index for the position at which R_{ij} is calculated

% ~~~ OUTPUTS ~~~
% R: [float] value of R_{ij} that is calculated
function [R] = R(p,x,y)
    R = p(x+1,y) + p(x,y+1) + p(x-1,y) + p(x,y-1) - 4*p(x,y);
end