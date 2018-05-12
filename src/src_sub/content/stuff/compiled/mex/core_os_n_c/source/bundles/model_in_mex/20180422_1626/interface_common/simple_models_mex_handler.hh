/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2018  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#pragma once

#include <iostream>
#include <memory>

#include <omp.h>

// #define USE_TEUCHOS_IN_MEX_HANDLERS

#ifdef USE_TEUCHOS_IN_MEX_HANDLERS
#include "Teuchos_RCP.hpp"
#include "Teuchos_StandardCatchMacros.hpp"
#include "Teuchos_Assert.hpp"
#include "Teuchos_getConst.hpp"
#endif

#include "models_abstract/basic_abstract_model.hh"

#include "mex.h"

namespace mex_wrappers
{
  
class SimpleModels_mexHandler
{
  
public:
  
  using model_type 
    = os_numerical_composite::models::simulated_simple_models_sc::BasicAbstractModel;
  
  SimpleModels_mexHandler
  ()
  {
//     std::cout << "Constructing SimpleModels_mexHandler instance." << std::endl;
  }
  
  virtual
  ~SimpleModels_mexHandler
  ()
  {
//     std::cout << "Destructing SimpleModels_mexHandler instance." << std::endl;
  }
  
#ifdef USE_TEUCHOS_IN_MEX_HANDLERS
  Teuchos::RCP< model_type >
#else
  std::shared_ptr< model_type >
#endif
  &
  model_smart_ptr
  (void)
  {
    return this->model_;
  }
  
  model_type &
  model
  (void)
  {
    return *(this->model_);
  }
  
public:
  
  void
  getSize
  (
          int      nlhs ,
          mxArray *plhs[] ,
          int      nrhs ,
    const mxArray *prhs[]
  );
  
  void
  get_flag_is_q_time_dep
  (
          int      nlhs ,
          mxArray *plhs[] ,
          int      nrhs ,
    const mxArray *prhs[]
  );
  
  void
  compute
  (
          int      nlhs ,
          mxArray *plhs[] ,
          int      nrhs ,
    const mxArray *prhs[]
  );
  
  void
  returnFuncF
  (
          int      nlhs ,
          mxArray *plhs[] ,
          int      nrhs ,
    const mxArray *prhs[]
  );
  
  void
  returnFuncF_raw
  (
          int       nlhs ,
          mxArray  *plhs[] ,
          int       nrhs ,
    const mxArray  *prhs[] ,
          mxArray **buffer
  );

  void
  returnJacF
  (
          int      nlhs ,
          mxArray *plhs[] ,
          int      nrhs ,
    const mxArray *prhs[]
  );
  
  void
  returnJacF_raw
  (
          int       nlhs ,
          mxArray  *plhs[] ,
          int       nrhs ,
    const mxArray  *prhs[] ,
          mxArray **buffer
  );
  
  void
  returnFuncQ
  (
          int      nlhs ,
          mxArray *plhs[] ,
          int      nrhs ,
    const mxArray *prhs[]
  );
  
  void
  returnFuncQ_raw
  (
          int       nlhs ,
          mxArray  *plhs[] ,
          int       nrhs ,
    const mxArray  *prhs[] ,
          mxArray **buffer
  );
  
  void
  returnJacQ
  (
          int      nlhs ,
          mxArray *plhs[] ,
          int      nrhs ,
    const mxArray *prhs[]
  );
  
  void
  returnJacQ_raw
  (
          int       nlhs ,
          mxArray  *plhs[] ,
          int       nrhs ,
    const mxArray  *prhs[] ,
          mxArray **buffer
  );
  
  void
  returnAll
  (
          int      nlhs ,
          mxArray *plhs[] ,
          int      nrhs ,
    const mxArray *prhs[]
  );
  
protected:
  
  virtual
  void
  setModel
  (void)
  = 0;
  
protected:
  
#ifdef USE_TEUCHOS_IN_MEX_HANDLERS
  Teuchos::RCP< model_type > 
#else
  std::shared_ptr< model_type >
#endif
    model_;
  
};
  
} // mex_wrappers
