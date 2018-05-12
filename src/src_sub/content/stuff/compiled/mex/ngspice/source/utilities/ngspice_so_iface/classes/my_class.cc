/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */


#include "classes/my_class.hh" 

void
MyClass::runNetlistInPath
(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  if ( mxGetClassID(prhs[0]) != mxCHAR_CLASS )
    mexErrMsgTxt("runNetlistInPath needs a C-string input.");
  
  char        *c_str = mxArrayToString( prhs[0] );
  std::string  str(c_str);
  
  using namespace ngspice::mexInterface;
  
  int ret;
  char  * curplot;
  char  * vecname;
  char ** circarray;
  char ** vecarray;
  
  BasicNGSpiceHandler *mpt = new BasicNGSpiceHandler();
  
  ret = 
    ngSpice_Init
      ( 
        ng_getchar , 
        ng_getstat , 
        ng_exit ,  
        ng_data , 
        ng_initdata , 
        ng_thread_runs ,
        (void *) mpt
      );
      
  printf("Init thread returned: %d\n", ret);
  
  str = "source " + str;
  char c_str_nonconst[ strlen( str.c_str() ) + 1 ];
  strcpy( c_str_nonconst , str.c_str() );
  
  ret = ngSpice_Command( c_str_nonconst );
  
  ret = ngSpice_Command("bg_run");
  
  /* continue the main thread until bg thread is finished */
  for (;;) 
  {
    usleep ( mpt->waitPeriod() );
    if ( !( mpt->work_being_done() ) )
      break;
  }
  
  const char *field_names[] = { "str" , "values" };

  mwSize dims[2] = { 1 , mpt->totalNoVectors() };

  plhs[0]          = mxCreateStructArray(2, dims, 2, field_names);
  
  int field_str    = mxGetFieldNumber( plhs[0] , "str");
  int field_values = mxGetFieldNumber( plhs[0] , "values");
  
  mxArray *value;
  
  curplot = ngSpice_CurPlot();
  printf("\nCurrent plot is %s\n\n", curplot);

  vecarray = ngSpice_AllVecs(curplot);

  if (vecarray) {
    int k;
    for ( k=0 ; k < mpt->totalNoVectors() ; k++ )
    {
      pvector_info myvec;
      int veclength;
      vecname = vecarray[k];
      
      char plotvec[ strlen(curplot) + strlen(vecname) + 2 ];
            
      sprintf(plotvec, "%s.%s", curplot, vecname);
      myvec = ngGet_Vec_Info(plotvec);
      veclength = myvec->v_length;
      
      value = mxCreateString( vecname );
      mxSetFieldByNumber( plhs[0] , k , field_str    , value );
      value = mxCreateDoubleMatrix( 1, veclength, mxREAL);
      memcpy( (void *) mxGetPr(value) , (void *) myvec->v_realdata , veclength*sizeof(double) );
      mxSetFieldByNumber( plhs[0] , k , field_values , value );
      
//       printf("\nActual length of vector %s is %d\n\n", plotvec, veclength);
/*          
      int l;
      for ( l=0 ; l<10 ; l++ )
      {
        printf("%.6e ",myvec->v_realdata[l]);
      }
      printf("\n\n");
*/      
    }
  }

  std::cout << "There are " << mpt->totalNoVectors() << " vectors in total." << std::endl;
    
  ngSpice_Command("destroy all");
  
  delete mpt;
}