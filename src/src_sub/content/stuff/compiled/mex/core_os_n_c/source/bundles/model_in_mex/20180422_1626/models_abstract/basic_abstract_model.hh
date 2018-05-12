/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2018  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#pragma once

#include <itpp/itstat.h>

namespace os_numerical_composite
{
namespace models
{
namespace simulated_simple_models_sc
{
  
class BasicAbstractModel
{
protected:
  
  virtual
  void
  computeF
  (
          double     t ,
    const itpp::mat &x
  )
  = 0;
  
  virtual
  void
  computeQ
  (
    const itpp::mat &x
  )
  {
    q_cur_.clear();
  
    for ( unsigned int i=0 ; i<size_ ; i++ )
      q_cur_(i,0) = x(i,0);
  
    qJac_cur_.clear();
  
    for ( unsigned int i=0 ; i<size_ ; i++ )
      qJac_cur_(i,i) = 1.0;
  }
  
  virtual
  void
  computeQ_tDep
  (
          double     t ,
    const itpp::mat &x
  )
  {}
  
protected:
  
  // size of the system
  unsigned int size_;
  
  // flag for q t dep
  bool flag_is_q_time_dep_;
  
  // current internals
  itpp::mat f_cur_;
  itpp::mat fJac_cur_;
  itpp::mat q_cur_;
  itpp::mat qJac_cur_;
  
public:
  BasicAbstractModel 
  (
    unsigned int size               = 1 ,
    bool         flag_is_q_time_dep = false
  )
  :
  size_               (size) ,
  flag_is_q_time_dep_ (flag_is_q_time_dep)
  {
    f_cur_.set_size   (size_,1);
    fJac_cur_.set_size(size_,size_);
    q_cur_.set_size   (size_,1);
    qJac_cur_.set_size(size_,size_);
  }
  
  virtual
  ~BasicAbstractModel() {}
  
  // get size
  unsigned int
  getSize()
  const
  {
    return size_;
  }
  
  bool
  get_flag_is_q_time_dep
  ()
  const
  {
    return flag_is_q_time_dep_;
  }
  
  // choose between q dep q indep of t
  virtual
  void
  compute
  (
          double     t ,
    const itpp::mat &x
  )
  {
    computeF(t,x);
    
    if (flag_is_q_time_dep_)
      computeQ_tDep(t,x);
    else
      computeQ(x);
  }
  
//   virtual
  const itpp::mat &
  returnFuncF
  ()
  const
  {
    return f_cur_;
  }
  
//   virtual
  const itpp::mat &
  returnJacF
  ()
  const
  {
    return fJac_cur_;
  }
  
//   virtual
  const itpp::mat &
  returnFuncQ
  ()
  const
  {
    return q_cur_;
  }
  
//   virtual
  const itpp::mat &
  returnJacQ
  ()
  const
  {
    return qJac_cur_;
  }
};
 
} // simulated_simple_models_sc
} // models
} // os_numerical_composite
