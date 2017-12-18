classdef EnsembleSparsifier_mex < os_numerical_composite.tools.gpc.preliminaries.d_20171111_2028.EnsembleSparsifier
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
        
        function obj = EnsembleSparsifier_mex()
%              if 1
%                  fprintf('Constructor called for EnsembleSparsifier_mex.\n');
%              end
        end
        
        function computeSamples(obj)
        
            esHandle = @EnsembleSparsifierHelper;
            
            obj.samplesIndices = ...
                esHandle ...
                    ( ...
                        obj.N , ...
                        obj.maxDist , ...
                        obj.sortedEnsemble , ...
                        obj.cdf ...
                    );
                    
        end % function
        
    end % methods
    
end % classdef
