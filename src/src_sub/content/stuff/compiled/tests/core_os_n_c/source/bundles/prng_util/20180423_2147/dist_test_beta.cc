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

// #define USE_STATIC_IMPL

int main ()
{
#ifdef HAVE_BOOST
  using namespace os_prng_sc;
  
  const int nRolls  = 100000 ; // number of experiments

#ifndef USE_STATIC_IMPL
  PRNG_COMMON rgen;
#endif

  std::vector<double> numbers;
  std::string heading;
  
  unsigned int ch = 3;

  switch ( ch )
  {
    case 1 :
      numbers = 
#ifndef USE_STATIC_IMPL
        rgen.randn
#else
        PRNG_Static::randn
#endif
          ( nRolls , 5.0 , 2.0 );
      heading = "normal_distribution (5.0,2.0):";
      break;
    case 2 :
      numbers = 
#ifndef USE_STATIC_IMPL
        rgen.rand
#else
        PRNG_Static::rand
#endif
          ( nRolls , 0.0 , 10.0 );
      heading = "uniform_distribution (0.0,10.0):";
      break;
    case 3 :
      numbers = 
#ifndef USE_STATIC_IMPL
        rgen.randbeta
#else
        PRNG_Static::randbeta
#endif
          ( nRolls , 5.0 , 2.0 , 10.0 , 20.0 );
      heading = "beta_distribution (5.0, 2.0):";
      break;
  }
  
  plot_histogram( numbers , 10.0 , 20.0 , heading , 500 , 40 );
#endif
  
  return 0;
}
