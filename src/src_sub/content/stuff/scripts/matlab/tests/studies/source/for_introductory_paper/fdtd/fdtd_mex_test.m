classdef fdtd_mex_test < os_numerical_composite.testers.d_20170204_2252.GenericTesterWOpts

%{

/*
 * This is the Matlab driver test for the mex implementation utilizing the it++ library,
 * which is a translation from the Matlab version of the 2D FDTD simulation of a photonic 
 * crystal waveguide published by CEM IIT Madras at:
 * 
 * https://www.mathworks.com/matlabcentral/fileexchange/35583-2d-fdtd-of-photonic-crystal-waveguide?s_tid=prof_contriblnk
 * */

%}

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
    
        % common parameters for FDTD simulation
        noSteps = 500   % no of steps in a single FDTD simulation
        
        % flag for computation at nodes
        flag_computeAtNodes  = logical(1)
        
        % flags for computing and plotting the mean of Ez at the end of sim
        flag_plotMean        = logical(1)
        
    end % properties
    
    methods(Access=public)
        function obj = fdtd_mex_test()
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
import os_numerical_composite.utilities.data_containers.d_20170423_1211.*
import os_numerical_composite.utilities.plotters.d_20170520_1515.*

FontSize = 32;

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

    dataEz    = [];
    dataAlpha = []; % storing this, but will not be using it
    
    nodes = 3.4;
    
    tSimStart = tic;
    for kk = 1:numel(nodes)
        [ Ez , xRange , yRange , alpha_data ] = ...
            cem_iit_madras_p35_waveguide_mex_20171028_2133_plot( obj.noSteps , nodes(kk) );
        
        if kk <= 1
            dataEz    = Ez;
            dataAlpha = alpha_data;
        else
            dataEz(:,:,kk)    = Ez;
            dataAlpha(:,:,kk) = alpha_data;
        end
        
        clear Ez;
        clear alpha_data;
        
        disp( sprintf( 'Done with simulation %4d / %4d.' , kk , numel(nodes) ) );
        
    end % for kk
    tSimElapsed = toc( tSimStart );
    
end % obj.flag_computeAtNodes

if obj.flag_plotMean

    tSimStart = tic;
    figure;
    
    if 1
        edgePtsL = matrix_container();
        edgePtsW = matrix_container();
        zData    = matrix_container();
        
        edgePtsL.data = xRange';
        edgePtsW.data = yRange';
        meansMat      = dataEz(:,:,1);
        zData.data    = meansMat(:);
        
        [ xInfo , yInfo , zInfo , zAvInfo ] = ...
            static_plotters.compute_fill3_triangles( edgePtsL , edgePtsW , zData );
            
        ff = fill3( xInfo.data , yInfo.data , zInfo.data , zAvInfo.data );
        set( ff , 'edgecolor' , 'none' )
        
        hold on;
        
        zStep   = ( max( max( meansMat ) ) - min( min( meansMat ) ) ) / 20;
        zFactor = 1.5;
        zlimmax = ceil ( max( max( meansMat ) ) / zStep ) * zStep;
        zlimmin = floor( min( min( meansMat ) ) / zStep ) * zStep;
        
        zLocPlane     = zlimmin - ceil( ( zlimmax - zlimmin ) * zFactor / zStep ) * zStep;
        locBelowPlane = zLocPlane;
        
        ffplane = fill3( xInfo.data , yInfo.data , locBelowPlane + zeros( size(xInfo.data) ) , zAvInfo.data );
        set( ffplane , 'edgecolor' , 'none' )
        
        hold off;
        
        x_th = ( max(edgePtsL.data) - min(edgePtsL.data) ) / 100;
        xlim([edgePtsL.data(1)-x_th edgePtsL.data(end)+x_th])
        y_th = ( max(edgePtsW.data) - min(edgePtsW.data) ) / 100;
        ylim([edgePtsW.data(1)-y_th edgePtsW.data(end)+y_th])
        zlim( [ locBelowPlane zlimmax ] )
        view( -37.5 , 30 )
        os_setAxes( obj , gca , FontSize );
        grid on;
        
%          xlabel( 'x ({\mu}m)' )
%          ylabel( 'y ({\mu}m)' )
        xlabel( 'x (um)' )
        ylabel( 'y (um)' )
        title( sprintf( 'Mean of E_{z} (V/m)' ) )
        
    end % if
    
    os_setFigure( obj , gcf );
    
    tSimElapsed = toc( tSimStart );
    
    clear xRange;
    clear yRange;
    
    clear meansMat;

end % obj.flag_plotMean

end % function

    end % methods
    
end % classdef