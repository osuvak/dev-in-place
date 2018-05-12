/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */


#ifndef BASIC_HANDLER_CALLBACKS_HH_
#define BASIC_HANDLER_CALLBACKS_HH_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <pthread.h>

#include <signal.h>
#include <unistd.h>
#include <ctype.h>

#include "handlers/basic_handler.hh"
#include "ngspice/sharedspice.h"

int
ng_getchar
(
  char *outputreturn ,
  int   ident ,
  void *userdata
);

int
ng_getstat
(
  char *outputreturn ,
  int   ident ,
  void *userdata
);

int
ng_exit
(
  int   exitstatus ,
  bool  immediate ,
  bool  quitexit ,
  int   ident ,
  void *userdata
);

int
ng_thread_runs
(
  bool  noruns ,
  int   ident ,
  void *userdata
);

int
ng_initdata
(
  pvecinfoall  intdata ,
  int          ident ,
  void        *userdata
);

int
ng_data
(
  pvecvaluesall  vdata ,
  int            numvecs ,
  int            ident ,
  void          *userdata
);

void
alterp
(
  int sig
);

int
cieq
(
  register char *p ,
  register char *s
);

#endif