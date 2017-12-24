/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#ifndef BISECTION_INTERNALS_H_
#define BISECTION_INTERNALS_H_

#include<stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct 
PointInfo_
{
  double val , fval;
  int    sign;
}PointInfo;

typedef struct 
IntervalInfo_
{
  PointInfo left , mid , right;
}IntervalInfo;

typedef struct
SolnLList_
{
  PointInfo point;
  double    err_x , err_f;
  
  struct SolnLList_ *next;
  struct SolnLList_ *prev;
}SolnLList;

// SolnIterates structure and its "methods"
typedef struct
SolnIterates_
{
  SolnLList    *llist;
  SolnLList    *llist_end;
  unsigned int  size;
}SolnIterates;

void
initialize
(
  SolnIterates *item
);

void
destroy
(
  SolnIterates *item
);

unsigned int
size
(
  const SolnIterates *item
);

void
append
(
  SolnIterates *item ,
  PointInfo     point ,
  double        err_x ,
  double        err_f
);

const SolnLList *
getLast
(
  SolnIterates *item
);

#ifdef __cplusplus
}
#endif

#endif