/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2018  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#include "mex.h"

#include <vector>
#include <map>
#include <algorithm>
#include <memory>
#include <string>
#include <sstream>
#include <iostream>

#include "morris_lecar_model_cgu_mex_handler.hh"

void
mexFunction
(
        int      nlhs ,
        mxArray *plhs[] ,
        int      nrhs ,
  const mxArray *prhs[]
) 
{
  using class_type = mex_wrappers::MorrisLecarModelCGu_mexHandler;
  
  class_type instance;
  
  if ( nrhs < 2 )
    mexErrMsgTxt("Action::Compute expects at least 2 inputs.");
  instance.compute( nlhs , plhs , nrhs , &prhs[0] ); // does not modify plhs
  
  if ( nlhs > 4 )
    mexErrMsgTxt("Action::ReturnAll expects at most 4 outputs.");
  instance.returnAll( nlhs , plhs , nrhs , &prhs[0] );

//   instance.returnFuncF( nlhs , plhs , nrhs , &prhs[0] );
//   instance.returnJacF ( nlhs , plhs , nrhs , &prhs[0] );
//   instance.returnFuncQ( nlhs , plhs , nrhs , &prhs[0] );
//   instance.returnJacQ ( nlhs , plhs , nrhs , &prhs[0] );
    
} // mexFunction
