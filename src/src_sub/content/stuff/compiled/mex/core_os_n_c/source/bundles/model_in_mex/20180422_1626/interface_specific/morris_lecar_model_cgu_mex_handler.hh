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
#include "mex.h"

#include "simple_models_mex_handler.hh"
#include "models_defined/morris_lecar_model_cgu.hh"

namespace mex_wrappers
{
  
class MorrisLecarModelCGu_mexHandler
:
public SimpleModels_mexHandler
{
public:
  
  MorrisLecarModelCGu_mexHandler
  ()
  {
//     std::cout << "Constructing MorrisLecarModelCGu_mexHandler instance." << std::endl;
    
    setModel();
  }
  
  virtual
  ~MorrisLecarModelCGu_mexHandler
  ()
  {
//     std::cout << "Destructing MorrisLecarModelCGu_mexHandler instance." << std::endl;
  }
  
protected:
  
  virtual
  void
  setModel
  (void)
  {
    using namespace os_numerical_composite::models::simulated_simple_models_sc;
    
#ifdef USE_TEUCHOS_IN_MEX_HANDLERS    
    using Teuchos::rcp;
    
    model_ = rcp( new MorrisLecarModelCGu() );
#else
    /* 
     * Either of the below should work. 
     * I am testing if I can capture abstract base classes as template parameters
     * and also if move semantics work in the second option using make_shared.
     */
    
//     model_.reset( new MorrisLecarModelCGu() );
    model_ = std::make_shared<MorrisLecarModelCGu>();
#endif
  }
  
};
  
} // mex_wrappers
