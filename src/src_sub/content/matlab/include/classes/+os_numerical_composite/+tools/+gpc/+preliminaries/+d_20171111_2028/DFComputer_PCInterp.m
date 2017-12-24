classdef DFComputer_PCInterp < os_numerical_composite.tools.gpc.preliminaries.d_20171111_2028.ProbabilityDFComputerWAux
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
        yDotRaw
        yDot
        
        c
    end % properties
  
    methods(Access=private)
  
        function computeYDotRaw(obj)
    
            sz = size(obj.cdfSparse,2);
            obj.yDotRaw = zeros(1,sz);
      
            for k = 1:sz
                switch lower(k)
                    case 1
                        tmp = ...
                            obj.s(1) * ( 2 * obj.delx(1) + obj.delx(2) ) ...
                            - obj.s(2) * obj.delx(1);
                        tmp = ...
                            tmp / ( obj.ensemble(3) - obj.ensemble(1) );
            
                    case sz
                        tmp = ...
                            obj.s(sz-1) * ...
                            ( 2 * obj.delx(sz-1) + obj.delx(sz-2) ) ...
                            - obj.s(sz-2) * obj.delx(sz-1);
                        tmp = ...
                            tmp / ( obj.ensemble(sz) - obj.ensemble(sz-2) );
              
                    otherwise
                        tmp = ...
                            obj.s(k) * obj.delx(k-1) + obj.s(k-1) * obj.delx(k);
                        tmp = ...
                            tmp / ( obj.ensemble(k+1) - obj.ensemble(k-1) );
                end
        
                obj.yDotRaw(k) = tmp;
            end
      
        end % function
    
        function computeYDot(obj)
            sz = size(obj.cdfSparse,2);
            obj.yDot = zeros(1,sz);
      
            for k = 1:sz
                if k == 1
                    s_k_minus_1 = obj.s(k);
                else
                    s_k_minus_1 = obj.s(k-1);
                end
        
                if k == sz
                    s_k = obj.s(k-1);
                else
                    s_k = obj.s(k);
                end
        
                if s_k_minus_1 * s_k > 0
                    tmp = min( max( 0 , obj.yDotRaw(k) ) , 3 * min( s_k , s_k_minus_1 ) );
                else
                    tmp = 0;
                end
        
                obj.yDot(k) = tmp;
            end
        end % function
    
    
    end % methods
  
    methods(Access=public)
        
        function compute(obj)
            obj.computeYDotRaw();
            obj.computeYDot();
            
            sz = size(obj.cdfSparse,2);
            
            for k = 1:sz-1
                obj.c(k).set(1).val = obj.cdfSparse(k);
                
                if obj.cdfSparse(k) == obj.cdfSparse(k+1)
                    obj.c(k).set(2).val = 0;
                    obj.c(k).set(3).val = 0;
                    obj.c(k).set(4).val = 0;
                else
                    obj.c(k).set(2).val = ...
                        obj.yDot(k);
                    obj.c(k).set(3).val = ...
                        ( 3 * obj.s(k) - obj.yDot(k+1) - 2 * obj.yDot(k) ) ...
                        / ...
                        obj.delx(k);
                    obj.c(k).set(4).val = ...
                        - ( 2 * obj.s(k) - obj.yDot(k+1) - obj.yDot(k) ) ...
                        / ...
                        ( obj.delx(k) )^2;
                end
            end % for
            
        end % function
        
        function f = cdf(obj,xvec)
            f = zeros(1,numel(xvec));
            
            for k = 1:numel(xvec)
                x = xvec(k);
                
                if x < obj.ensemble(1)
                    m = 0;
                elseif x >= obj.ensemble(end)
                    m = 1;
                else
                    indices = ...
                        find( obj.ensemble <= x );
                    I = indices(end);
                
                    m = ...
                        polyval ...
                        ( ...
                        [ obj.c(I).set(4:-1:1).val ] ...
                        , ...
                        x - obj.ensemble(I) ...
                        );
                end
                
                f(k) = m;
            end
            
            return;
        end % function
        
        function f = pdf(obj,xvec)
            f = zeros(1,numel(xvec));
            
            for k = 1:numel(xvec)
                x = xvec(k);
                
                if x < obj.ensemble(1)
                    m = 0;
                elseif x >= obj.ensemble(end)
                    m = 0;
                else
                    indices = ...
                        find( obj.ensemble <= x );
                    I = indices(end);
                
                    m = ...
                        polyval ...
                        ( ...
                        polyder( [ obj.c(I).set(4:-1:1).val ] ) ...
                        , ...
                        x - obj.ensemble(I) ...
                        );
                end
                
                f(k) = m;
            end
            
            return;
        end % function
        
    end % methods

end % classdef