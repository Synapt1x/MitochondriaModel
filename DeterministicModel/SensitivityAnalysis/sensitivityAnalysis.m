function [equations,lhs, output] = sensitivityAnalysis()
%{
Created by: Chris Cadonic
========================================
This function houses code for using symbolic variables to represent
functions in my deterministic model. This function will be essential
to conducting sensitivity analysis for my masters project by finding
the Jacobian of the set of equations in my model. This will be done
using the symbolic functions for each equation in my model as
carried out below.
This will be carrying out sensitivty analysis for the baseline system.
%}

%Initialize the symbolic variables in the model; vars, params and t
syms r o omega rho f0vmax f0K vmax K1 Km p1 p2 p3 p4 t cytcdiff;
[equations, output] = deal({});

%define cytcdiff
cytcdiff = 100.1 - r;

%Define each of the baseline equations from the mito model
f1 = 2*((f0vmax*(cytcdiff))/(f0K+(cytcdiff))) ...
        *(omega./rho) - 2*((vmax*o)/(Km*(1 ...
        +(K1/r))+o))*(omega/rho); %dr
f2 = -0.5*((vmax*o)/(Km*(1+(K1/r))+o)) ...
      *(omega/rho); %do
f3 = -6*((f0vmax*(cytcdiff))/(f0K+(cytcdiff))) ...
        *(omega./rho) - 2*((vmax*o)/(Km*(1 ...
        +(K1/r))+o))*(omega/rho) + ((p1 ...
        *(rho/omega))/((rho/omega)+p2 + (p3/omega)))*rho; %domega

%define arrays containing all funcs and all params
funcs = [f1,f2,f3];
params = [f0vmax,f0K,vmax,K1,Km,p1,p2,p3,t];

%call jacobian to calculate the jacobian function to calc all derivs
jacobianMatrix = jacobian(funcs,params);

% create the sampling pool using latin hypercube sampling
lhs = lhsdesign(1E4,9);

for eq =1:numel(jacobianMatrix)
      tic
      equations{eq} = jacobianMatrix(eq); %store each equation
      
      lhsCell = num2cell(lhs); %convert to cell matrix
      for i=1:size(lhs,1)
            [f0vmax, f0K, vmax, K1, Km, p1, p2, p3, t] = deal(lhsCell{i,:});
      
            output{i,eq} = subs(jacobianMatrix(eq));
      end
      toc
end

