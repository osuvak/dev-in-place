/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#ifndef DIODE_CIRCUIT_HH_
#define DIODE_CIRCUIT_HH_

#include<cmath>

#include "core/bisection.hh"

namespace userdefn
{
  
class DiodeCircuit
:
public nummethods::CallbacksFather
{
protected:
  double R_;
  double IS_;
  double VIN_;
  double VT_;
  
public:
  
  DiodeCircuit
  (
    double R ,
    double IS ,
    double VIN ,
    double VT
  )
  :
  R_  (R) ,
  IS_ (IS) ,
  VIN_(VIN) ,
  VT_ (VT)
  {}
  
  virtual
  ~DiodeCircuit() {}
  
};
  
} // userdefn

#endif