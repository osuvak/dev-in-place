/*
 * This file is part of the "dev_in_place" repository located at:
 * https://github.com/osuvak/dev_in_place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#ifndef BINOM2POIS_RESULTS_CONTAINER_HH_
#define BINOM2POIS_RESULTS_CONTAINER_HH_

#include <vector>

struct Binom2PoisResultsContainer
{
  Binom2PoisResultsContainer() {}
  ~Binom2PoisResultsContainer() {}
  
  double n;
  double p;
  
  std::vector<unsigned int> myRange;
  std::vector<double> pmfPoisson;
  std::vector<double> pmfBinomial;
};

#endif
