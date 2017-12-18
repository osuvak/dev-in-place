/*
 * This file is part of the "dev_in_place" repository located at:
 * https://github.com/osuvak/dev_in_place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#ifndef BINOM2POIS_APPROX_HH_
#define BINOM2POIS_APPROX_HH_

#include <vector>

#include "results_container.hh"

void
binom2pois_approx
(
  const double                       lam ,
  const std::vector<unsigned int>  & n ,
  const unsigned int                 noMCTests ,
        std::vector<Binom2PoisResultsContainer> 
          & res
);

#endif
