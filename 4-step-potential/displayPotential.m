%{
This is a function to plot the form of the step potential on a graph to
give a better overview of the physical setup. The energy value of the
particle can also be plotted.

~~~ INPUTS ~~~
V: [1xN vector] the vector containing all the values of the potential for
   each individual step. This is the same as used in genCalcCoefficients.
X: [1x(N-1) vector] the vector containing all the boundaries for the
   potential steps. It is the same as used in genCalcCoefficients.
E: [float](OPTIONAL) the value of the particles energy to be plotted on the
   graph. If not used, will default to None, and nothing will be drawn.

~~~ OUTPUTS ~~~
fig: [figure] figure containing the potential and energy value plots.
%}
function[fig] = displayPotential(V,X,E)
    % This determines the range over which the potential varies. This is
    % used to plot an extension to the function oveer which the potential
    % doesn't change
    xRange = X(end) - X(1);
    % this is the vector that will determine all the points on the graph to
    % be plotted. To get a solid line, each part for a given x value will
    % need to be plotted, so each x value will appear twice
    xValues = zeros(1,2*size(X,2) + 2);
    xValues(1,1) = X(1)-(1/6) * xRange;
    xValues(1,end) = X(end) + (1/6)*xRange;
    % we can simultaneously do the same for the potential values to be
    % plotted. It follows a very simillar pattern.
    VValues = zeros(size(xValues));
    VValues(1,1) = V(1);
    VValues(1,end) = V(end);
    
    % this does the doubling up of the X values within the varying section
    % of the potential.
    for j = 1:size(X,2)
        xValues(1,[2*j,2*j+1]) = [X(j),X(j)];
        VValues(1,[2*j,2*j+1]) = [V(j),V(j+1)];
    end
    
    fig = figure('Name','Potential and Eigen-energies');
    
    plot(xValues,VValues,'DisplayName','V(x)','LineWidth',2);
    
    % plots the energy value on too, if a value has been given.
    if exist('E','var')
        hold on;
        for j = 1:size(E,2)
            plot(xValues,ones(size(xValues))*E(j),'DisplayName',"E_{" + j + "}");
        end
        hold off;
    end
    title("Stepped potential, V(x), with energy eigenvalues");
    xlabel("x");
    ylabel("energy");
    legend;
end