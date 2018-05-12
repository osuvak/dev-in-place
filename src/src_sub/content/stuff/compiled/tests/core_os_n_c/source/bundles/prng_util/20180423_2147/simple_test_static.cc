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
  
  const int nrolls=10000;  // number of experiments
  const int nstars=100;    // maximum number of stars to distribute

  int p[10]={};

  std::vector<double> numbers;
  std::string heading;
  
  unsigned int ch = 1;

  switch ( ch )
  {
    case 1 :
      numbers = PRNG_Static::randn( nrolls , 5.0 , 2.0 );
      heading = "normal_distribution (5.0,2.0):";
      break;
    case 2 :
      numbers = PRNG_Static::rand( nrolls , 0.0 , 10.0 );
      heading = "uniform_distribution (0.0,10.0):";
      break;
  }
  
  auto ff = 
    [&p] ( const double number ) 
    { if ( (number>=0.0) && (number<10.0) ) ++p[int(number)]; };
    
  std::for_each( numbers.begin() , numbers.end() , ff );
  
  std::cout << heading << std::endl;

  for (int i=0; i<10; ++i) {
    std::cout << std::setw(4) << i << "-" << std::setw(4) << (i+1) << ": ";
    std::cout << std::string(p[i]*nstars/nrolls,'*') << std::endl;
  }
  
  return 0;
}
