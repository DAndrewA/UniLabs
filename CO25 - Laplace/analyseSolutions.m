% AUTHOR: Andrew Martin
% DATE: 11/12/2019

% DESCRIPTION: This function is designed to aid in the creation of figures
% and solutions required to test the solve_laplace() function. 

% ~~~ INPUTS ~~~
% alphaValues: [kx1 matrix] vector containing the values of alpha for which the solve_laplace function should be tested with
% nItterations: [kx1 matrix] vector determining how many iteartions the solve_laplace function should perform for each alpha value
% initPsi: [nxm matrix] the matrix determining the initial values for the caluclations. Its boundary values should take on those of the solution we want to find
% analyticSolution: [nxm matrix] the matrix for which the analytical solution has been determined. This can be used to determine the accuracy of each solution
% convergenceParams: [kx1 matrix][OPTIONAL] used to determine the convergence values used in the solve_laplace() function

% ~~~ OUTPUTS ~~~

function [] = analyseSolutions(alphaValues,nItterations,initPsi,analyticSolution,convergenceParams)
    % This sets the plotting linewidth to be thicker so that plots are
    % easier to see in the report
    set(0, 'DefaultLineLineWidth', 2);

    % determines if the optional parameter convergenceParams was used, and
    % if not, default it to 0 (as though it doesn't do anything)
    if ~exist('convergenceParams','var')
        convergenceParams = zeros(size(alphaValues,1),1);
    end
    
    % displays the figure with the contour plot for the analytical solution
    % (this needs only be done once so is outside the loop)
    clabel(contour(analyticSolution,'LineWidth',2));
    title("Contour plot of analytical solution");
    xlabel("x");
    ylabel("y");
    set(findall(gcf,'-property','FontSize'),'FontSize',20)
    
    % calculates the optimum value for alpha and appends it to alphaValues.
    % Allows 50 iterations for this to converge, and has a convergenceParam
    % of 0.
    alphaOpt = 2/(1+sqrt(1 - ((cos(pi/size(initPsi,2)) + cos(pi/size(initPsi,1)))^2)/4));
    alphaValues = [alphaValues;alphaOpt];
    nItterations = [nItterations;50];
    convergenceParams = [convergenceParams;0];
    
    for k = 1:size(alphaValues)
        % calculates the current set of values to be analysed
        [psi,histVals] = solve_laplace(initPsi,alphaValues(k),nItterations(k),convergenceParams(k));
        
        % creates a new figure and displays the calculated values on it
        figure();
        clabel(contour(psi,'LineWidth',2));
        title("Contour plot of calculated solution when \alpha = " + string(alphaValues(k)));
        xlabel("x");
        ylabel("y");
        % this increases the font size on all elements of the plot
        set(findall(gcf,'-property','FontSize'),'FontSize',20)
        
        % creates a new figure with the differences between the two plots
        diffs = psi - analyticSolution;
        figure();
        clabel(contour(diffs,'LineWidth',2));
        title("Contour plot of difference between analytic and caluclated solutions when \alpha = " + string(alphaValues(k)));
        xlabel("x");
        ylabel("y");
        set(findall(gcf,'-property','FontSize'),'FontSize',20)
        
        %calculates the RMSE for the calculated solution and outputs it to
        %the console.
        RMSE = sqrt(sum(diffs.*diffs,'all')/(size(diffs,1)*size(diffs,2)));
        disp("Alpha = " + alphaValues(k) + "; RMSE = " + RMSE);
        
        % creates the figure on which the convergence of the historical
        % values are plotted
        figure();
        plot(0:nItterations(k),histVals);
        title("convergence of specific values in grid when \alpha = " + string(alphaValues(k)));
        xlabel("Itteration number");
        ylabel("Value");
        
        % writes the legend for the graph, using the correct subscripts for
        % the positions on \psi
        dims = size(initPsi);
        legend('\psi_{' + string(ceil(dims(1)/2)) + ',' + string(ceil(dims(2)/4)) +'}','\psi_{' + string(ceil(dims(1)/2)) + ',' + string(ceil(dims(2)/2)) +'}','\psi_{' + string(ceil(dims(1)/2)) + ',' + string(ceil(3*dims(2)/4)) +'}')
        set(findall(gcf,'-property','FontSize'),'FontSize',20)
        
        % allows the user to pause and analyse each set of graphs before
        % seeing the next one
        input("Press enter when you're ready to proceed");
    end
end