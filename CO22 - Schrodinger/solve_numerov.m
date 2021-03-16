% Author: Andrew Martin , Date: 21/01/2020
%    ~~~ DESCRIPTION ~~~
%    Solves the time-independant Schrodinger equation, d^2(psi)/dx^2 = f(x)psi,
%    using the Numerov method. It solves it in the range x in [x0,x1]
%    subject to the boundary conditions psi(x0) = psi0 and d(psi(x0))/dx = dpsi(x0).
%
%
%    ~~~ INPUTS ~~~
%    f: [lambda function of 1 variable] the function representing the
%       potential and energy function in the differential equation.
%
%    x: [1xn vector] the vector containing all the values at which x is to
%       be calculated, including the two end values, x0 and x1.
%
%    psi0: [float] the numerical value of psi (the solution) at x0.
%
%    dpsi0: [float] the numerical value of dpsi/dx at x0.
%
%
%    ~~~ OUTPUTS ~~~
%
%    psi: [1xn vector] the vector of values returned which designate the
%         values caluclated for the solution. This will be the same size as the
%         input vector x.
%
%
% Example use:
% >> f = @(x) x^2 - 1;
% >> x = linspace(0, 1, 100);
% >> psi0 = 1;
% >> dpsi0 = 0;
% >> psi = solve_numerov(f, x, psi0, dpsi0);
% >> plot(x, psi);
%
function [psi] = solve_numerov(f, x, psi0, dpsi0)
    % instantiates the vector psi with the same dimensions as the input
    % vector x and inputs the value at x0.
    psi = zeros(size(x));
    psi(1) = psi0;
    % if the input vector is just the singular value at this point, return
    % from the function. This shouldn't be a case (its trivial) but it
    % ensure the program won't crash if this does occur.
    if(length(x) == 1)
        return
    end
    
    % creates the symbolic variable y, and generates the first and second
    % differential of f. Then clears the symbolic variable y to save memory
    % space.
    syms y;
    f1 = eval(['@(y)' char(diff(f(y)))]);
    f2 = eval(['@(y)' char(diff(f(y)))]);
    clear y;
    
    % determines deltaX and calculates psi(x0+deltaX) using the general
    % Taylor expansion to order O(deltaX^4). This makes the caluclation
    % more general than having to distinguish between odd and even cases.
    deltaX = x(2)-x(1);
    psi(2) = psi0*(1+ (1/2)*f(x(1))*deltaX^2 + (1/6)*f1(x(1))*deltaX^3 + (1/24)*(f(x(1))^2 + f2(x(1)))*deltaX^4) + deltaX*dpsi0*(1 + (1/6)*f(x(1))*deltaX^2 + (1/12)*f1(x(1))*deltaX^3);
    
    % itterates through all the other values of x and caluclates psi at
    % that point based on Numerov's method
    for i = 3:length(x)
        psi(i) = ((2+(5/6)*f(x(i-1))*deltaX^2)*psi(i-1) - (1-(1/12)*f(x(i-2))*deltaX^2)*psi(i-2)) / (1-(1/12)*f(x(i))*deltaX^2);
    end
end