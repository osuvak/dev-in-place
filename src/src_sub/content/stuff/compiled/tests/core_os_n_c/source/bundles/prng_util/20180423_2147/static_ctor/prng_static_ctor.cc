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

namespace os_prng_sc
{
  
PRNG_COMMON PRNG_Static :: obj_;
  
} // namespace os_prng_sc
