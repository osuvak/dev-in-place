/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#ifndef BISECTION_OPTIONS_H_
#define BISECTION_OPTIONS_H_

#ifdef __cplusplus
extern "C" {
#endif

typedef struct BisectionOptions_
{
  double (*fptr)(double);
  
  double left;
  double right;
  
  double abstol,reltol,ftol;
  
  unsigned 
  int maxIter;
}BisectionOptions;

#ifdef __cplusplus
}
#endif

#endif