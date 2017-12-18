/*
 * This file is part of the "dev_in_place" repository located at:
 * https://github.com/osuvak/dev_in_place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#include "EnsembleSparsifier.hpp" 

EnsembleSparsifier::EnsembleSparsifier
  (
    size_t  N ,
    double  maxDist ,
    double *ptr_sortedEnsemble ,
    double *ptr_cdf
  ) 
  : 
  N_                  ( N ) ,
  maxDist_            ( maxDist ) ,
  ptr_sortedEnsemble_ ( ptr_sortedEnsemble ) ,
  ptr_cdf_            ( ptr_cdf )
{
  samplesIndices_.clear();
}

EnsembleSparsifier::~EnsembleSparsifier()
{
  samplesIndices_.clear();
}

void EnsembleSparsifier::computeSamples()
{
  size_t i, kLast;
  double d, lastDist;
  bool flag_found;
  
  samplesIndices_.push_back(0);
  
  while (1)
  {
    kLast = samplesIndices_.back();
    
    if ( kLast == N_ - 1 )
    {
      break;
    }
    else if ( kLast + 1 == N_ - 1)
    {
      samplesIndices_.back() = N_ - 1;
      break;
    }
    
    flag_found = false;
    
    for ( i = kLast + 1 ; i < N_ ; i++ )
    {
      d = std::sqrt 
          ( 
            std::pow( ptr_sortedEnsemble_[i] - ptr_sortedEnsemble_[kLast] , 2 ) + 
            std::pow(            ptr_cdf_[i] -            ptr_cdf_[kLast] , 2 ) 
          );
          
      lastDist = d;
          
      if ( d > maxDist_ )
      {
        flag_found = true;
        samplesIndices_.push_back(i);
        break;
      }
    } // for
    
    if( !flag_found )
    {
      samplesIndices_.push_back(N_-1);
    }
  } // while
  
  if ( lastDist < maxDist_ / 4.0 )
  {
    samplesIndices_.erase( samplesIndices_.begin() + samplesIndices_.size() - 2 );
  }
}

const std::vector<size_t> &EnsembleSparsifier::returnSamplesIndices() const
{
  return samplesIndices_;
}