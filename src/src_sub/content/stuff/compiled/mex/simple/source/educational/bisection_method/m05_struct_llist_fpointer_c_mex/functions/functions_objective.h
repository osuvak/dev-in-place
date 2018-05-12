/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#ifndef FUNCTIONS_OBJECTIVE_H_
#define FUNCTIONS_OBJECTIVE_H_

#include<math.h>

#ifdef __cplusplus
extern "C" {
#endif

double
func_bias_diode
(
  double VD
);

double
func_bias_diode_with_exp
(
  double VD
);

#ifdef __cplusplus
}
#endif

#endif