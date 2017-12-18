classdef GenericTester < os_numerical_composite.testers.d_20170204_2252.GenericTesterBase
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

    methods(Access=public)
        function obj = GenericTester(varargin)
        
            obj@os_numerical_composite.testers.d_20170204_2252.GenericTesterBase(varargin{:});
            
        end
    end
end
