/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */


#include "mex.h"

#include <vector>
#include <map>
#include <algorithm>
#include <memory>
#include <string>
#include <sstream>
#include <iostream>

#include "classes/my_class.hh"
typedef MyClass class_type;

void
mexFunction
(
        int      nlhs ,
        mxArray *plhs[] ,
        int      nrhs ,
  const mxArray *prhs[]
) 
{
  std::shared_ptr<class_type> ptr( new class_type );
  unsigned int cnt = 0;
  
  ptr->runNetlistInPath(nlhs, plhs, nrhs-cnt, &prhs[cnt]);
}