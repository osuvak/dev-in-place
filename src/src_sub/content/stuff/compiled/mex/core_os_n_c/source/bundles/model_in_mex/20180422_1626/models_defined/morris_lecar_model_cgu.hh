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

#include "models_abstract/basic_abstract_model.hh"

namespace os_numerical_composite
{
namespace models
{
namespace simulated_simple_models_sc
{

class MorrisLecarModelCGu
:
public BasicAbstractModel
{
  
protected:
  
  virtual
  void
  computeF
  (
          double     t ,
    const itpp::mat &x
  );

public:
  
  double CM;
        
  double gK;
  double gL;
  double gCa;
        
  double VCa;
  double VK;
  double VL;
        
  double V1;
  double V2;
  double V3;
  double V4;
        
  double phi;
  
public:
  
  double level_low;
  double level_high;
        
  double pulse_begin;
  double pulse_end;
        
  double valForMinSlope;
  double slopeAdjustFactor;
        
  double T;
        
public:
  
  MorrisLecarModelCGu
  ()
  :
  BasicAbstractModel(2,false)
  {
    setDefaultParams();
    setDefaultParams_input();
  }
  
  virtual
  ~MorrisLecarModelCGu
  ()
  {}
  
public:
  
  double
  input_I
  (double t);
  
public:
  
  void
  setDefaultParams
  ()
  {
    CM  = 20.0;
        
    gK  = 8.0;
    gL  = 2.0;
    gCa = 4.0;
        
    VCa = 120.0;
    VK  = -80.0;
    VL  = -60.0;
        
    V1  = -1.2;
    V2  = 18.0;
    V3  = 12.0;
    V4  = 17.4;
        
    phi = 1.0 / 15.0;
  }
  
  void
  setDefaultParams_input
  ()
  {
    level_low  = 30.0;
    level_high = 60.0;
        
    pulse_begin =  80.0;
    pulse_end   = 120.0;
        
    valForMinSlope    = 15.0;
    slopeAdjustFactor = 2.0;
        
    T = 150.0;
  }
  
};
  
} // simulated_simple_models_sc
} // models
} // os_numerical_composite
