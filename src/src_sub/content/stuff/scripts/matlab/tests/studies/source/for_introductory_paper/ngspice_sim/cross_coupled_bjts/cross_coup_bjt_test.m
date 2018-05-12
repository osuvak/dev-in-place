classdef cross_coup_bjt_test < os_numerical_composite.testers.d_20170204_2252.GenericTesterWOpts
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
    
    properties(SetAccess=immutable,GetAccess=public)
    
        % flag for computation at nodes
        flag_computeAtNodes  = logical(1)

    end % properties
    
    methods(Access=public)
        function obj = cross_coup_bjt_test()
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
    
function [ indices , approxPeriodUpdated , flag_returned ] = ...
    extractApproximatePeriod( obj , t , x , signalIndex , afterTime , approxPeriod , noPeriods , tolX , tolY , flag_guessApproxPeriod )

methodName = 'extractApproximatePeriod';

% set values
indices = [];
approxPeriodUpdated = 0;
flag_returned = -99;

% check for inconsistencies
indTimeStart = find( t > afterTime );
if isempty(indTimeStart)
    error( '%s : afterTime parameter is too big.' , methodName );
end
indTimeStart = indTimeStart(1);

diffVal = abs( max(x(signalIndex,indTimeStart:end)) - min(x(signalIndex,indTimeStart:end)) );
avgVal  = ( max(x(signalIndex,indTimeStart:end)) + min(x(signalIndex,indTimeStart:end)) ) / 2;

indAboutAv = find( abs( x(signalIndex,indTimeStart:end) - avgVal ) <= tolY * diffVal );

if flag_guessApproxPeriod

    indDifferences       = diff( indAboutAv );
    indDiffBiggerThanOne = find( indDifferences > 1 );
    if numel( indDiffBiggerThanOne ) < 2
	warning( '%s : Ending time of simulation not long enough.' , methodName );
	flag_returned = -1;
	return;
    end
    
    indBegin = indAboutAv(1);
    indEnd   = indAboutAv(1) + sum( indDifferences( 1:indDiffBiggerThanOne(2) ) );

    approxPeriod = t( indTimeStart + indEnd - 1 ) - t( indTimeStart + indBegin - 1 );
end

if t(indTimeStart+indAboutAv(1)-1) + noPeriods * approxPeriod > t(end)
    warning( '%s : Ending time of simulation not long enough.' , methodName );
    flag_returned = -1;
    return;
end

% update indices
indTimeStart  = indTimeStart + indAboutAv(1) - 1;
indCandidates = find( abs( x(signalIndex,indTimeStart:end) - x(signalIndex,indTimeStart) ) <= tolY * diffVal );

% search
flag_found = logical(0);
for kk = 1:numel(indCandidates)
    indTimeEnd = indTimeStart + indCandidates(kk) - 1;
    if ( abs( abs( t(indTimeEnd) - t(indTimeStart) ) - approxPeriod ) <= tolX * approxPeriod )
        if sign( - ( x(signalIndex,indTimeStart) - x(signalIndex,indTimeEnd-1) ) * ( x(signalIndex,indTimeEnd) - x(signalIndex,indTimeStart) ) ) < 0
            flag_found = logical(1);
            break;
        end
    end
end % for

if ~flag_found
    warning( '%s : cannot find a candidate.' , methodName );
    flag_returned = -2;
    return;
end

flag_returned = 0;
indices = indTimeStart:indTimeEnd-1;
approxPeriodUpdated = ...
    t(indTimeEnd - 1) ...
    + abs( x(signalIndex,indTimeStart) - x(signalIndex,indTimeEnd-1) ) ...
    / abs( x(signalIndex,indTimeEnd)   - x(signalIndex,indTimeEnd-1) ) ...
    * ( t( indTimeEnd ) - t( indTimeEnd - 1 ) ) ...
    - t(indTimeStart);

return;

end % function
    
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
import os_numerical_composite.tools.sim_interfaces.ngspice.d_20171111_2138.*
import os_numerical_composite.utilities.fourier_transformers.d_20171111_1931.*

