/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#ifndef CALLBACK_DIODE_HH_
#define CALLBACK_DIODE_HH_

#include "diode_circuit.hh"

namespace userdefn
{
  
double
callback_diode
(
  double   input ,
  void   * userdata
);
  
} // userdefn

#endif