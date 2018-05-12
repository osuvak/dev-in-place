classdef GenericTesterWOpts < os_numerical_composite.testers.d_20170204_2252.GenericTesterBase
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

    methods(Access=public)
    
        function obj = GenericTesterWOpts(varargin)
        
            cltype = 'os_numerical_composite.testers.d_20170204_2252.tester_options_set';

            if nargin < 1
                eval( sprintf( 'opts = %s();' , cltype ) );
            else
                if ~isa( varargin{1} , cltype )
                    error('The object is not derived from the required class.');
                end
                
                opts = varargin{1};
            end
        
            obj@os_numerical_composite.testers.d_20170204_2252.GenericTesterBase ...
                ( ...
                    opts.title , ...
                    opts.description , ...
                    opts.flag_in_realquick , ...
                    opts.flag_expected_to_fail , ...
                    opts.flag_plottable ...
                );
            
        end
        
    end

end
