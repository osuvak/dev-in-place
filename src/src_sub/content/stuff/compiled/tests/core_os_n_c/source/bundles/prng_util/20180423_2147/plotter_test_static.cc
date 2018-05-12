/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2018  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#include "prng_static_ctor.hh"

#include <iostream>
#include <iomanip>
#include <algorithm>

int main ()
{
  using namespace os_prng_sc;
  
  const int nRolls  = 10000 ; // number of experiments
  
  std::vector<double> numbers;
  std::string heading;
  
  unsigned int ch = 1;

  switch ( ch )
  {
    case 1 :
      numbers = PRNG_Static::randn( nRolls , 5.0 , 2.0 );
      heading = "normal_distribution (5.0,2.0):";
      break;
    case 2 :
      numbers = PRNG_Static::rand( nRolls , 0.0 , 10.0 );
      heading = "uniform_distribution (0.0,10.0):";
      break;
  }
  
  plot_histogram( numbers , -3.0 , 12.0 );
  
  return 0;
}
