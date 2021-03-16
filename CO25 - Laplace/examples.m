%%
%This file will contain example uses of the solvePoisson equation. Each one
%will have a description, and will then contain all the code nesescary to
%run it and analyse the solutions.

% click on a section and press ctrl + enter to run it. Each should be self
% contained.
%% EXAMPLE 1 : psi = xy
% This example will be used to demonstrate the calculated solutions are
% correct in a very simple case.
n = 20;
nIter = 500;
dx = 0.2
initPsi = zeros(n,n);

mask = zeros(n,n);
mask(1,:) = ones(1,n);
mask(end,:) = ones(1,n);
mask(:,1) = ones(n,1);
mask(:,end) = ones(n,1);

BCPsi = zeros(n,n);
for x = 1:n
    for y = 1:n
        BCPsi(y,x) = (x-1)*(y-1);
    end
end
f = zeros(n,n);
psi = solvePoisson(initPsi,BCPsi,mask,f,dx,nIter)
    
% creates a new figure and displays the calculated values on it
figure();
clabel(contour(psi));
title("Contour plot of calculated solution for \psi = xy");
xlabel("x");
ylabel("y");

% creates a new figure and displays the analytical values on it
figure();
clabel(contour(BCPsi));
title("Contour plot of analytical solution for \psi = xy");
xlabel("x");
ylabel("y");

diff = psi - BCPsi;
figure();
clabel(contour(diff));
title("Contour plot of residuals");
xlabel("x");
ylabel("y");

%% EXAMPLE 2 : example from first section of practical
% This example will be working with the first example from the practical,
% where psi = sin(x)sinh(y), solving Laplace's equation.

% This will be the grid dimensions, it can be increased for greater
% resolution.
n = 10;
% This will run for 30 itterations, which should be enough for the solution
% to approach a stable solution.
nIter = 100;
dx = 1/(n-1);
initPsi = zeros(n,n);
% we will now define the mask. This will just be the edge positions on the
% grid.
mask = zeros(n,n);
mask(1,:) = ones(1,n);
mask(end,:) = ones(1,n);
mask(:,1) = ones(n,1);
mask(:,end) = ones(n,1);
% we will define the boundary conditions using the analytical solution
% (thus we can compare the final psi against BCPsi).
BCPsi = zeros(n,n);
for x = 1:n
    for y = 1:n
        BCPsi(y,x) = sin((x-1)*dx)*sinh((y-1)*dx);
    end
end
% as we are solving Laplace's equation, no function is needed.
f = zeros(n,n);

psi = solvePoisson(initPsi,BCPsi,mask,f,dx,nIter);

% creates a new figure and displays the calculated values on it
figure();
clabel(contour(psi));
title("Contour plot of calculated solution for \psi = sin(x)sinh(y)");
xlabel("x");
ylabel("y");

% creates a new figure and displays the analytical values on it
figure();
clabel(contour(BCPsi));
title("Contour plot of analytical solution for \psi = sin(x)sinh(y)");
xlabel("x");
ylabel("y");

diff = psi - BCPsi;
figure();
clabel(contour(diff));
title("Contour plot of residuals");
xlabel("x");
ylabel("y");

%% EXAMPLE 3 : A point source in a box
% This example will simulate the potential of a point charge located in a
% conducting box. I can't be bothered to calculate the analytical solution
% so we'll just have to see if the result looks reasonable.

nIter = 500;
n = 15;
dx = 0.2;
initPsi = zeros(n,n);
BCPsi = zeros(n,n);

mask = zeros(n,n);
mask(1,:) = ones(1,n);
mask(end,:) = ones(1,n);
mask(:,1) = ones(n,1);
mask(:,end) = ones(n,1);

f = zeros(n,n);
q = 10;
f(5,7) = q;

psi = solvePoisson(initPsi,BCPsi,mask,f,dx,nIter);

% creates a new figure and displays the calculated values on it
figure();
clabel(contour(psi));
title("Contour plot of calculated solution for charge in a box");
xlabel("x");
ylabel("y");

%% EXAMPLE 4 : Internal boundary conditions
% This example will test the functions ability to use internal boundary
% conditions in the solution. For this, we will have a single grid space at
% a fixed potential. This should form a potential that looks exactly like
% the point charge.

nIter = 100;
n = 15;
dx = 0.2;
initPsi = zeros(n,n);

BCPsi = zeros(n,n);
q = 10;
BCPsi(5,7) = q;

mask = zeros(n,n);
mask(1,:) = ones(1,n);
mask(end,:) = ones(1,n);
mask(:,1) = ones(n,1);
mask(:,end) = ones(n,1);
mask(5,7) = 1;

f = zeros(n,n);

psi = solvePoisson(initPsi,BCPsi,mask,f,dx,nIter);

% creates a new figure and displays the calculated values on it
figure();
clabel(contour(psi));
title("Contour plot of calculated solution for fixed potential in a box");
xlabel("x");
ylabel("y");

