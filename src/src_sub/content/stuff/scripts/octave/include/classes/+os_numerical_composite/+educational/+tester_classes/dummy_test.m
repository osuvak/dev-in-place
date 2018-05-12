classdef dummy_test < os_numerical_composite.testers.d_20170204_2252.GenericTesterWOpts
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
    end

    methods(Access=public)
        function obj = dummy_test()
%              import os_numerical_composite.testers.d_20170204_2252.*
            
            opts = os_numerical_composite.testers.d_20170204_2252.tester_options_set;

            opts.title = 'Dummy Test';
            opts.description = ...
                { ...
                };

%              opts.flag_in_realquick     = 0;
%              opts.flag_expected_to_fail = 0;
            opts.flag_plottable        = 1;
        
            obj@os_numerical_composite.testers.d_20170204_2252.GenericTesterWOpts( opts );
        end
        
        function delete(obj)
        end
    end
    
    methods(Access=private)
    
function core(obj)

%  rng('shuffle','twister');

disp( ' ' )
disp( 'THIS IS A DUMMY TEST!' )
disp( ' ' )

end
    
    end
    
    methods(Access=public)
    
function run(obj,varargin)
obj.core()
end

function run_with_plots(obj,varargin)
FontSize = 32;

flag_quality_pub = 0;
if ( nargin >= 2 ) && ( varargin{1} > 0 )
    flag_quality_pub = 1;
end

obj.core()

if flag_quality_pub
%      set( gcf , 'units' , 'normalized' , 'Position' , [0 0 1 1] );
%      style = hgexport('factorystyle');
%      style.Bounds = 'tight';
%      hgexport( gcf , '.tmpmatlab' , style , 'applystyle' , true );
end
end

    end
end
