/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#ifndef BISECTION_HH_
#define BISECTION_HH_

#include<list>
#include<iostream>
#include<cstdio>
#include<cmath>

#include "internals/bisection_internals.hh"
#include "utilities/utilities_general.hh"

namespace nummethods
{
  
class BisectionMethod
{
  
private:
  
  double (*callback_)(double,void*);
  void    *userdata_;
  double   limLeft_;
  double   limRight_;
  double   abstol_;
  double   reltol_;
  double   ftol_;
  double   maxIter_;
  
private:
  
  int                 flag_;
  std::list<SolnItem> llist_;
  
public:
  
  BisectionMethod
  (
    double (*callback)(double,void*) ,
    void    *userdata ,
    double   limLeft ,
    double   limRight ,
    double   abstol   = 1.0e-30 ,
    double   reltol   = 1.0e-3 ,
    double   ftol     = 1.0e-4 ,
    double   maxIter  = 50
  )
  :
  callback_ (callback) ,
  userdata_ (userdata) ,
  limLeft_  (limLeft) ,
  limRight_ (limRight) ,
  abstol_   (abstol) ,
  reltol_   (reltol) ,
  ftol_     (ftol) ,
  maxIter_  (maxIter)
  {
    llist_.clear();
  }
  
  ~BisectionMethod
  ()
  {
    llist_.clear();
  }
  
  void
  compute
  ();
  
  int
  getFlag
  ()
  {
    return flag_;
  }
  
  const std::list<SolnItem> &
  getList
  ()
  {
    return llist_;
  }
};
  
} // nummethods

#endif