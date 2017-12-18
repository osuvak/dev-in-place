classdef ctfs_test < os_numerical_composite.testers.d_20170204_2252.GenericTesterWOpts
%{
/*
 * This file is part of the "dev_in_place" repository located at:
 * https://github.com/osuvak/dev_in_place
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
        function obj = ctfs_test()
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
%  rng('shuffle','twister')

end % function
    
    end % methods
    
    methods(Access=public)
    
function run(obj,varargin)
obj.core()
end % function

function run_with_plots(obj,varargin)
import os_numerical_composite.utilities.fourier_transformers.d_20171111_1931.*

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

noPeriods      = 1;
noPtsPerPeriod = 101;
f  = 10e3;
T  = 1 / f;
A  = 5;
ph = pi / 3;
offset = 1;

t  = linspace( 0 , T * noPeriods , noPeriods * noPtsPerPeriod + 1 );
x1 = A * sin( 2 * pi * f * t - ph ) + offset; 
x2 = cos( 2 * pi * f * t );
x3 = sin( 2 * pi * 1.25 * f * t );

tVal = t;
xVal = [ x1 ; x2 ; x3 ];

maxHarmonicIndex = 20;
        
of = FourierSplineIntegrator( tVal(1:end-1) , xVal(:,1:end-1) , noPeriods * T , maxHarmonicIndex );
of.compute();

noIndices  = 5;
indexRangeRaw = 0:maxHarmonicIndex;
indicesSelective = (1:noIndices-1) / noIndices * maxHarmonicIndex;
indexRange = [ indexRangeRaw(1) indexRangeRaw(ceil(indicesSelective)) indexRangeRaw(end) ];
of.plot( indexRange );
of.plotHarmonics;

end % function

    end % methods
    
end % classdef
