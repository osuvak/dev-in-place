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

#ifdef HAVE_BOOST
#include <boost/math/special_functions/beta.hpp>
#endif

namespace os_prng_sc
{
#ifdef HAVE_BOOST
  /* 
   * See the suggestion on Beta random number generation on the page with url :
   * 
   * https://stackoverflow.com/questions/15165202/random-number-generator-with-beta-distribution
   * */
  // randbeta
  std::vector<double>
  PRNG_COMMON::randbeta
  (
    const unsigned int howMany ,
    const double       val_alpha ,
    const double       val_beta ,
    const double       val_a ,
    const double       val_b
  )
  {
    assert( val_b > val_a );
    
    using namespace std;
    
    vector<double> current( howMany , 0.0 );
    
    for ( auto & vv : current )
      vv = 
        val_a 
        + 
        ( val_b - val_a ) 
        * 
        boost::math::ibeta_inv
          ( val_alpha , val_beta , v_dist_uniform_.front()( v_generator_.front() ) );
    
    return current;
  }
#endif
} // namespace os_prng_sc
