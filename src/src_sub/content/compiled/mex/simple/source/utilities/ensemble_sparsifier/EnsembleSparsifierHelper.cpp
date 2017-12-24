/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#include "mex.h"
#include "matrix.h"

#include <iostream>
#include <vector>

#include "EnsembleSparsifier.hpp"

using namespace std;

extern void _main();

// mexFunction
void mexFunction(
  int          nlhs,
  mxArray      *plhs[],
  int          nrhs,
  const mxArray *prhs[]
  )
{
  double
    *ptr_N ;
  double
    *ptr_maxDist ,
    *ptr_sortedEnsemble ,
    *ptr_cdf ;
  
  size_t N;
    
  EnsembleSparsifier *ptr_ES;
  
  if ( nrhs < 4 )
  {
    mexErrMsgIdAndTxt
      (
        "MATLAB:EnsembleSparsifierHelper_Loaded:nargin" ,
        "EnsembleSparsifierHelper_Loaded needs at least 4 inputs."
      );
  }

  if ( nlhs < 1 ) 
  {
    mexErrMsgIdAndTxt
      (
        "MATLAB:EnsembleSparsifierHelper_Loaded:nargout",
        "EnsembleSparsifierHelper_Loaded requires at least 1 output argument."
      );
  }
  
  ptr_N              = (double *) mxGetPr(prhs[0]);
  ptr_maxDist        = (double *) mxGetPr(prhs[1]);
  ptr_sortedEnsemble = (double *) mxGetPr(prhs[2]);
  ptr_cdf            = (double *) mxGetPr(prhs[3]);
  
  N = static_cast<size_t>(*ptr_N);
  
  ptr_ES  = new 
            EnsembleSparsifier
              ( 
                 N ,
                *ptr_maxDist ,
                 ptr_sortedEnsemble ,
                 ptr_cdf
              );
  
  ptr_ES->computeSamples();
  
  const std::vector<size_t> &recordRef = 
    ptr_ES->returnSamplesIndices();
    
  plhs[0] = mxCreateDoubleMatrix ( 1 , recordRef.size() , mxREAL );
  
  double *ptr_samplesIndices = mxGetPr( plhs[0] );
  
  for ( size_t i=0 ; i<recordRef.size() ; i++ )
  {
    ptr_samplesIndices[i] = static_cast<double>(recordRef[i]) + 1.0;
  }
  
  delete ptr_ES;
}
 