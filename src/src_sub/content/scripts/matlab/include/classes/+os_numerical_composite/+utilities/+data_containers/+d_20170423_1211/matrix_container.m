classdef matrix_container < handle
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

    properties( SetAccess=public , GetAccess=public )
        data = []
    end % properties
    
    methods(Access=public)
    
        function obj = matrix_container()
            data = [];
        end % function
        
        function delete(obj)
            data = [];
        end % function
        
    end % methods

end % classdef