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

/*
 void printIntArray(int NDim, int N, int *Q)
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

bool * index2Logical(mwSize N, mxArray *mxIndex)
{
    int i, NI;
    double *index;
    
    NI=mxGetN(mxIndex);
    index=mxGetPr(mxIndex);
    
    bool *mask = (bool *)malloc(N*sizeof(bool));
    for (i=0; i<N; i++) {
        mask[i]=false;
    }
    for (i=0; i<NI; i++) {
        if (index[i] <= N & index[i] >= 1) {
            mask[(int)index[i]-1]=true;
        }
    }
    return(mask);
}
*/

/* rankPareto=zeros(1, NRequested);
for i=1:NRequested
    Fi=repmat(F(:,i), 1, NF);
    Q=Inf(NObj, NF);
    index=dFFuzzy > 0;
    Q(index)=(Fi(index)-F(index))./dFFuzzy(index);
    whichIndividualsAreSuperior=prod(0 + (F <= Fi), 1) & sum(F < Fi, 1) & sum(Q.^2, 1) > 1;
    numberSuperiorIndividuals=sum(0 + whichIndividualsAreSuperior);
    rankPareto(i)=1 + numberSuperiorIndividuals;
end */

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{   
    double *thisQ, *Q, *dVec, *indexCyclic;
    bool isX;
    double hme, inv_hme, QDiff, QDiff2;
    bool *cyclic;
    char *str;
    int N, NDim, i, j, n, NI;
    int *effectiveDimensionality;
    
    
    /* get dimensions of the input matrix */
    NDim = mxGetM(prhs[1]);
    N = mxGetN(prhs[1]);
    
    /* create the output matrix */
    plhs[0] = mxCreateDoubleMatrix(1,N,mxREAL);
    dVec = mxGetPr(plhs[0]);

    /* create pointer to the real data in the input matrices  */
    thisQ = mxGetPr(prhs[0]);
    Q = mxGetPr(prhs[1]);
    isX = *mxGetLogicals(prhs[2]);
    hme = *mxGetPr(prhs[3]);
    indexCyclic=mxGetPr(prhs[4]);
    NI=mxGetN(prhs[4]);
    
    /* ===== Computational routine: ===== */
    
    /* Convert cyclic to logical map. "tmp" must contain the
    cyclic indices at this point in the code. */
    cyclic = (bool *)malloc(NDim*sizeof(bool));
    for (i=0; i<NDim; i++) {
        cyclic[i]=false;
    }
    for (i=0; i<NI; i++) {
        if (indexCyclic[i] <= NDim & indexCyclic[i] >= 1) {
            cyclic[(int)indexCyclic[i]-1]=true;
        }
    }
    
    effectiveDimensionality=(int *)malloc(N*sizeof(int));
    
    for (j=0; j<N; j++) {
        effectiveDimensionality[j]=0;
        dVec[j]=0.0;
    }
    
    for (i=0; i<NDim; i++) {
        if (isX & cyclic[i]) {
            for(j=0; j<N; j++) {
                n=i+NDim*j;
                QDiff=Q[n]-thisQ[i];
                if (QDiff == QDiff) {
                    QDiff=fabs(QDiff);
                    QDiff2=1.0-QDiff;
                    if (QDiff2 < QDiff) {
                        dVec[j] = dVec[j]+pow(QDiff2, hme);
                    } else {
                        dVec[j] = dVec[j]+pow(QDiff, hme);
                    }
                    effectiveDimensionality[j]+=1;
                }
            }
        } else {
            for (j=0; j<N; j++) {
                n=i+NDim*j;
                QDiff=Q[n]-thisQ[i];
                if (QDiff == QDiff) {
                    dVec[j] = dVec[j]+pow(fabs(QDiff), hme);
                    effectiveDimensionality[j]+=1;
                }
            }
        }
    }
    inv_hme=1/hme;
    for (j=0; j<N; j++) {
        if (effectiveDimensionality[j] <= 1) {
            dVec[j]=pow(dVec[j], inv_hme);
        } else {
            dVec[j]=pow(dVec[j]/effectiveDimensionality[j], inv_hme);
        }
    }
    
    /* Free memory: */
    free(cyclic);
    free(effectiveDimensionality);
}
