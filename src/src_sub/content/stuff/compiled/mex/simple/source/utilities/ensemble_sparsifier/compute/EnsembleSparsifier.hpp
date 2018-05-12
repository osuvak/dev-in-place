/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#ifndef GPC_HIERARCHICAL_RULES_ENSEMBLE_SPARSIFIER_HPP_
#define GPC_HIERARCHICAL_RULES_ENSEMBLE_SPARSIFIER_HPP_

#include <cmath>
#include <vector>
#include <cstddef>

class EnsembleSparsifier
{
private:
  size_t  N_;
  double  maxDist_;
  double *ptr_sortedEnsemble_;
  double *ptr_cdf_;
  
  std::vector<size_t> samplesIndices_;
  
public:
  EnsembleSparsifier
    (
      size_t  N ,
      double  maxDist ,
      double *ptr_sortedEnsemble ,
      double *ptr_cdf
    ); 
  
  ~EnsembleSparsifier();
  
  const std::vector<size_t> &returnSamplesIndices() const;
  
  void computeSamples();
};

#endif