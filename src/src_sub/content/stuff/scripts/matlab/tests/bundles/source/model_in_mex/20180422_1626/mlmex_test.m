%{
/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2018  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */
%}

close all;
clear classes;
clear all;

format long e

om = mlmodel_mex;
maxStepTime = 1;
simTimeEnd  = 800;
y0 = [ -45 0 ];

opt = ...
    odeset ...
    (...
        'Mass' , om.const_m_C , ...
        'Jacobian' , @om.get_mfj , ...
        'BDF' , 'On' , ...
        'MaxStep' , maxStepTime ...
    );

tic;
[t,y] = ...
    ode15s ...
    ( ...
        @om.get_vf , ...
        [0 simTimeEnd] , y0 , opt ...
    );
toc;

figure;
plot( t , y , 'LineWidth' , 4 )
title( 'Outputs vs. time (sec)' )