%% EXAMPLE 5 : Fluid flow around a cylinder
% This example will be using psi as a streamfunction. That means that
% contours of psi designate flow lines of an irrotational incompressible
% fluid around an obstacle, in this case a cylinder. There will be an
% analytical solution provided.
nIter = 500;

y0 = 5;
U = 10;
dx = 0.2;
L = 15;
a = 3;

%calculates the dimensions of the matrix to have it range from i=0 -> y =
%-y0 to i=n -> y = +y0, and same with x from -L/2 to +L/2.
n = 2* y0/dx + 1;
m = 1 + L/dx;
% finding the n and m values corresponding to x=y=0.
n0 = y0/dx + 1;
m0 = 1 + 0.5*L/dx;

initPsi = zeros(n,m);
BCPsi = zeros(n,m);
% PLACEHOLDER : JUST CALCULATES BOUNDARY CONDITIONS AT EDGES, ISN'T FULL
% ANALYTIC SOLUTION.
for x = 1:m
    BCPsi(1,x) = -U;
    BCPsi(n,x) = U;
end
for y = 1:n
    BCPsi(y,1) = (y-n0)*U*dx/y0;
    BCPsi(y,m) = (y-n0)*U*dx/y0;
end
for i = 1:n
    for j = 1:m
        x = (j-m0)*dx;
        y = (i-n0)*dx;
        if sqrt(x^2 + y^2) > a
            BCPsi(i,j) = U*y*(1 - (a^2)/(x^2+y^2));
        end
    end
end

mask = zeros(n,m);
mask(1,:) = ones(1,m);
mask(end,:) = ones(1,m);
mask(:,1) = ones(n,1);
mask(:,end) = ones(n,1);
% CREATES CYCLINDER WITHIN SYSTEM THAT CREATES BOUNDARY CONDITION
for i = 1:n
    for j = 1:m
        x = (j-m0)*dx;
        y = (i-n0)*dx;
        if sqrt(x^2 + y^2) <= a
            mask(i,j) = 1;
        end
    end
end

f = zeros(n,m);

psi = solvePoisson(initPsi,BCPsi,mask,f,dx,nIter);
levels = [-5*U:U/5:5*U 0.01];
labelLevels = [-5*U:U/2:5*U 0.01];

% creates a new figure and displays the calculated values on it
figure();
clabel(contour(psi,levels),labelLevels);
title("Contour plot of calculated solution for fluid flow around a cylinder");
xlabel("x");
ylabel("y");

% creates a new figure and displays the analytical values on it
figure();
clabel(contour(BCPsi,levels),labelLevels);
title("Contour plot of analytical solution for fluid flow around a cylinder");
xlabel("x");
ylabel("y");

diff = psi - BCPsi;
figure();
clabel(contour(diff));
title("Contour plot of residuals");
xlabel("x");
ylabel("y");

%% EXAMPLE 6 : Restricted output flow
% This is the final example asked for in the lab script, it requires that
% we pass the flow through a narrower output than input.
% The boundary conditions I will impose will be +-U at the top and bottom
% boundaries, and for the side ones, I will vary psi linearly between those
% points.

nIter = 500;

y0 = 5;
y1 = 1;
U = 10;
dx = 0.2;
Lwide = 10;
Lnarrow = 10;

%calculates the dimensions of the matrix to have it range from i=0 -> y =
%-y0 to i=n -> y = +y0.
n = 2* y0/dx + 1;
m = (Lwide + Lnarrow)/dx;

n0 = y0/dx + 1;
m0 = Lwide/dx + 1;

initPsi = zeros(n,m);
BCPsi = zeros(n,m);
for i = 1:n
    y = (i-n0)*dx
    BCPsi(i,1) = U*y/y0;
    BCPsi(i,m) = U*y/y1;
end
BCPsi(1,:) = -U;
BCPsi(n,:) = U;
BCPsi(1:n0-(y1/dx),m0:m) = -U;
BCPsi(n0+(y1/dx):n,m0:m) = U;

mask = ones(n,m);
mask(2:n-1,2:m0-1) = 0;
mask(n0-(y1/dx)+1:n0+(y1/dx)-1,m0:m-1) = 0;

f = zeros(n,m);

psi = solvePoisson(initPsi,BCPsi,mask,f,dx,nIter);
levels = -U:U/10:U;
labelLevels = -U:U/5:U;

% creates a new figure and displays the calculated values on it
figure();
clabel(contour(psi,levels),labelLevels);
title("Contour plot of calculated solution for fluid flow around a cylinder");
xlabel("x");
ylabel("y");

%% EXAMPLE 7 : Circuit potential
% In this example, I will try to demonstrate a diagram we had to draw for
% curcuits in forst year, about how you can draw equipotential lines around
% a circuit based on the potential differences around the circuit.