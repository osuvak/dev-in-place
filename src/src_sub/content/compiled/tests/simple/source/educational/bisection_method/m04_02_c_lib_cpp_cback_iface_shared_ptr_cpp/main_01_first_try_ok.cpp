/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */

#include<stdio.h> 
#include<iostream>
#include<memory>
#include<map>
#include<string>
#include<vector>

#include "diode_circuit_impl.hh"
#include "bisection_options.h"
#include "bisection_internals.h"
#include "bisection_core.h"

#include "messages.hh"

int
main
(void)
{
  using namespace std;
  using namespace userdefn;
  
  using namespace my_cpp_utilities;
//   TalkToggler::unset_flag();
  
  // variables for the diode circuit
  double R   = 1e3;
  double IS  = 3e-15;
  double VIN = 3.3;
  double VT  = 25e-3;
  
  const unsigned int sz = 2;
  BisectionOptions  opt[sz];
  
  SolnIterates      soln;
  SolnLList        *cptr;
  
  int flag;
  unsigned int cnt;
  
  opt[0].fptr    = &DiodeCircuit::s_callback;
  opt[0].left    = 0.65;
  opt[0].right   = 0.9;
  opt[0].abstol  = 1.0e-30;
  opt[0].reltol  = 1.0e-3;
  opt[0].ftol    = 1.0e-5;
  opt[0].maxIter = 50;
  
  opt[1] = opt[0];
  
//   opt[0].userdata = 
//     static_cast<void *>( &( shared_ptr<DiodeCircuit>( dynamic_cast<DiodeCircuit *>( new DiodeCircuitWithExp( R , IS , VIN , VT ) ) ) ) );
//   opt[1].userdata = 
//     static_cast<void *>( &( shared_ptr<DiodeCircuit>( dynamic_cast<DiodeCircuit *>( new DiodeCircuitWithLog( R , IS , VIN , VT ) ) ) ) );

  vector < shared_ptr<DiodeCircuit> > vec;
  vec.emplace_back( dynamic_cast<DiodeCircuit *>( new DiodeCircuitWithExp( R , IS , VIN , VT ) ) );
  vec.emplace_back( dynamic_cast<DiodeCircuit *>( new DiodeCircuitWithLog( R , IS , VIN , VT ) ) );
  
//   opt[0].userdata = 
//     static_cast<void *>( &( ) );
//   opt[1].userdata = 
//     static_cast<void *>( &( ) );
    
  for ( unsigned int ii = 0 ; ii < sz ; ii++ )
  {
    opt[ii].userdata = 
      static_cast<void *>( &( vec[ii] ) );
  }
  
  map< string , BisectionOptions * > my_mapper;
  
  my_mapper[ "with_exp" ] = opt + 0;
  my_mapper[ "with_log" ] = opt + 1;
    
  BisectionOptions *opt_ptr = my_mapper[ "with_exp" ];
  
  // initialize soln
  initialize(&soln);
  
  // run
  flag = bisection_method( opt_ptr , &soln );
  printf("\nNo of iterations (length of soln array) : %d\n",size(&soln));
  
  if ( (flag == 0) || (flag == -2) )
  {
    if (size(&soln) > 0)
    {
      printf("\nValues and Function Values\n\n");
      cnt = 0;
      cptr = soln.llist;
      while ( cptr != NULL )
      {
        cnt++;
        printf
        ( "Iter %d : %.16e %.16e\n" , cnt , 
          cptr->point.val , cptr->point.fval
        );
        cptr = cptr->next;
      }
      
      printf("\nErrors in Values and Function Values\n\n");
      cnt = 0;
      cptr = soln.llist;
      while ( cptr != NULL )
      {
        cnt++;
        printf
        ( "Iter %d : %.16e %.16e\n" , cnt , 
          cptr->err_x , cptr->err_f
        );
        cptr = cptr->next;
      }
    }
  }
  
  // destroy soln
  destroy(&soln);
  
//   for ( unsigned int ii = 0 ; ii < sz ; ii++ )
//     delete static_cast<DiodeCircuit *>( opt[ii].userdata );
  
  return 0;
}