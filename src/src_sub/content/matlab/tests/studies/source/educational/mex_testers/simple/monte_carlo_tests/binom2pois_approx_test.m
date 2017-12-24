classdef binom2pois_approx_test < os_numerical_composite.testers.d_20170204_2252.GenericTesterWOpts
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
        st
        lam
    end % properties

    methods(Access=public)
        function obj = binom2pois_approx_test()
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

lam = 10;

n = ceil( logspace( 1.3 , 2.3 , 11 ) );
p = lam ./ n;

noMCTests = 50000;

st = [];

flag_use_for = 0;

for kk = 1:numel(n)

    st(kk).n = n(kk);
    st(kk).p = p(kk);

    samples = zeros( 1 , noMCTests );
    
    if flag_use_for
    
        for ll = 1:noMCTests
            tmp = rand( n(kk) , 1 );
            ind_one  = find( tmp < p(kk) );
            ind_zero = setdiff( 1:numel(tmp) , ind_one );
        
            tmp( ind_one )  = 1;
            tmp( ind_zero ) = 0;
        
            samples(ll) = sum( tmp , 1 );
        end % for
        
    else
    
        tmp = rand( n(kk) , noMCTests );
        ind_one  = find( tmp < p(kk) );
        ind_zero = setdiff( 1:numel(tmp) , ind_one );
        
        tmp( ind_one )  = 1;
        tmp( ind_zero ) = 0;
        
        tmp = sum( tmp , 1 );
        samples = tmp;
        
    end
    
    st(kk).myRange = ( min(samples):max(samples) )';
    st(kk).pmfPoisson  = poisspdf( st(kk).myRange , lam );
    st(kk).pmfBinomial = zeros( size( st(kk).myRange ) );
    
    for ll = 1:numel(st(kk).myRange)
        st(kk).pmfBinomial(ll) = numel( find( samples == st(kk).myRange(ll) ) ) / noMCTests;
    end % for
    
end % for

obj.lam = lam;
obj.st  = st;

end % function
    
    end % methods
    
    methods(Access=public)
    
function run(obj,varargin)
obj.core()
end % function

function run_with_plots(obj,varargin)
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

if 0
    
    for kk = 1:numel(obj.st)
    
        figure;
        hBinom = plot( obj.st(kk).myRange , obj.st(kk).pmfBinomial , 'o' , 'MarkerSize' , 16 , 'LineWidth' , 4 , 'MarkerEdgeColor' , 'k' , 'MarkerFaceColor' , 'b' );
        hold off;
        hold on;
        hPoiss = plot( obj.st(kk).myRange , obj.st(kk).pmfPoisson  , 'd' , 'MarkerSize' , 16 , 'LineWidth' , 4 , 'MarkerEdgeColor' , 'k' , 'MarkerFaceColor' , 'r' );
        hold off;
        legend( [ hBinom hPoiss ] , 'Binomial pmf' , 'Poisson pmf' , 'Location' , 'NorthEast' , 'Orientation' , 'Vertical' );
        
        xlim( gca , [ min(obj.st(kk).myRange) max(obj.st(kk).myRange) ] );
        os_setAxes( obj , gca , FontSize );
    
        grid on;
        title( sprintf( 'lambda = %.2f n = %d p = %.3f' , obj.lam , obj.st(kk).n , obj.st(kk).p ) )
        
        if flag_quality_pub;
            os_setFigure( obj , gcf );
        end

    end % for
    
else
    
    noRows = 2;
    noCols = 3;
    totalPlots = noRows * noCols;
    
    for kk = 1:numel(obj.st)
    
        plotNo = rem( kk , totalPlots );
        if 0 == plotNo
            plotNo = totalPlots;
        end
        
        if 1 == plotNo
            figure;
        end
        
        subplot( noRows , noCols , plotNo )
        
        hBinom = plot( obj.st(kk).myRange , obj.st(kk).pmfBinomial , 'o' , 'MarkerSize' , 16 , 'LineWidth' , 4 , 'MarkerEdgeColor' , 'k' , 'MarkerFaceColor' , 'b' );
        hold off;
        hold on;
        hPoiss = plot( obj.st(kk).myRange , obj.st(kk).pmfPoisson  , 'd' , 'MarkerSize' , 16 , 'LineWidth' , 4 , 'MarkerEdgeColor' , 'k' , 'MarkerFaceColor' , 'r' );
        hold off;
        legend( [ hBinom hPoiss ] , 'Binomial pmf' , 'Poisson pmf' , 'Location' , 'South' , 'Orientation' , 'Horizontal' );
        
        ymax = max( [ max(obj.st(kk).pmfBinomial) max(obj.st(kk).pmfPoisson) ] );
        ymin = 0;
        
        ylimmax = ymax + abs( ymax - ymin ) * 0.20;
        ylimmin = ymin - abs( ymax - ymin ) * 0.25;
        
        ylim( gca , [ ylimmin ylimmax ] );
        xlim( gca , [ min(obj.st(kk).myRange) max(obj.st(kk).myRange) ] );
        os_setAxes( obj , gca , FontSize );
    
        grid on;
        title( sprintf( 'lambda = %.2f n = %d p = %.3f' , obj.lam , obj.st(kk).n , obj.st(kk).p ) )
        
        logicVal = ( plotNo == totalPlots ) || ( kk >= numel(obj.st) );
        
        if logicVal
            if flag_quality_pub;
                os_setFigure( obj , gcf );
            end
        end

    end % for
    
end % if

end % function

    end % methods
    
end % classdef