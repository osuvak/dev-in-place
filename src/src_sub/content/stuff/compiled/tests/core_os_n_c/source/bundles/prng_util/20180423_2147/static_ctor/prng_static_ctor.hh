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

#include "prng_utilities/prng_common.hh"

namespace os_prng_sc
{

class PRNG_Static
{
private:
  static PRNG_COMMON obj_;
  
public:
  
  /*
   * Below : Perfect forwarding static functions with variadic templates (C++11 style)
   * See the answer in the following url :
   * 
   * https://stackoverflow.com/questions/17748059/perfect-forwarding-for-void-and-non-void-returning-functions
   * */
  
  template<typename... Args>
  static
  auto rand( Args&&... args )
  ->decltype( obj_.rand( std::forward<Args>(args)... ) )
  {
    return obj_.rand( std::forward<Args>(args)... );
  }
  
  template<typename... Args>
  static
  auto randn( Args&&... args )
  ->decltype( obj_.randn( std::forward<Args>(args)... ) )
  {
    return obj_.randn( std::forward<Args>(args)... );
  }

#ifdef HAVE_BOOST
  template<typename... Args>
  static
  auto randbeta( Args&&... args )
  ->decltype( obj_.randbeta( std::forward<Args>(args)... ) )
  {
    return obj_.randbeta( std::forward<Args>(args)... );
  }
#endif
};
  
} // namespace os_prng_sc