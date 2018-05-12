classdef pdf_approx_test < os_numerical_composite.testers.d_20170204_2252.GenericTesterWOpts
%{
/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2017  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */
%}

    properties(SetAccess=private,GetAccess=public)
    end % properties

    methods(Access=public)
        function obj = pdf_approx_test()
            import os_numerical_composite.testers.d_20170204_2252.*
        
            title       = '';
            description = ...
                { ...
                };
            
%              flag_in_realquick     = 0;
%              flag_expected_to_fail = 0;
            flag_plottable        = 1;
            
            otest = tester_options_set;
            
            otest.title       = title;
            otest.description = description;
%              otest.flag_in_realquick     = flag_in_realquick;
%              otest.flag_expected_to_fail = flag_expected_to_fail;
            otest.flag_plottable        = flag_plottable;
            
            obj@os_numerical_composite.testers.d_20170204_2252.GenericTesterWOpts ...
                ( ...
                    otest ...
                );
        end
        
        function delete(obj)
        end
    end % methods
    
    % axis and figure setters for pub quality plots.
    % Indeed these have to be static, but I do not want to deal with further imports
    % whenever I happen to relocate these tests themselves.
    methods( Access=private )
    
        function os_setAxes( obj , h_axes , FontSize , varargin )
            LineWidth = 4;
            if ( nargin >= 4 )
                LineWidth = varargin{1};
            end
            set( h_axes , 'units' , 'normalized' )
            set( h_axes , 'Box' ,'on' , 'FontName' , 'Arial' , ...
                'FontSize' , FontSize , 'FontWeight' , 'bold' , 'LineWidth' , LineWidth )
        end % function
        
        function os_setFigure( obj , h_figure )
            set( h_figure , 'units' , 'normalized' , 'Position' , [0 0 1 1] );
            style = hgexport('factorystyle');
            style.Bounds = 'tight';
            hgexport( h_figure , '.tmpmatlab' , style , 'applystyle' , true );
        end % function
    
    end % methods
    
    % indentation may not be utilized after this point for convenience.
    % Also avoiding static methods again since I do not want to deal with
    % unnecessary imports.
    
    methods(Access=private)
    
function core(obj)

format long e
rng('shuffle','twister')

end % function
    
    end % methods
    
    methods(Access=public)
    
function run(obj,varargin)
obj.core()
end % function

function run_with_plots(obj,varargin)
import os_numerical_composite.tools.gpc.preliminaries.d_20171111_2028.*

FontSize = 16;

flag_save = 0;

flag_quality_pub = 0;
if ( nargin >= 2 ) && ( varargin{1} > 0 )
    flag_quality_pub = 1;
end

obj.core()

% sort of a template for figures
%{
figure;

os_setAxes( obj , gca , FontSize );
    
grid on;
title('')

if flag_quality_pub;
    os_setFigure( obj , gcf );
end

if flag_save; print -djpeg90 FileName; end;
%}

N_MC = 200000;
myVal = 80;
thres = 1e-2;
    
x = zeros( N_MC , 4 );
x(:,1) = randn( N_MC , 1 );
x(:,2) = randn( N_MC , 1 );
x(:,3) = randn( N_MC , 1 );
x(:,4) = rand ( N_MC , 1 ) - 0.5;

y = x(:,1) + 0.1 * exp( 0.52 * x(:,2) ) + 0.3 * sqrt( 2.1 * abs( x(:,4) ) ) + sin( x(:,3) ) .* cos( 3.91 * x(:,4) );

ospa = EnsembleSparsifier_mex;
ospa.myEnsemble = y;
ospa.myVal = myVal;
ospa.thres = thres;

ospa.computePreliminaries;
ospa.computeSamples;

odf = DFComputer_PCInterp;
odf.ensemble  = ospa.sortedEnsemble( ospa.samplesIndices );
odf.cdfSparse = ospa.cdf( ospa.samplesIndices );
odf.compute;

th = 0.02;
myRange  = linspace( -th , 1+th , N_MC );
myRangeC = ospa.b * myRange + ospa.a;

pVal = [];
pVal.pdf = 1 / abs( ospa.b ) * odf.pdf( myRangeC );
pVal.cdf = odf.cdf( myRangeC );

figure;
subplot(2,1,1)
plot( myRangeC , pVal.cdf , 'LineWidth' , 2 , 'Color' , 'b' )
os_setAxes( obj , gca , FontSize );
grid on;
title( 'CDF vs. Ensemble' )

subplot(2,1,2)
plot( myRangeC , pVal.pdf , 'LineWidth' , 2 , 'Color' , 'r' )
os_setAxes( obj , gca , FontSize );
grid on;
title( 'PDF vs. Ensemble' )

os_setFigure( obj , gcf );

end % function

    end % methods
    
end % classdef