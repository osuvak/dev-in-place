/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#ifndef BISECTION_INTERNALS_HH_
#define BISECTION_INTERNALS_HH_

namespace nummethods
{
  
struct 
PointInfo
{
  double val , fval;
  int    sign;
  
  PointInfo
  (
    double val_ ,
    double fval_ ,
    int    sign_
  )
  :
  val  (val_) ,
  fval (fval_) ,
  sign (sign_)
  {}
  
  PointInfo() {}
};

struct 
IntervalInfo
{
  PointInfo left , mid , right;
  
  IntervalInfo
  (
    PointInfo left_ ,
    PointInfo mid_ ,
    PointInfo right_
  )
  :
  left  (left_) ,
  mid   (mid_) ,
  right (right_)
  {}
  
  IntervalInfo() {}
};

struct
SolnItem
{
  PointInfo point;
  double    err_x , err_f;
  
  SolnItem
  (
    PointInfo point_ ,
    double    err_x_ ,
    double    err_f_
  )
  :
  point (point_) ,
  err_x (err_x_) ,
  err_f (err_f_)
  {}
  
  SolnItem() {}
};
 
} // nummethods

#endif 