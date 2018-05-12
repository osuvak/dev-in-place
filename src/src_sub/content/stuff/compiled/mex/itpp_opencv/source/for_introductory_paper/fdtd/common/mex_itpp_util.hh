/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */


#ifndef MEX_ITPP_UTIL_HH_
#define MEX_ITPP_UTIL_HH_

#include "mex.h"
// #include "matrix.h"

#include <math.h> 

#include <itpp/itstat.h>

void
matrix_real_itpp_to_mex
(
        double       * ptr,
  const itpp::mat    & M,
        unsigned int   xdim_gen,
        unsigned int   ydim_gen
);

void
rowvec_real_itpp_to_mex
(
        double       * ptr,
  const itpp::mat    & M,
        unsigned int   xdim_gen,
        unsigned int   ydim_gen
);

#endif