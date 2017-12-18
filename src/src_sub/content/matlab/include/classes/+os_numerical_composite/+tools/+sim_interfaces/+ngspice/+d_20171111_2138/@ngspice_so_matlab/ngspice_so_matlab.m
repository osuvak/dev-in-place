classdef ngspice_so_matlab < handle
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
        container  = []
    end
    
    methods
        
        function obj = ngspice_so_matlab(varargin)
        end
        
        function varargout = run_netlist(obj,varargin)
            import os_numerical_composite.tools.sim_interfaces.ngspice.d_20171111_2138.*
            
            filename = varargin{end};
            path = '';
            
            flag_in_other_dir = 0;
            if nargin > 1+1
                flag_in_other_dir = 1;
                path = fullfile(varargin{1:end-1});
            end
            
            here = pwd;
            
            if flag_in_other_dir
                chdir(path);
            end
            [varargout{1:nargout}] = ngspice_so_iface_20171111_2226( filename );
            if flag_in_other_dir
                chdir(here);
            end
            
            obj.container = [];
            obj.container = ngspice_data_container();
            obj.container.set_data( varargout );
        end % function

    end % methods
    
end
