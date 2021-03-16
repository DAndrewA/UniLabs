%{
The idea of this function is to plot the wavefunction for the particle
give the caluclated coefficients and the boundary positions for the
potential well.

~~~ INPUTS ~~~
co: [Nx2 matrix] this is the matrix of coefficients for the exponential
    functions that calculate the wavefunction. It can take the direct
    output of genCalcCoefficients.
k: [1xN] the k values calculated at each part of the potential function.
   Taken as an output of genCalcCoefficients.
X: [1x(N-1) vector] this is the vector containing the positions of the step
   boundaries for the potential. It takes the same form as that for
   genCalcCoefficients.
dx: [float] the spacing of x values to have the wavefunction calculated at.
E: [float] the enrgy used for the eigenfunction. Not used in any
   calculations, solely for the purpose of labelling plots.

~~~ OUTPUTS ~~~
p: [plot] the plot containing the wavefunction.


%}
function[p] = plotWavefunction(co,k,X,dx,E)
    % this defines the vector which will contain all the final x values to
    % be plotted. Its size will grow throughout the function call.
    plotXValues = [];
    % this is the evctor that will define the values of the wavefunction
    % for the values of x in plotXValues. The final size of psi will be
    % equal to that of plotXValues.
    psi = [];
    
    % this sets capping values for where the edges of the wavefunction are
    % to be computed. They take the same values as the plotted values for
    % the potential in displayPotential.
    xRange = X(end) - X(1);
    X = [X(1)-(1/6) * xRange,X(1,:)];
    X = [X(1,:),X(end)+(1/6)*xRange];
    
    % this goes through each section labelled with a j (as defined 
    % throughout the rest of the solution)
    for j = 1:size(co,1)
        % this determines the values of x for which the weavefunction will
        % be plotted within this part of the potential, and appends them to
        % the plotXValues.
        xj = X(j):dx:X(j+1);
        plotXValues = [plotXValues,xj];
        
        % we then go through each of these x values, calculate psi at that
        % point, and then append it to the psi vector.
        newPsi = zeros(size(xj));
        for n = 1:size(xj,2)
            x = xj(n);
            newPsi(1,n) = co(j,1) * exp(k(j)*x) + co(j,2) * exp(-k(j)*x);
        end
        psi = [psi,newPsi];
    end
    
    % creates the plot to return from the function.
    fig = figure('Name',"Wavefunction plot, E=" + E);
    p = plot(plotXValues,psi);
    
    % plots dashed lines at each potential barrier to make understanding
    % the plot marginally easier.
    maxPsi = max(psi);
    minPsi = min(psi);
    hold on;
    for x = X(2:end-1)
        plot([x,x],[maxPsi,minPsi],'LineStyle','--','Color','black');
    end
    plot([plotXValues(1),plotXValues(end)],[0,0],'Color','black');
    hold off;
    
    % labels the axes
    title("The wavefunction \psi for particle energy E = " + E);
    xlabel("x  [length]");
    ylabel("psi  [length^-(1/2)]");
    legend(p,'\psi(x)');
end