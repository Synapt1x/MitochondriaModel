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

/* void printIntArray(int NDim, int N, int *Q)
{
    int i, j, n;
    mexPrintf("\nInt Array: %i x %i\n", NDim, N); 
    for (i=0; i<NDim; i++) {
        for (j=0; j<N; j++) {
            n=i+NDim*j;
            mexPrintf("%i ", Q[n]);
        }
        mexPrintf("\n");
    }
}

void printDoubleArray(int NDim, int N, double *Q)
{
    int i, j, n;
    mexPrintf("\nDouble Array: %i x %i\n", NDim, N); 
    for (i=0; i<NDim; i++) {
        for (j=0; j<N; j++) {
            n=i+NDim*j;
            mexPrintf("%.5f ", Q[n]);
        }
        mexPrintf("\n");
    }
}

void printBoolArray(int NDim, int N, bool *Q)
{
    int i, j, n;
    mexPrintf("\nBoolean Array: %i x %i\n", NDim, N); 
    for (i=0; i<NDim; i++) {
        for (j=0; j<N; j++) {
            n=i+NDim*j;
            if (Q[n]) {
                mexPrintf("T ");
            } else {
                mexPrintf("F ");
            }
        }
        mexPrintf("\n");
    }
}
*/

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{   
    double *dij, *pPow, *Phi;
    double sigmaShare, ne;
    mxChar *nicheMethod;
    int popSize, i, j, Np, n, p;
    
    /* get dimensions of the input matrix */
    popSize = mxGetN(prhs[0]);
    plhs[0] = mxCreateDoubleMatrix(1,popSize,mxREAL);
    Phi=mxGetPr(plhs[0]);

    for (i=0; i<popSize; i++) {
        Phi[i]=0;
    }
    
    if (popSize > 0) {
        /* create pointer to the real data in the input matrices  */
        dij = mxGetPr(prhs[0]);
        sigmaShare = *mxGetPr(prhs[1]);
        nicheMethod = mxGetChars(prhs[2]);
        pPow=mxGetPr(prhs[3]);
        Np=mxGetM(prhs[3]);
        ne=*mxGetPr(prhs[4]);

        if (nicheMethod[0] == 'p' || nicheMethod[0] == 'P') {
            /* PowerLaw niching */
            for (i=0; i<popSize; i++) {
                for (j=0; j<popSize; j++) {
                    if (j != i) {
                        n=i+popSize*j;
                        for (p=0; p<Np; p++) {
                            Phi[i]=Phi[i]+pow(1+dij[n]/sigmaShare, -pPow[p]);
                        }
                    }
                }
            }
        } else {
            /* SigmaShare niching */
            for (i=0; i<popSize; i++) {
                for (j=0; j<popSize; j++) {
                    if (j != i) {
                        n=i+popSize*j;
                        if (dij[n] < sigmaShare) {
                            Phi[i]=Phi[i]+pow(1-dij[n]/sigmaShare, ne);
                        }
                    }
                }
            }
        }
    }
}
