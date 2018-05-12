classdef ngspice_data_container < handle
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
        data  = []
    end
    
    methods
    
        function obj = ngspice_data_container( varargin )
            str_check_class = 'os_numerical_composite.tools.sim_interfaces.ngspice.d_20171111_2138.ngspice_data_container';
            if nargin <= 0
                return;
            else
                tmp = varargin{1};
                
                if isa( tmp , str_check_class )
                    obj.data = tmp.data;
                else
                    error( 'Arg 1 is not of type "%s".' , str_check_class );
                end
            end
        end % function
        
        function set_data(obj,celldata)
            obj.data = [];
            for kk=1:size(celldata,2)
                obj.data(kk).plots = celldata{kk};
                obj.data(kk).arrays = [];
                obj.data(kk).names  = [];
                for ll = 1:numel(obj.data(kk).plots)
                    tmp = obj.data(kk).plots(ll).str;
                    name_orig = tmp;
                    tmp = strrep( tmp , '.' , '_' );
                    tmp = strrep( tmp , '#' , '_' );
                    tmp = strrep( tmp , '(' , '_' );
                    tmp = strrep( tmp , ')' , '_' );
                    tmp = strrep( tmp , '-' , '_' );
                    disp( sprintf( '  Creating vector "%s".' , tmp ) );
                    eval( sprintf( 'obj.data(kk).arrays.%s = obj.data(kk).plots(ll).values;' , tmp ) );
                    eval( sprintf( 'obj.data(kk).names.%s  = name_orig;' , tmp ) );
                end
                
                obj.data(kk).plots = [];
            end
        end % function
        
    end % methods

    methods (Static)
        [ h_fig , h_plot , h_ca ] = plot_tran(vec_x,vec_y,flag_maximize)
    end % methods
end % classdef