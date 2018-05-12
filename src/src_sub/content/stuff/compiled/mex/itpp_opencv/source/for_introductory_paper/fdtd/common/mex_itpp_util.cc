/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */


#include "common/mex_itpp_util.hh"

#include <iostream>
using namespace std;

void
matrix_real_itpp_to_mex
(
        double       * ptr,
  const itpp::mat    & M,
        unsigned int   xdim_gen,
        unsigned int   ydim_gen
)
{
  double *outArray[xdim_gen];
  outArray[0] = ptr;
  
//   cout << endl << "Before setting pointers." << endl << endl;
  
  for( size_t i = 1 ; i < xdim_gen ; i++ )
    outArray[i] = outArray[i-1] + ydim_gen;
  
//   cout << endl << "Set pointers." << endl << endl;
  
  for( size_t i = 0 ; i < xdim_gen ; i++ )
  {
    for( size_t j = 0 ; j < ydim_gen ; j++ )
    {
      outArray[j][i] = M(i,j);
    }
  }
  
//   cout << endl << "Assigned entries" << endl << endl;
}

void
rowvec_real_itpp_to_mex
(
        double       * ptr,
  const itpp::mat    & M,
        unsigned int   xdim_gen,
        unsigned int   ydim_gen
)
{
  for( size_t j = 0 ; j < ydim_gen ; j++ )
  {
    ptr[j] = M(0,j);
  }
}