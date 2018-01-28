/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */


/*
 * This mex implementation is a translation utilizing the it++ library
 * from the Matlab version of the 2D FDTD simulation of a photonic crystal waveguide
 * published by CEM IIT Madras at:
 * 
 * https://www.mathworks.com/matlabcentral/fileexchange/35583-2d-fdtd-of-photonic-crystal-waveguide?s_tid=prof_contriblnk
 * */

#include "mex.h"
// #include "matrix.h"

#include <math.h> 

#include <itpp/itstat.h>
#include "common/mex_itpp_util.hh"

// mexFunction
void mexFunction
(
        int       nlhs,
        mxArray  *plhs[],
        int       nrhs,
  const mxArray  *prhs[]
)
{
  using namespace itpp;
  using namespace std;
  
  bool flag_pml = true;
  
  unsigned int factor=10;
  double S = 1.0 / sqrt(2);
  
  double epsilon0 = (1.0/(36.0*pi))*1.0e-9;
  double mu0 = 4.0 * pi * 1.0e-7;
  double c = 3.0e+8;

  double delta  = 0.15e-6/factor;
  double deltat = S * delta / c;

  unsigned int ydim=31*factor;
  unsigned int xdim=31*factor;

  double wav   = 1.55;
  double index = 3.4;

  double *ptr_in = mxGetPr(prhs[0]);
  unsigned int time_tot = (unsigned int) ptr_in[0];
  
  if ( nrhs >= 2 )
  {
    double *ptr_index = mxGetPr(prhs[1]);
    index = *ptr_index;
  }

  // computation
  mat epsilon = epsilon0 * ones(xdim,ydim);
  mat mu      = mu0 * ones(xdim,ydim);
  
  for ( int i=4 ; i<=28 ; i+=4 )
  {
    for ( int j=4 ; j<=28 ; j+=4 )
    {
      epsilon.set_submatrix
        ( 
          (i-1)*factor+1-1 , i*factor-1 , (j-1)*factor+1-1 , j*factor-1 , index*index*epsilon0 
        );
    }
  }

  epsilon.set_submatrix
    (
      0 , ydim-1 , 15*factor+1-1 , 16*factor-1 , epsilon0 
    );
  
  if ( flag_pml )
  {
    mat Ez  = zeros(xdim,ydim);
    mat Ezx = zeros(xdim,ydim);
    mat Ezy = zeros(xdim,ydim);
    mat Hy  = zeros(xdim,ydim);
    mat Hx  = zeros(xdim,ydim);
    
    mat sigmax = zeros(xdim,ydim);
    mat sigmay = zeros(xdim,ydim);
    
    unsigned int bound_width = factor * 3;
    
    unsigned int gradingorder = 6;
    
    double refl_coeff = 1.0e-6;
    
    double sigmamax = ( -log10(refl_coeff) * (gradingorder+1) * epsilon0 * c ) / ( 2 * bound_width * delta );
    double boundfact1 = ( ( epsilon( xdim/2 - 1 , bound_width - 1 ) / epsilon0 ) * sigmamax ) / ( pow( bound_width , gradingorder ) * ( gradingorder + 1 ) );
    double boundfact2 = ( ( epsilon( xdim/2 - 1 , ydim - bound_width - 1 ) / epsilon0 ) * sigmamax ) / ( pow( bound_width , gradingorder ) * ( gradingorder + 1 ) );
    double boundfact3 = ( ( epsilon( bound_width - 1 , ydim/2 - 1 ) / epsilon0 ) * sigmamax ) / ( pow( bound_width , gradingorder ) * ( gradingorder + 1 ) );
    double boundfact4 = ( ( epsilon( xdim - bound_width - 1 , ydim/2 - 1 ) / epsilon0 ) * sigmamax ) / ( pow( bound_width , gradingorder ) * ( gradingorder+1 ) );
    
    std::stringstream ss;
    ss << "0:1:" << bound_width;
//     cout << "ss string : " << ss.str() << endl;
    mat x = ss.str();
//     cout << x << endl;
//     cout << reverse(x) << endl;
    
    mat tmp;
    if (1) // get rid of extra memory
    {
      mat tmp1 = pow( (x+0.5*ones(1,bound_width+1)) , (gradingorder+1) );
      mat tmp2 = "0";
      tmp2 = pow( ( x - 0.5 * concat_horizontal( tmp2 , ones(1,bound_width) ) ) , (gradingorder+1) );
    
      tmp = tmp1 - tmp2;
    }
//     cout << tmp << endl;
    mat tmp_rev = reverse( tmp.get_row(0) );
    tmp_rev = tmp_rev.T();
//     cout << tmp_rev << endl;
    
    for ( int i=1 ; i<=xdim ; i++ )
    {
      sigmax.set_submatrix( i-1 , 1-1 , boundfact1 * tmp_rev );
      sigmax.set_submatrix( i-1 , ydim-bound_width-1 , boundfact2 * tmp );
    }
    
    for ( int i=1 ; i<=ydim ; i++ )
    {
      sigmay.set_submatrix( 1-1 , i-1 , boundfact3 * tmp_rev.T() );
      sigmay.set_submatrix( xdim-bound_width-1 , i-1 , boundfact4 * tmp.T() );
    }
    
    mat sigma_starx = elem_div( elem_mult( sigmax , mu ) , epsilon );
    mat sigma_stary = elem_div( elem_mult( sigmay , mu ) , epsilon );
    
    mat G = elem_div( (mu-0.5*deltat*sigma_starx) , (mu+0.5*deltat*sigma_starx) );
    mat H = (deltat/delta) / (mu+0.5*deltat*sigma_starx);
    mat A = elem_div( (mu-0.5*deltat*sigma_stary) , (mu+0.5*deltat*sigma_stary) );
    mat B = (deltat/delta) / (mu+0.5*deltat*sigma_stary);
    
    mat C = elem_div( (epsilon-0.5*deltat*sigmax) , (epsilon+0.5*deltat*sigmax) );
    mat D = (deltat/delta) / (epsilon+0.5*deltat*sigmax);
    mat E = elem_div( (epsilon-0.5*deltat*sigmay) , (epsilon+0.5*deltat*sigmay) );
    mat F = (deltat/delta) / (epsilon+0.5*deltat*sigmay);
    
//     cout << endl << "Preliminaries computed." << endl << endl;
    
//     tic();
    for ( int n=1 ; n<=time_tot ; n++ )
    {
//       cout << endl << "n = " << n << endl << endl;
      
      Hy.set_submatrix
        ( 
          1-1 , 1-1 ,
            elem_mult( A(1-1,xdim-1-1,1-1,ydim-1-1) , Hy(1-1,xdim-1-1,1-1,ydim-1-1) )
          + elem_mult
            (
              B(1-1,xdim-1-1,1-1,ydim-1-1) ,
              (
                Ezx(2-1,xdim-1,1-1,ydim-1-1)
              - Ezx(1-1,xdim-1-1,1-1,ydim-1-1) 
              + Ezy(2-1,xdim-1,1-1,ydim-1-1)
              - Ezy(1-1,xdim-1-1,1-1,ydim-1-1)
              )
            )
        );
              
      Hx.set_submatrix
        (
          1-1 , 1-1 ,
            elem_mult( G(1-1,xdim-1-1,1-1,ydim-1-1) , Hx(1-1,xdim-1-1,1-1,ydim-1-1) )
          - elem_mult
            (
              H(1-1,xdim-1-1,1-1,ydim-1-1) ,
              (
                  Ezx(1-1,xdim-1-1,2-1,ydim-1)
                - Ezx(1-1,xdim-1-1,1-1,ydim-1-1)
                + Ezy(1-1,xdim-1-1,2-1,ydim-1)
                - Ezy(1-1,xdim-1-1,1-1,ydim-1-1)
              )
            )
        );
        
      Ezx.set_submatrix
        (
          2-1 , 2-1 ,
            elem_mult( C(2-1,xdim-1,2-1,ydim-1) , Ezx(2-1,xdim-1,2-1,ydim-1) )
          + elem_mult
            (
              D(2-1,xdim-1,2-1,ydim-1) , 
              (
                -1 * Hx(2-1,xdim-1,2-1,ydim-1)
                + Hx(2-1,xdim-1,1-1,ydim-1-1)
              )
            )
        );
      
      Ezy.set_submatrix
        (
          2-1 , 2-1 ,
            elem_mult( E(2-1,xdim-1,2-1,ydim-1) , Ezy(2-1,xdim-1,2-1,ydim-1) )
          + elem_mult
            (
              F(2-1,xdim-1,2-1,ydim-1) ,
              ( 
                  Hy(2-1,xdim-1,2-1,ydim-1) 
                - Hy(1-1,xdim-1-1,2-1,ydim-1)
              )
            )
        );
      
//       cout << endl << "The four updates done." << endl << endl;
        
      double tstart = 1.0;
      double N_lambda = wav * 1.0e-6 / delta;
      
      Ezx.set_submatrix
        ( 
          bound_width+1-1 , bound_width+1-1 , 15*factor+1-1 , 16*factor-1 , 
          0.5*sin(((2*pi*(c/(delta*N_lambda))*(n-tstart)*deltat)))
        );
        
      Ezy.set_submatrix
        (
          bound_width+1-1 , bound_width+1-1 , 15*factor+1-1 , 16*factor-1 ,
          0.5*sin(((2*pi*(c/(delta*N_lambda))*(n-tstart)*deltat)))
        );
        
      
      Ez=Ezx+Ezy;
      
//       cout << endl << "Ez computed." << endl << endl;
    }
    
//     cout << endl << Ez << endl << endl;
    
//     toc_print();


    // mex returns
    int cnt = -1;
    
    double *ptr;
    unsigned int xdim_gen , ydim_gen;
    
    // Ez
    cnt++;
    plhs[cnt] = mxCreateDoubleMatrix ( xdim , ydim , mxREAL );
    ptr = mxGetPr(plhs[cnt]);
    xdim_gen = xdim;
    ydim_gen = ydim;
    if (0) // expire scope
    {
      double *outArray[xdim_gen];
      outArray[0] = ptr;
      for( size_t i = 1 ; i < xdim_gen ; i++ )
        outArray[i] = outArray[i-1] + ydim_gen;
  
      for( size_t i = 0 ; i < xdim_gen ; i++ )
      {
        for( size_t j = 0 ; j < ydim_gen ; j++ )
        {
          outArray[j][i] = Ez(i,j);
        }
      }
    }
    else
    {
      matrix_real_itpp_to_mex( ptr , Ez , xdim_gen , ydim_gen );
    }

    // xrange
    cnt++;
    xdim_gen = 1;
    ydim_gen = xdim;
    plhs[cnt] = mxCreateDoubleMatrix ( xdim_gen , ydim_gen , mxREAL );
    ptr = mxGetPr(plhs[cnt]);
    if (1) // expire scope
    {
      std::stringstream sstmp;
      sstmp << "1:1:" << ydim_gen;

      mat tmp_data = sstmp.str();
      tmp_data *= delta * 1.0e+6;
      
//       cout << endl << tmp_data << endl << endl;
      
      rowvec_real_itpp_to_mex( ptr , tmp_data , xdim_gen , ydim_gen );
    }

    
    // yrange
    cnt++;
    xdim_gen = 1;
    ydim_gen = ydim;
    plhs[cnt] = mxCreateDoubleMatrix ( xdim_gen , ydim_gen , mxREAL );
    ptr = mxGetPr(plhs[cnt]);
    if (1) // expire scope
    {
      std::stringstream sstmp;
      sstmp << "1:1:" << ydim_gen;

      mat tmp_data = sstmp.str();
      tmp_data *= delta * 1.0e+6;
      
      rowvec_real_itpp_to_mex( ptr , tmp_data , xdim_gen , ydim_gen );
    }

    
    // alpha
    cnt++;
    xdim_gen = epsilon.cols();
    ydim_gen = epsilon.rows();
    plhs[cnt] = mxCreateDoubleMatrix ( xdim_gen , ydim_gen , mxREAL );
    ptr = mxGetPr(plhs[cnt]);
    matrix_real_itpp_to_mex( ptr , 2 * epsilon.T() / epsilon0 , xdim_gen , ydim_gen );
    
if (0)
{    
}
    
  }
  else
  {
  }

}