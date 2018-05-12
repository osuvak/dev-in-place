/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#ifndef POIS_PMF_HH_
#define POIS_PMF_HH_

#include "test_actual/results_container.hh"

void
plugInPoissonPMFValues
(
  const double lam ,
        std::vector<Binom2PoisResultsContainer> 
          & res
);

#endif