classdef mlmodel_mex < handle

%{
/*
 * This file is part of the "dev-in-place" repository located at:
 * https://github.com/osuvak/dev-in-place
 * 
 * Copyright (C) 2018  Onder Suvak
 * 
 * For licensing information check the above url.
 * Please do not remove this header.
 * */
%}

    properties(Constant)
        const_m_C = eye(2)
    end

    methods
        function obj = mlmodel_mex()
        end
      
        function vf  = get_vf (obj,t,x)
            [vf,mfj,vq,mqj] = morris_lecar_model_cgu_mex_20180422_1626(t,x);
        end
        
        function mfj = get_mfj(obj,t,x)
            [vf,mfj,vq,mqj] = morris_lecar_model_cgu_mex_20180422_1626(t,x);
        end
    end % methods

end % classdef
