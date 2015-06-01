/*===========================================================================
% Qubist: A Global Optimization, Modeling & Visualization Toolbox for MATLAB
%
% Ferret: A Multi-Objective Linkage-Learning Genetic Algorithm
% Locust: A Multi-Objective Particle Swarm Optimizer
% Anvil: A Multi-Objective Simulated Annealing/Genetic Algorithm Hybrid
% SAMOSA: Simple Approach to a Multi-Objective Simplex Algorithm
%
% Copyright 2002-2011. nQube Technical Computing Corp. All rights reserved.
% Author: Jason D. Fiege, Ph.D.
% design.innovate.optimize @ www.nQube.ca
% ===========================================================================*/

#include "mex.h"
#include "matrix.h"
#include "math.h"
#undef isnan

/* See file fitness.m for the equivalent m-file. */

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[]) {
    
    /* Declarations: note that Matlab structures use type mxArray in C. */
    int NGenes, NIndiv, N, NTerms, i, j, n, DOF;
    double *X, *F, sigma, *xData, f, *fData, C, phi;
    mxArray *xData_mx, *K;
    
    /* printDoubleArray(M,N,ndxindexRO); */
    X=mxGetPr(prhs[0]);
    NGenes=mxGetM(prhs[0]);
    NIndiv=mxGetN(prhs[0]);
    
    /* create the output matrix */
    plhs[0] = mxCreateDoubleMatrix(1, NIndiv, mxREAL);
    F=mxGetPr(plhs[0]);
    
    /* Extract fields from extPar. */
    xData_mx=mxGetField(prhs[1], 0, "x");
    N=mxGetN(xData_mx);
    xData=mxGetPr(xData_mx);
    fData=mxGetPr(mxGetField(prhs[1], 0, "f"));
    sigma=mxGetScalar(mxGetField(prhs[1], 0, "sigma"));
    K=mxGetField(prhs[1], 0, "K");
    NTerms=mxGetScalar(mxGetField(K, 0, "NTerms"));
    DOF=N-2*NTerms;
    
    /* Calculate chi-squared for each individual. */
    for (i=0; i<NIndiv; i++) { /* loop over individuals. */
        F[i]=0;
        for (j=0; j<N; j++) { /* loop over data points. */
            f=0;
            for (n=0; n<NTerms; n++) { /* loop over terms in cos series. */
                C=X[n+NGenes*i];
                phi=X[(n+NTerms)+NGenes*i];
                f=f+C*cos((n+1)*xData[j]+phi);
            }
            F[i]=F[i]+pow((f-fData[j])/sigma, 2);
        }
        F[i]=F[i]/DOF;
    }
}