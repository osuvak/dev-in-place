/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2018  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#include "simple_models_mex_handler.hh" 

#include <itpp/itstat.h>

namespace mex_wrappers
{

void
SimpleModels_mexHandler::getSize
(
        int      nlhs ,
        mxArray *plhs[] ,
        int      nrhs ,
  const mxArray *prhs[]
)
{
  plhs[0] = mxCreateDoubleScalar( static_cast<double>( this->model_->getSize() ) );
}
  
void
SimpleModels_mexHandler::get_flag_is_q_time_dep
(
        int      nlhs ,
        mxArray *plhs[] ,
        int      nrhs ,
  const mxArray *prhs[]
)
{
  bool val = this->model_->get_flag_is_q_time_dep();
  double r = (val ? 1.0 : 0.0);
  
  plhs[0] = mxCreateDoubleScalar( r );
}
  
void
SimpleModels_mexHandler::compute
(
        int      nlhs ,
        mxArray *plhs[] ,
        int      nrhs ,
  const mxArray *prhs[]
)
{
  using namespace itpp;
  
  if ( !(nrhs >= 2) )
    mexErrMsgTxt("SimpleModels_mexHandler::compute expects 2 arguments.");
  
  if ( !( ( mxGetClassID(prhs[0]) == mxDOUBLE_CLASS ) &&
          (  mxGetNumberOfElements(prhs[0]) == 1 ) 
        ) )
    mexErrMsgTxt("SimpleModels_mexHandler::compute expects 1st argument as a scalar.");
  
  if ( !( ( mxGetClassID(prhs[1]) == mxDOUBLE_CLASS )
        ) )
    mexErrMsgTxt("SimpleModels_mexHandler::compute expects 2nd argument as a double.");
  
  if ( this->model_->getSize() != mxGetNumberOfElements(prhs[1]) )
    mexErrMsgTxt("SimpleModels_mexHandler::compute reports 2nd argument is of incompatible size.");
  
  double t = mxGetScalar( prhs[0] );
  
  mat x;
  x.set_size( this->model_->getSize() , 1 );
  
  double *ptr = mxGetPr(prhs[1]);
  for( size_t i = 0 ; i < mxGetNumberOfElements(prhs[1]) ; i++ )
  {
    double value = ptr[i];
    x(i,0) = value;
  }
  
  this->model_->compute(t,x);
}
  
void
SimpleModels_mexHandler::returnFuncF
(
        int      nlhs ,
        mxArray *plhs[] ,
        int      nrhs ,
  const mxArray *prhs[]
)
{
  mxArray **temp;
  returnFuncF_raw ( nlhs , plhs , nrhs , &prhs[0] , temp );
  plhs[0] = *temp;
}

void
SimpleModels_mexHandler::returnFuncF_raw
(
        int       nlhs ,
        mxArray  *plhs[] ,
        int       nrhs ,
  const mxArray  *prhs[] ,
        mxArray **buffer
)
{
  using namespace itpp;
  
  unsigned int sz = this->model_->getSize();
  *buffer = mxCreateDoubleMatrix( sz , 1 , mxREAL );
  const mat &v = this->model_->returnFuncF();
  
  double *ptr = mxGetPr(*buffer);
  for( size_t i = 0 ; i < mxGetNumberOfElements(*buffer) ; i++ )
  {
    ptr[i] = v(i,0);
  }
}
  
void
SimpleModels_mexHandler::returnJacF
(
        int      nlhs ,
        mxArray *plhs[] ,
        int      nrhs ,
  const mxArray *prhs[]
)
{
  mxArray **temp;
  returnJacF_raw ( nlhs , plhs , nrhs , &prhs[0] , temp );
  plhs[0] = *temp;
}

void
SimpleModels_mexHandler::returnJacF_raw
(
        int       nlhs ,
        mxArray  *plhs[] ,
        int       nrhs ,
  const mxArray  *prhs[] ,
        mxArray **buffer
)
{
  using namespace itpp;
  
  unsigned int sz = this->model_->getSize();
  *buffer = mxCreateDoubleMatrix( sz , sz , mxREAL );
  const mat &v = this->model_->returnJacF();
  
  double *outArray[sz];
  outArray[0] = mxGetPr(*buffer);
  for( size_t i = 1 ; i < sz ; i++ )
    outArray[i] = outArray[i-1] + sz;
  
  for( size_t i = 0 ; i < sz ; i++ )
  {
    for( size_t j = 0 ; j < sz ; j++ )
    {
      outArray[j][i] = v(i,j);
    }
  }
}
  
void
SimpleModels_mexHandler::returnFuncQ
(
        int      nlhs ,
        mxArray *plhs[] ,
        int      nrhs ,
  const mxArray *prhs[]
)
{
  mxArray **temp;
  returnFuncQ_raw ( nlhs , plhs , nrhs , &prhs[0] , temp );
  plhs[0] = *temp;
}

void
SimpleModels_mexHandler::returnFuncQ_raw
(
        int       nlhs ,
        mxArray  *plhs[] ,
        int       nrhs ,
  const mxArray  *prhs[] ,
        mxArray **buffer
)
{
  using namespace itpp;
  
  unsigned int sz = this->model_->getSize();
  *buffer = mxCreateDoubleMatrix( sz , 1 , mxREAL );
  const mat &v = this->model_->returnFuncQ();
  
  double *ptr = mxGetPr(*buffer);
  for( size_t i = 0 ; i < mxGetNumberOfElements(*buffer) ; i++ )
  {
    ptr[i] = v(i,0);
  }
}

void
SimpleModels_mexHandler::returnJacQ
(
        int      nlhs ,
        mxArray *plhs[] ,
        int      nrhs ,
  const mxArray *prhs[]
)
{
  mxArray **temp;
  returnJacQ_raw ( nlhs , plhs , nrhs , &prhs[0] , temp );
  plhs[0] = *temp;
}

void
SimpleModels_mexHandler::returnJacQ_raw
(
        int       nlhs ,
        mxArray  *plhs[] ,
        int       nrhs ,
  const mxArray  *prhs[] ,
        mxArray **buffer
)
{
  using namespace itpp;
  
  unsigned int sz = this->model_->getSize();
  *buffer = mxCreateDoubleMatrix( sz , sz , mxREAL );
  const mat &v = this->model_->returnJacQ();
  
  double *outArray[sz];
  outArray[0] = mxGetPr(*buffer);
  for( size_t i = 1 ; i < sz ; i++ )
    outArray[i] = outArray[i-1] + sz;
  
  for( size_t i = 0 ; i < sz ; i++ )
  {
    for( size_t j = 0 ; j < sz ; j++ )
    {
      outArray[j][i] = v(i,j);
    }
  }
}

void
SimpleModels_mexHandler::returnAll
(
        int      nlhs ,
        mxArray *plhs[] ,
        int      nrhs ,
  const mxArray *prhs[]
)
{
  mxArray *temp[4];

  unsigned int cnt = 0;
  
  returnFuncF_raw ( nlhs , plhs , nrhs , &prhs[0] , &temp[cnt] );
  plhs[cnt] = temp[cnt];
  
#define USE_IMPL_WITH_SWITCH
  
#ifndef USE_IMPL_WITH_SWITCH
  
  if ( nlhs > cnt + 1 )
  {
    ++cnt;
    returnJacF_raw  ( nlhs , plhs , nrhs , &prhs[0] , &temp[cnt] );
    plhs[cnt] = temp[cnt];
  }
  
  if ( nlhs > cnt + 1 )
  {
    ++cnt;
    returnFuncQ_raw ( nlhs , plhs , nrhs , &prhs[0] , &temp[cnt] );
    plhs[cnt] = temp[cnt];
  }
  
  if ( nlhs > cnt + 1 )
  {
    ++cnt;
    returnJacQ_raw  ( nlhs , plhs , nrhs , &prhs[0] , &temp[cnt] );
    plhs[cnt] = temp[cnt];
  }
  
#else  
  
  // a switch statement with no breaks
  // fall-through
  switch ( 4 - nlhs )
  {
    case 0 :
      cnt = 3;
      returnJacQ_raw  ( nlhs , plhs , nrhs , &prhs[0] , &temp[cnt] );
      plhs[cnt] = temp[cnt];
  
    case 1 :
      cnt = 2;
      returnFuncQ_raw ( nlhs , plhs , nrhs , &prhs[0] , &temp[cnt] );
      plhs[cnt] = temp[cnt];
  
    case 2 :
      cnt = 1;
      returnJacF_raw  ( nlhs , plhs , nrhs , &prhs[0] , &temp[cnt] );
      plhs[cnt] = temp[cnt];
      
    default:
      break;
  } // switch
#endif

} // member function

} // mex_wrappers