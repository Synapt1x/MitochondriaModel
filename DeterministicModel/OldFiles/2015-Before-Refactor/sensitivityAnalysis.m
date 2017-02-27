function modelJacobi = sensitivityAnalysis()
%{
Created by: Chris Cadonic
========================================
This function houses code for using symbolic variables to represent
functions in my deterministic model. This function will be essential
to conducting sensitivity analysis for my masters project by finding
the Jacobian of the set of equations in my model. This will be done
using the symbolic functions for each equation in my model as
carried out below.
%}

%Initialize the symbolic variables in the model; vars, params and t
syms r o omega rho vmax K1 Km p1 p2 p3 p4 p5 t;

%Define each of the equations from the mito model
f1 = 4*p5 - 4*((vmax.*o)./(Km.*(1+(K1./r))+o)).*...
    omega; %dr/dt
f2 = -((vmax.*o)./(Km.*(1+(K1./r))+o)).*omega; %do/dt
f3= -12*p5 - 8*((vmax.*o)./(Km.*(1+(K1./r))+o)).*...
    omega + ((p1*(rho/omega))/((rho/omega)+p2+(p3/omega))).*...
    rho; %domega/dt
f4= 12*p5 + 4*((vmax.*o)./(Km.*(1+(K1./r))+o)).*...
    omega - ((p1*(rho/omega))/((rho/omega)+p2+(p3/omega)))*...
    rho; %drho/dt

%define arrays containing all funcs and all params
funcs = [f1,f2,f3,f4];
params = [vmax,K1,Km,p1,p2,p3,p4,p5,t];

%call jacobian to calculate the jacobian function to calc all derivs
modelJacobi = jacobian(funcs,params);