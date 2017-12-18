/*
 * This file is part of the "dev_in_place" repository located at:
 * https://github.com/osuvak/dev_in_place
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
  double (*fptr)( double , void* );
  void   *userdata;
  
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
