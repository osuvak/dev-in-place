classdef ProbabilityDFComputerWAux < os_numerical_composite.tools.gpc.preliminaries.d_20171111_2028.ProbabilityDFComputer
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

    properties(GetAccess=public,SetAccess=public)
        cdfSparse
        ensemble
    end % properties

    methods(Access=protected)
  
        function m = delx(obj,k)
            m = obj.ensemble(k+1) - obj.ensemble(k);
        end
    
        function m = s(obj,k)
            m = obj.cdfSparse(k+1) - obj.cdfSparse(k);
            m = m / obj.delx(k);
        end
    
    end % methods
  
end % classdef
