/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2018  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#pragma once

#include <chrono>
#include <random>
#include <memory>
#include <vector>
#include <iostream>
#include <iomanip>
#include <sstream>
#include <algorithm>

#include <cassert>
#include <cstdio>

#define HAVE_BOOST

namespace os_prng_sc
{
  
class PRNG_COMMON
{
private:
  unsigned                                  seed_;
  std::vector< std::default_random_engine > v_generator_;
  
  // distributions
  std::vector< std::uniform_real_distribution<double> > v_dist_uniform_;
  std::vector< std::normal_distribution<double> >       v_dist_normal_;
  
public:
  PRNG_COMMON ()
  {
    seed_ = std::chrono::high_resolution_clock::now().time_since_epoch().count();
    
    v_generator_.clear();
    v_generator_.emplace_back( seed_ );
    
    // initialize commonly used distributions
    v_dist_uniform_.emplace_back( 0.0 , 1.0 );
    v_dist_normal_ .emplace_back( 0.0 , 1.0 );
  }
  
  ~PRNG_COMMON ()
  {}
  
  // rand
  std::vector<double>
  rand
  (
    const unsigned int howMany ,
    const double       val_a = 0.0 ,
    const double       val_b = 1.0
  )
  {
    assert( val_b > val_a );
    
    using namespace std;
    
    vector<double> current( howMany , 0.0 );
    
    for ( auto & vv : current )
      vv = val_a + ( val_b - val_a ) * v_dist_uniform_.front()( v_generator_.front() );
    
    return current;
  }
  
  // randn
  std::vector<double>
  randn
  (
    const unsigned int howMany ,
    const double       val_mean  = 0.0 ,
    const double       val_stdev = 1.0
  )
  {
    using namespace std;
    
    vector<double> current( howMany , 0.0 );
    
    for ( auto & vv : current )
      vv = val_mean + val_stdev * v_dist_normal_.front()( v_generator_.front() );
    
    return current;
  }
  
#ifdef HAVE_BOOST
  // randbeta
  std::vector<double>
  randbeta
  (
    const unsigned int howMany ,
    const double       val_alpha ,
    const double       val_beta ,
    const double       val_a = 0.0 ,
    const double       val_b = 1.0
  );
#endif
  
};

  /*
   * This function is adapted from the example in the url :
   * 
   * http://www.cplusplus.com/reference/random/normal_distribution/
   * */
  template
  <typename T>
  void
  plot_histogram
  (
    const typename std::vector<T> & vec ,
    const double                    bLow ,
    const double                    bHigh ,
    const std::string               heading     = "Histogram" ,
    const unsigned int              nStars      = 100 ,    // maximum number of stars to distribute
    const unsigned int              nPartitions = 10       // number of partitions
  )
  {
    assert( bHigh > bLow );
    
    const unsigned int & sz = nPartitions;
    std::vector<int> p( sz , 0 );
    
    auto ff = 
      [ &p , &sz , bLow , bHigh ] ( const double number ) 
      { 
        double num_temp = ( ((double)number) - bLow ) / ( bHigh - bLow ) * ( (double) sz );
        if ( ( num_temp >= 0.0 ) && ( num_temp < ( (double) sz ) ) ) 
          ++p[int(num_temp)]; 
      };
      
    std::for_each( vec.cbegin() , vec.cend() , ff );
    
    char str[256];
    
    std::cout << heading << std::endl;
    for ( unsigned int i=0 ; i<sz ; ++i ) 
    {
      std::ostringstream ssLow , ssHigh;
      sprintf( str , "%12.2e" , bLow + ( bHigh - bLow ) / sz * i );
      ssLow  << str;
      sprintf( str , "%12.2e" , bLow + ( bHigh - bLow ) / sz * (i+1) );
      ssHigh << str;
      
      std::cout 
        << std::setw(16) << "[" + ssLow.str()  + "]"
        << "-" 
        << std::setw(16) << "[" + ssHigh.str() + "]"
        << " : ";
      std::cout << std::string( p[i] * nStars / vec.size() , '*' ) << std::endl;
    }
  }

} // namespace os_prng_sc