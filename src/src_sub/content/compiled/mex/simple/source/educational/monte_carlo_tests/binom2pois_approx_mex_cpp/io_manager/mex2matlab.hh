/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#ifndef BINOM2POIS_MEX2MATLAB_HH_
#define BINOM2POIS_MEX2MATLAB_HH_

#include "mex.h"
#include "matrix.h"

#include "test_actual/results_container.hh"

#include <string>
#include <sstream>

void
argcheck_binom2pois_io_input_required
(
        int            nlhs ,
        mxArray      * plhs[] ,
        int            nrhs ,
  const mxArray      * prhs[] ,
  const std::stringstream         & ssMEXNAME ,
        double                    & lam ,
        std::vector<unsigned int> & n,
        unsigned int              & noMCTests
);

void
binom2pois_mex2matlab
(
        int            nlhs ,
        mxArray      * plhs[] ,
        int            nrhs ,
  const mxArray      * prhs[] ,
  const std::vector<Binom2PoisResultsContainer>
    & res
);

#endif