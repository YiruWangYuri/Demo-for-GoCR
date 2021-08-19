#include "mex.h"
#include "math.h"
#include<stdio.h>

void mexFunction(int nlhs,mxArray *plhs[], int nrhs,const mxArray *prhs[]) {
//[best_U_branch]=getChild(bestBranch, best_U_index, bits_per_dim, dimension);

    double *bestBranch;
	double bits_per_dim_, dimension_, num_thread_;

    double *subbranch;

    bestBranch = mxGetPr(prhs[0]);
    bits_per_dim_ = *mxGetPr(prhs[1]);
    dimension_ = *mxGetPr(prhs[2]);
    num_thread_ = *mxGetPr(prhs[3]);
    plhs[0] = mxCreateDoubleMatrix((int)(2*dimension_*num_thread_), 1, mxREAL);
    subbranch = mxGetPr(plhs[0]);
    
    int bits_per_dim = (int)bits_per_dim_;
    int dimension = (int)dimension_;
    int num_thread = (int)num_thread_;
    
    
    for( int index = 0;  index < num_thread; index++) {
        
        int ind[dimension];
        for ( int i = 0; i < dimension; ++i ) {
            ind[i] = index / (int)(pow(bits_per_dim, i));
        }
        
        for ( int i = 0;  i < dimension; ++i) {
            subbranch[index*dimension*2+i] = bestBranch[i] + (bestBranch[i+dimension] / (int)bits_per_dim) * (ind[i] - (ind[i] / (int)bits_per_dim) * (int)bits_per_dim);
            subbranch[index*dimension*2+i+dimension] = bestBranch[i+dimension] / (int)bits_per_dim;
        }
    }

}
