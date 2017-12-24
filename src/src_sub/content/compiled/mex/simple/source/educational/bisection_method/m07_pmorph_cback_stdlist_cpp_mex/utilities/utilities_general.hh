/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#ifndef UTILITIES_GENERAL_HH_
#define UTILITIES_GENERAL_HH_

namespace nummethods
{

template <typename T> 
int signum(T val) 
{
  return (T(0) < val) - (val < T(0));
}

} // nummethods

#endif