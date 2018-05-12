/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2018  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#include "prng_common.hh"

#include <iostream>
#include <iomanip>
#include <algorithm>

int main ()
{
  using namespace os_prng_sc;
  
  const int nRolls  = 10000 ; // number of experiments
  
  PRNG_COMMON rgen;

  std::vector<double> numbers;
  std::string heading;
  
  unsigned int ch = 1;

  switch ( ch )
  {
    case 1 :
      numbers = rgen.randn( nRolls , 5.0 , 2.0 );
      heading = "normal_distribution (5.0,2.0):";
      break;
    case 2 :
      numbers = rgen.rand( nRolls , 0.0 , 10.0 );
      heading = "uniform_distribution (0.0,10.0):";
      break;
  }
  
  plot_histogram( numbers , -3.0 , 6.0 );
  
  return 0;
}
