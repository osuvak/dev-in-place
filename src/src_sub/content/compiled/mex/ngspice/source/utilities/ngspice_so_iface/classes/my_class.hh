/*
 * This file is part of the "dev_in_place" repository located at:
 * https://github.com/osuvak/dev_in_place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */


#ifndef MY_CLASS_HH_
#define MY_CLASS_HH_

#include "mex.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// #include <stdbool.h>
#include <pthread.h>

#include <signal.h>
#include <unistd.h>
#include <ctype.h>

#include <iostream>
#include <string>

#include <list>

#include "handlers/basic_handler.hh" 
#include "callbacks/basic_handler_callbacks.hh"

#include "ngspice/sharedspice.h"

class MyClass
{
public:
  MyClass()
  {
//     std::cout << "MyClass constructor called." << std::endl;
    matlab_classInstData = NULL;
  }
  
  ~MyClass()
  {
//     std::cout << "MyClass destructor called." << std::endl;
  }
  
  void
  runNetlistInPath
  (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);
  
public:
  mxArray  *matlab_classInstData; /* stored matlab class instance data */
};

#endif
