/*
 * This file is part of the "dev_in_place" repository located at:
 * https://github.com/osuvak/dev_in_place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#include "utilities_general.h" 

int
signum
(
  double x
)
{
  return (x > 0.0) ? 1 : ((x < 0.0) ? -1 : 0);
}