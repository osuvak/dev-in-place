/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#include "callbacks/callback_diode.hh" 

namespace userdefn
{
  
double
callback_diode
(
  double   input ,
  void   * userdata
)
{
  DiodeCircuit *cir = static_cast<DiodeCircuit *>(userdata);
  
  return cir->callback(input);
}
  
} // userdefn