FontSize = 28;

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

if obj.flag_computeAtNodes

%  set parameters

vcont = linspace( 13.5 , 16.5 , 5 );
%  vcont = 10.0;

maxstep = 1e-6 * ones( size(vcont) );
ii_steps = find( vcont > 10.5 );
maxstep(ii_steps) = 1e-7 * ones( size(ii_steps) );

%  x_limits = [9e-3 10e-3];
x_limits = [9.5e-3 10e-3];

x_limits_init = [3.45e-3 4.55e-3];

%  simulate
pathMain = '.';
darray = [];

for kk = 1:numel(vcont)

  fid = fopen( fullfile( pathMain , '_ignore' , 'circuits' , 'part_vcont.cir' ) , 'w' );
  fprintf( fid , 'vcont nvcont gnd dc %8.4f' , vcont(kk) );
  fclose(fid);
  
  fid = fopen( fullfile( pathMain , '_ignore' , 'circuits' , 'part_tran.cir' ) , 'w' );
  fprintf( fid , '.tran %8.4e 10m' , maxstep(kk) );
  fclose(fid);
  
  ob = ngspice_so_matlab;
  ob.run_netlist( pathMain , '_ignore' , 'circuits' , 'cross_coupled_bjts_parts.cir' );
  darray(kk).obj = ngspice_data_container( ob.container );

  clear ob;

end

periods = zeros( size( vcont ) );
thd     = periods;

flag_computePeriod     = logical(1);
flag_doFourierAnalysis = logical(1);

for kk = 1:numel(darray)

    ob = darray(kk).obj;
    ngspice_data_container.plot_tran( ob.data.arrays.time , [ ob.data.arrays.nc1-ob.data.arrays.nc2 ] , 1 );
    %  clear ob;
    
    if flag_computePeriod

        myTime   = ob.data.arrays.time;
        mySignal = ob.data.arrays.nc1-ob.data.arrays.nc2;
    
        [myRange,period,flag_periodComp] = obj.extractApproximatePeriod( myTime , mySignal , 1 , 6e-3 , [] , 2 , 8e-2 , 8e-2 , logical(1) );
        if 0 ~= flag_periodComp
            error( 'Approximate period information could not be computed.' );
        end

        disp( ' ' );
        disp( 'Period (approximate)' );
        disp( period );
        disp( 'Period starts at :' )
        disp( myTime(myRange(1)) )
        disp( 'Period ends at :' )
        disp( myTime(myRange(end)) )
        disp( ' ' );
    end
    
    if flag_doFourierAnalysis

        tVal = myTime(myRange);
        xVal = mySignal(:,myRange);

        T = period;
        periods(kk) = period;
        N = numel(myRange);

        maxHarmonicIndex = 50;
        
        of = FourierSplineIntegrator( tVal , xVal , T , maxHarmonicIndex );
        of.compute();

        thd(kk) = ...
            sqrt ...
            ( ...
                ( sum( of.coefs(1).cos(3:end).^2 ) + sum( of.coefs(1).sin(3:end).^2 ) ) ...
                / ...
                ( sum( of.coefs(1).cos(2).^2 )     + sum( of.coefs(1).sin(2).^2 ) ) ...
            );

        tic
        noIndices  = 5;
        indexRangeRaw = 0:maxHarmonicIndex;
        indicesSelective = (1:noIndices-1) / noIndices * maxHarmonicIndex;
        indexRange = [ indexRangeRaw(1) indexRangeRaw(ceil(indicesSelective)) indexRangeRaw(end) ];
        of.plot( indexRange );
        toc

        of.plotHarmonics;

    end % if flag_doFourierAnalysis

end % for kk

disp( ' ' )
disp( 'Control Voltages, Periods and THDs' )
disp( [ vcont' periods' thd' ] )
disp( ' ' )

end % if obj.flag_computeAtNodes

end % function

    end % methods
    
end % classdef