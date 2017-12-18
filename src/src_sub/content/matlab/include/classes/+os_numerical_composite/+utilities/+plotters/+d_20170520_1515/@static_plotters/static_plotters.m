classdef static_plotters < handle
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

    methods(Static)
    
        [ xInfo , yInfo , zInfo , zAvInfo ] = ...
            compute_fill3_triangles( edgePtsL , edgePtsW , zValues )
        
    end % methods

    methods(Static)
    
        % these functions should be globally callable (now fixed)
        function os_setAxes( h_axes , FontSize , varargin )
            LineWidth = 4;
            if ( nargin >= 4 )
                LineWidth = varargin{1};
            end
            set( h_axes , 'units' , 'normalized' )
            set( h_axes , 'Box' ,'on' , 'FontName' , 'Arial' , ...
                'FontSize' , FontSize , 'FontWeight' , 'bold' , 'LineWidth' , LineWidth )
        end % function
        
        function os_setFigure( h_figure )
            set( h_figure , 'units' , 'normalized' , 'Position' , [0 0 1 1] );
            style = hgexport('factorystyle');
            style.Bounds = 'tight';
            hgexport( h_figure , '.tmpmatlab' , style , 'applystyle' , true );
        end % function
    
    end % methods
    
end % classdef
