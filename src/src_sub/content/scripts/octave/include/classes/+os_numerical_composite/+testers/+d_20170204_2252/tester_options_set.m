classdef tester_options_set < handle
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

    properties(SetAccess=public,GetAccess=public)
%      properties(Access=public)
        
        title       = '';
        description = '';
        
        flag_in_realquick     = 0;
        flag_expected_to_fail = 0;
        flag_plottable        = 0;
        
    end % properties
    
    methods(Access=public)
    
        function obj = tester_options_set(varargin)
        end % function
    
    end % methods
    
end % classdef
