% Author: Andrew Martin , Date: 21/01/2020
%    ~~~ DESCRIPTION ~~~
%    This function is designed to determine the eigenvalue of the TISE in
%    natural units by itterating over values near E0.
%
%    ~~~ INPUTS ~~~
%
%    E0: [float; must be positive real] the initial guess of the eigenvalue. It is recomended to
%        keep this near where a suspected value is.
%
%    order: [integer][optional] the power of 10^-1 to which the program
%           will test values. For example, if order = 3, the function will return
%           a value accurate to 10^-3 according to the algorithm being used.
%
%    ~~~ OUTPUTS ~~~
%
%    E: [float] the eigenvalue near the initial guess for the TISE in use
%
% Example use:
% >> E = find_oscillator_eigenvalue(1.2);
% >> disp(E);
%
function[E] = find_oscillator_eigenvalue(E0,order)
    % ensures that if the optional arguument order isn't specified that it
    % does get used.
    if ~exist('order','var')
        order = 5;
    end
    currentOrder = 1;
    
    % creates 2 variables to determine the historical values for E and
    % psi(end)
    prevE = E0;
    prevPsi = 0;

    % this determines the function to be input into the solve_numerov
    % function
    E = E0;
    f = @(x) x^2 - E;
    x = 0:0.05:5;
    
    %tries to determine whether the solution should be odd or even (and
    %thus set the boundary conditions) by testing both of them and seeing
    %which is better.
    psiEven = solve_numerov(f,x,1,0);
    psiOdd = solve_numerov(f,x,0,1);
    % depending on which one has a smaller value at x=5, the program will
    % treat the assumed solution as having that parity
    if abs(psiEven(end)) < abs(psiOdd(end))
        % even parity
        psi0 = 1;
        dpsi0 = 0;
        prevPsi = psiEven(end);
    else
        % odd parity
        psi0 = 0;
        dpsi0 = 1;
        prevPsi = psiOdd(end);
    end
    % clears the two previous variables to ensure memory isn't a problem.
    clear psiEven; clear psiOdd;
    
    % From initial observations, changing whether E is above or below the
    % eigenvalue changes the sign of the tail at x=5 when it explodes. This
    % implies that the eigenvalue lands in the vicinity of where changing E
    % changes the sign of the tail.
    
    % we can define a new variable direction which is either +-1 which
    % determines in which direction E is being itterated. Initially this
    % will be set to 1
    direction = 1;
    % we can define another variable to determine whether the sign of PSI
    % has changed on the current ordewr of magnitude yet (not the sign of direction)
    signChanged = 0;
    while currentOrder <= order
        E = prevE + direction*10^(-currentOrder);
        f = @(x) x^2 - E;
        psi = solve_numerov(f,x,psi0,dpsi0);
        % if the sign of psi changes in this interval, then E and prevE
        % define the interval in which the actual E lies, so regardless of
        % which is closer, the precision of the itteration needs to
        % increase by an order of magnitude.
        if(psi(end)*prevPsi < 0)
            currentOrder = currentOrder + 1;
            % if the magnitude of prevPsi is smaller than psi, it means prevE 
            % is closer to the true value, so the direction of itteration 
            % doesn't change but the order of magnitude being checked does. 
            % This means prevE doesn't change either 
            if abs(prevPsi) > abs(psi(end))
                direction = -direction;
                prevE = E;
                prevPsi = psi(end);
            end
        % if no change of sign has occured, this just changes the previous
        % values to ensure that when the sing of psi does change, the
        % interval being checed is as small as possible.
        elseif abs(psi(end)) < abs(prevPsi)
            prevE = E;
            prevPsi = psi(end);
        % if the value of E has actually got worse, then the direction of
        % itteration is changed.
        else
            direction = -direction;
        end
    end      
end