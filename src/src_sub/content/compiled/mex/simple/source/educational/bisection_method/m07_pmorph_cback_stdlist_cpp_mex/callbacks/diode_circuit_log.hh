/*
 * This file is part of the "dev_in_place" repository located at:
 * https://github.com/osuvak/dev_in_place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#ifndef DIODE_CIRCUIT_LOG_HH_
#define DIODE_CIRCUIT_LOG_HH_

#include "callbacks/diode_circuit.hh"

namespace userdefn
{
  
class DiodeCircuitWithLog
:
public DiodeCircuit
{
public:
  
  DiodeCircuitWithLog
  (
    double R ,
    double IS ,
    double VIN ,
    double VT
  )
  :
  DiodeCircuit(R,IS,VIN,VT)
  {}
  
  virtual
  ~DiodeCircuitWithLog() {}
  
  virtual
  double
  callback
  (
    double VD
  )
  {
    return VT_ * log( ( VIN_ - VD ) / ( R_ * IS_ ) ) - VD;
  }
};
  
} // userdefn

#endif
