/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */


#ifndef BASIC_HANDLER_HH_
#define BASIC_HANDLER_HH_

#include <iostream>
#include <string>
#include <list>

namespace ngspice
{
namespace mexInterface
{
  
class BasicNGSpiceHandler
{
protected:
  bool                    flag_report_on_stdout_;
  long int                waitPeriod_;

protected:
  int                     totalNoVectors_;
  std::list<std::string>  strCollector_;
  bool                    flag_work_being_done_;
  
public:
  BasicNGSpiceHandler
  (
    bool     flag_report_on_stdout = true ,
    long int waitPeriod            = 100000
  )
  :
  flag_report_on_stdout_(flag_report_on_stdout) ,
  waitPeriod_           (waitPeriod)
  {
    strCollector_.clear();
    
    if ( flag_report_on_stdout_ )
      std::cout << "Constructor called for BasicNGSpiceHandler." << std::endl;
  }
  
  ~BasicNGSpiceHandler()
  {
    if ( flag_report_on_stdout_ )
      std::cout << "Destructor called for BasicNGSpiceHandler." << std::endl;
    for 
      ( 
        std::list<std::string>::iterator it  = strCollector_.begin() ; 
                                         it != strCollector_.end() ; 
                                       ++it 
      )
    {
      (*it).clear();
    }
    strCollector_.clear();
  }
  
  int
  totalNoVectors(void)
  const
  {
    return totalNoVectors_;
  }
  
  void
  totalNoVectors(int n)
  {
    totalNoVectors_ = n;
  }
  
  bool 
  report_on_stdout
  ()
  const
  {
    return flag_report_on_stdout_;
  }
  
  bool
  work_being_done
  ()
  const
  {
    return flag_work_being_done_;
  }
  
  long int
  waitPeriod
  ()
  const
  {
    return waitPeriod_;
  }
  
  void
  work_being_done
  (bool flag_work_being_done)
  {
    flag_work_being_done_ = flag_work_being_done;
  }
  
  void
  appendToStrCollector
  (std::string s)
  {
    strCollector_.push_back(s);
//     std::cout << "Append method called with string : " << s << std::endl;
//     std::cout << "strCollector_ no of elements : " << strCollector_.size() << std::endl;
  }
  
  const std::list<std::string> &
  strCollector
  ()
  const
  {
    return strCollector_;
  }
};

} // mexInterface
} // ngspice


#endif