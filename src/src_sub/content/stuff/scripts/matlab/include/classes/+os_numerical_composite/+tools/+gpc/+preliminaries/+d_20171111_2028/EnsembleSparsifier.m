classdef EnsembleSparsifier < hgsetget
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

    properties(GetAccess=public,SetAccess=public)
        
        myEnsemble
        myVal
        
        thres
    end
    
    properties(GetAccess=public,SetAccess=protected)
        
        sortedEnsemble
        cdf
        
        sortedEnsembleRaw
        
        samplesIndices
        
        N
        maxDist
        
        a
        b
    end
    
    methods(Access=public)
        
        function obj = EnsembleSparsifier()
%              if 1
%                  fprintf('Constructor called for EnsembleSparsifier.\n');
%              end
        end
        
        function computePreliminaries(obj)
            obj.N = length(obj.myEnsemble);
            
            obj.sortedEnsembleRaw = sort(obj.myEnsemble);
            obj.cdf = (1:obj.N) / obj.N;
            
            obj.a = min(obj.sortedEnsembleRaw) - obj.thres;
            obj.b = max(obj.sortedEnsembleRaw) + obj.thres - obj.a;
            
            fprintf('a : %.6e\n',obj.a);
            fprintf('b : %.6e\n',obj.b);
            
            obj.sortedEnsemble = ...
                ( obj.sortedEnsembleRaw - obj.a ) / obj.b ;
            
            choice = 2;
            
            switch lower(choice)
                case 1
                    d = ...
                        [ ...
                        obj.sortedEnsemble(2:end)-obj.sortedEnsemble(1:end-1) ; ...
                        obj.cdf(2:end)-obj.cdf(1:end-1) ...
                        ];
                    d = d.^2;
                    d = sqrt(d(1,:) + d(2,:));
            
                    obj.maxDist = sum(d) / obj.myVal;
                case 2
                    obj.maxDist = 1 / obj.myVal;
            end
            
            fprintf('Your choice of myVal yields approx. %.6e as maxDist.\n',obj.maxDist);
            
        end % function
    end
        
    methods(Access=public,Abstract)
        computeSamples(obj)
    end
end