/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2018  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#include "morris_lecar_model_cgu.hh" 

#include <adolc/adtl.h>

namespace os_numerical_composite
{
namespace models
{
namespace simulated_simple_models_sc
{

void
MorrisLecarModelCGu::computeF
(
        double     t ,
  const itpp::mat &x
)
{
  typedef adtl::adouble adouble;

  using namespace itpp;
  
  int no = 2;
  adtl::setNumDir(no);
  
  adouble V , N;
  adouble V_d , N_d;
  
  V = x(0,0);
  N = x(1,0);
  
  V.setADValue(0,1);
  N.setADValue(1,1);
  
  adouble M_inf = 0.5 * ( 1.0 + tanh((V-V1)/V2) );
  adouble N_inf = 0.5 * ( 1.0 + tanh((V-V3)/V4) );
  adouble tau_N = 1.0 / ( phi * cosh((V-V3)/(2.0*V4)) );
  
  V_d = 1.0 / CM * ( - gL*(V-VL) - gCa*M_inf*(V-VCa) - gK*N*(V-VK) + input_I(t) );
  N_d = ( N_inf - N ) / tau_N;
  
  f_cur_.clear();
  
  f_cur_(0,0) = V_d.getValue();
  f_cur_(1,0) = N_d.getValue();
  
  fJac_cur_.clear();
  
  fJac_cur_(0,0) = V_d.getADValue(0);
  fJac_cur_(0,1) = V_d.getADValue(1);
  fJac_cur_(1,0) = N_d.getADValue(0);
  fJac_cur_(1,1) = N_d.getADValue(1);
}

double
MorrisLecarModelCGu::input_I
(double t)
{
  double tt;
  double rise_over_2;
  double r;
  
  rise_over_2 = valForMinSlope / slopeAdjustFactor;
  tt = t - T * floor( t / T );
  
  if ( ( tt >= 0.0 ) && ( tt < pulse_begin - rise_over_2 ) )
    r = level_low;
  else if ( ( tt >= pulse_begin - rise_over_2 ) && ( tt < pulse_begin + rise_over_2 ) )
    r = level_low  + ( level_high - level_low ) / (2.0*rise_over_2) * ( tt - (pulse_begin - rise_over_2) );
  else if ( ( tt >= pulse_begin + rise_over_2 ) && ( tt < pulse_end   - rise_over_2 ) )
    r = level_high;
  else if ( ( tt >= pulse_end   - rise_over_2 ) && ( tt < pulse_end   + rise_over_2 ) )
    r = level_high - ( level_high - level_low ) / (2.0*rise_over_2) * ( tt - (pulse_end   - rise_over_2) );
  else if ( ( tt >= pulse_end   + rise_over_2 ) && ( tt < T ) )
    r = level_low;
  
  return r;
}
  
} // simulated_simple_models_sc
} // models
} // os_numerical_composite
