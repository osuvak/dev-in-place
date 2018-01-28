classdef FourierSplineIntegrator < handle
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

    properties(SetAccess=immutable,GetAccess=public)
        t
        x
        T      % period
        M = 10 % ( 1 + 2 *M ) is the number of total harmonics
        
        N    % number of variables in x
        tpts % number of time points in a period
        
        method = 'linear' % interpolation method
%          method = 'spline' % interpolation method
    end % properties
    
    properties(SetAccess=private,GetAccess=public)
        f
        w
        
        t_int
        x_int
        
        pp
        
        w_val
        func
        
        coefs
        
        ttime
        b_cos
        b_sin
        ss
        
        x_t_vec     % stacked vector in time (of all variables) - using M (max)
        x_t_matrix  % matrix         in time (of all variables) - using M (max)
        x_f_vec     % stacked vector in freq (of all variables) - using M (max)
        x_f_matrix  % matrix         in freq (of all variables) - using M (max)
        
        myUniformTimeRange % used to plot x_t_matrix
    end % properties
    
    properties(SetAccess=public,GetAccess=public)
        FontSize = 16
    end % properties
    
    methods(Access=public)
    
        function obj = FourierSplineIntegrator(varargin)
            if nargin >= 1
                t = varargin{1};
                if length(t) == numel(t)
                    obj.t = t;
                    obj.tpts = length(t) + 1;
                else
                    error('t is not a vector.')
                end
            end
            if nargin >= 2
                x = varargin{2};
                if obj.tpts - 1 == size(x,2)
                    obj.x = x;
                    obj.N = size(x,1);
                else
                    error('x is not of compatible dimension.')
                end
            end
            if nargin >= 3
                T = varargin{3};
                if T > t(end)-t(1)
                    obj.T = T;
                else
                    error('T is not long enough.')
                end
            end
            if nargin >= 4
                M = varargin{4};
                obj.M = M;
            end
            if nargin >= 5
                obj.method = varargin{5};
                switch lower( obj.method )
                    case 'linear'
                    case 'spline'
                    otherwise
                        error( 'Interpolation method ''%s'' is not supported.' , obj.method );
                end % switch
            end
            
%              disp(sprintf('Instance created of type %s',class(obj)))
        end
        
        function delete(obj)
%              disp(sprintf('Instance destroyed of type %s',class(obj)))
        end
        
        function compute(obj)
            import os_numerical_composite.utilities.fourier_transformers.d_20171111_1931.*
        
            obj.f = 1 / obj.T;
            obj.w = 2 * pi * obj.f;
            obj.t_int = [ obj.t obj.t(1)+obj.T ];
            obj.x_int = [ obj.x obj.x(:,1) ];
            
            switch lower(obj.method)
                case 'linear'
                    obj.pp  = interp1( obj.t_int , obj.x_int' , 'linear' , 'pp' );
                    myOrder = 1;
                    
                case 'spline'
                    obj.pp  = spline( obj.t_int , obj.x_int );
                    myOrder = 3;
            end % switch
            poly_cos  = @(tt , w) poly_cos_max_order_3 ( obj , tt , w , myOrder );
            poly_sin  = @(tt , w) poly_sin_max_order_3 ( obj , tt , w , myOrder );
            poly_func = @(tt , w) poly_func_max_order_3( obj , tt , w , myOrder );
            tr_matrix = @(a)      tr_matrix_max_order_3( obj , a  , myOrder );
            
            for kk = 1:obj.M
                w_tmp = obj.w * kk;
                
%                  obj.w_val(kk).cos = poly_cos( obj , obj.t_int , w_tmp );
%                  obj.w_val(kk).sin = poly_sin( obj , obj.t_int , w_tmp );
                
                obj.w_val(kk).cos = poly_cos( obj.t_int , w_tmp );
                obj.w_val(kk).sin = poly_sin( obj.t_int , w_tmp );
                
                obj.w_val(kk).cos_diff = diff( obj.w_val(kk).cos , 1 , 2 );
                obj.w_val(kk).sin_diff = diff( obj.w_val(kk).sin , 1 , 2 );
                
                obj.w_val(kk).cos_diff_tr = zeros(size(obj.w_val(kk).cos_diff));
                obj.w_val(kk).sin_diff_tr = zeros(size(obj.w_val(kk).sin_diff));
                
                for ll = 1:length(obj.t_int)-1
%                      tmp = tr_matrix( obj , obj.t_int(ll) );
                    tmp = tr_matrix( obj.t_int(ll) );
                    obj.w_val(kk).cos_diff_tr(:,ll) = tmp * obj.w_val(kk).cos_diff(:,ll);
                    obj.w_val(kk).sin_diff_tr(:,ll) = tmp * obj.w_val(kk).sin_diff(:,ll);
                end
                
                for ll = 1:obj.N
                    obj.w_val(kk).var(ll).cos_coef = ...
                        2.0 / obj.T * sum( sum( obj.pp.coefs(ll:obj.N:(length(obj.t_int)-1-1)*obj.N+ll,:)' .* obj.w_val(kk).cos_diff_tr , 1 ) , 2 );
                    obj.w_val(kk).var(ll).sin_coef = ...
                        2.0 / obj.T * sum( sum( obj.pp.coefs(ll:obj.N:(length(obj.t_int)-1-1)*obj.N+ll,:)' .* obj.w_val(kk).sin_diff_tr , 1 ) , 2 );
                end
            end
            
%              obj.func.val         = poly_func( obj , obj.t_int , 0.0 );
            obj.func.val         = poly_func( obj.t_int , 0.0 );
            obj.func.val_diff    = diff( obj.func.val , 1 , 2 );
            obj.func.val_diff_tr = zeros(size(obj.func.val_diff));
            
            for ll = 1:length(obj.t_int)-1
%                  tmp = tr_matrix( obj , obj.t_int(ll) );
                tmp = tr_matrix( obj.t_int(ll) );
                obj.func.val_diff_tr(:,ll) = tmp * obj.func.val_diff(:,ll);
            end
            
            for ll = 1:obj.N
                obj.func.var(ll).coef = ...
                    1.0 / obj.T * sum( sum( obj.pp.coefs(ll:obj.N:(length(obj.t_int)-1-1)*obj.N+ll,:)' .* obj.func.val_diff_tr , 1 ) , 2 );
            end
            
            for ll = 1:obj.N
                obj.coefs(ll).cos = [obj.func.var(ll).coef];
                obj.coefs(ll).sin = [0];
                for kk = 1:obj.M
                    obj.coefs(ll).cos = [ obj.coefs(ll).cos ; obj.w_val(kk).var(ll).cos_coef ];
                    obj.coefs(ll).sin = [ obj.coefs(ll).sin ; obj.w_val(kk).var(ll).sin_coef ];
                end
            end
            
            % now compute stacked vector and matrix in time and freq
            obj.x_f_vec = zeros( obj.N * ( 1 + 2 * obj.M ) , 1 );
            ofour = fftTransformer;
            for ll = 1:obj.N
                % DC
                obj.x_f_vec( obj.N * obj.M + ll , 1 ) = obj.coefs(ll).cos(1);
                % positive indices
                obj.x_f_vec( obj.N*(1+obj.M)+ll:obj.N:obj.N*(2*obj.M)+ll , 1 ) = ...
                    0.5 * obj.coefs(ll).cos(2:end) - 1j * 0.5 * obj.coefs(ll).sin(2:end);
                % negative indices (complex conjugates)
                obj.x_f_vec( obj.N*(-1+obj.M)+ll:-obj.N:ll , 1 ) = ...
                    ( ( obj.x_f_vec( obj.N*(1+obj.M)+ll:obj.N:obj.N*(2*obj.M)+ll , 1 ) )' ).';
            end % for
            
            obj.x_f_vec = ofour.blockTimeShifter( obj.x_f_vec , obj.N , 1 + 2 * obj.M , obj.f , obj.t(1) );
            obj.x_f_matrix = reshape( obj.x_f_vec , obj.N , 1 + 2 * obj.M );
            obj.x_t_vec = ofour.blockFFTInv( obj.x_f_vec , obj.N , 1 + 2 * obj.M );
            obj.x_t_vec = real( obj.x_t_vec );
            obj.x_t_matrix = reshape( obj.x_t_vec , obj.N , 1 + 2 * obj.M );
            
            obj.myUniformTimeRange = ...
                linspace( obj.t(1) , obj.t(1) + obj.T , (1 + 2 * obj.M) + 1 );
            obj.myUniformTimeRange = obj.myUniformTimeRange( 1:end-1 );
        end % function
        
        function plot(obj,varargin)
            import os_numerical_composite.utilities.plotters.d_20170520_1515.*
        
            MM = obj.M;
            
%              v_st = 0;

            % indices for the case of no input
            noIndices  = 5;
            indexRangeRaw = 0:MM;
            indicesSelective = (1:noIndices-1) / noIndices * MM;
            v_st = [ indexRangeRaw(1) indexRangeRaw(ceil(indicesSelective)) indexRangeRaw(end) ];
            clear noIndices;
            clear indexRangeRaw;
            clear indicesSelective;
            
            % if we are provided with indices, use them
            if nargin >= 2
                v_st = varargin{1};
            end
            v_st = v_st + 1;

            indGtThanMax = find( v_st > MM + 1 );
            if ~isempty( indGtThanMax )
                error( 'There are harmonic indices out of range.' );
            end
            
            tt = linspace( obj.t(1) , obj.t(1) + obj.T , ceil( MM*1000 ) );
            b_cos = zeros( MM+1 , length(tt) );
            b_sin = zeros( size( b_cos ) );
            
            b_cos(1,:) = ones( 1 , length(tt) );
            for kk = 1:MM
                b_cos(kk+1,:) = cos( kk * obj.w * tt );
                b_sin(kk+1,:) = sin( kk * obj.w * tt );
            end
            
            for kk = 1:obj.N
                ss(kk).val = ...
                    diag( obj.coefs(kk).cos(1:MM+1) ) * b_cos ...
                    + ...
                    diag( obj.coefs(kk).sin(1:MM+1) ) * b_sin;
            end
            
            obj.ttime = tt;
            obj.b_cos = b_cos;
            obj.b_sin = b_sin;
            obj.ss    = ss;
            
            reltol = 1e-12;
            abstol = 1e-16;
            
%              sz_rows = ceil( (MM+1-v_st+1) / 2 );
            sz_rows = ceil( numel(v_st) / 2 );
            for nn = 1:obj.N
                figure;
                cnt_subplot = 0;
                
%                  for ll = v_st:MM+1
                for ll = v_st
                    cnt_subplot = cnt_subplot + 1;
                    
%                      subplot(sz_rows,2,(ll-v_st+1))
                    subplot( sz_rows , 2 , cnt_subplot )
                    
                    sig_app = sum( ss(nn).val(1:ll,:) , 1 );
                    sig_exa = obj.x_int(nn,1:end-1);
                    
                    s_max = max( [ max(sig_app) , max(sig_exa) ] );
                    s_min = min( [ min(sig_app) , min(sig_exa) ] );
                    
                    plotLVal = ( norm( s_max - s_min ) < reltol * norm( s_max ) + abstol );
                    
                    if plotLVal
                        y_max = s_max + reltol * norm(s_max) + abstol;
                        y_min = s_min - reltol * norm(s_min) - abstol;
                    else
                        y_max = s_max + 0.1 * (s_max-s_min);
                        y_min = s_min - 0.1 * (s_max-s_min);
                    end % if
                    
                    plot( tt , sig_app , 'b' , 'LineWidth' , 3 )
                    hold on;
                    plot( obj.t_int(1:end-1) , sig_exa , 'r' , 'LineWidth' , 3 )
                    hold off;
                    axis([tt(1) tt(end) y_min y_max])
                    
                    static_plotters.os_setAxes( gca , obj.FontSize );
                    
                    grid on
                    title(sprintf('max. coef. index = %d (Signal %d)',ll-1,nn))
                end
                
                static_plotters.os_setFigure( gcf );
            end
        end % function
        
        function plotComparative(obj,varargin)
            import os_numerical_composite.utilities.plotters.d_20170520_1515.*
            
            signalNo = 1;
        
            no_args = 1;
            
            no_args = no_args + 1;
            if nargin >= no_args
                signalNo = varargin{no_args-1};
                if signalNo > obj.N
                    error( sprintf( 'Requested signalNo (%d) > Total No of Variables (%d).' , signalNo , obj.N ) )
                end
            end
            
            figure;
            plot( obj.myUniformTimeRange , obj.x_t_matrix(signalNo,:) , obj.t_int , obj.x_int(signalNo,:) , 'LineWidth' , 4 )
            
            xlim( gca , [ obj.t_int(1) obj.t_int(end) ] );
            static_plotters.os_setAxes( gca , obj.FontSize );
            
            grid on
            title( sprintf( 'Signal %d (comparative) vs time (sec) - Fourier Generated and Original' , signalNo ) )
            
            static_plotters.os_setFigure( gcf );
        end % function
        
        function plotHarmonics(obj)
            import os_numerical_composite.utilities.plotters.d_20170520_1515.*
            
            for nn = 1:obj.N
                figure;
                
                subplot(3,2,1)
                stem( 0:obj.M , obj.coefs(nn).cos , 'filled' , 'LineWidth' , 3 , 'MarkerSize' , 12 , 'MarkerFaceColor' , 'r' )
                
                xlim( gca , [ 0 obj.M ] )
                static_plotters.os_setAxes( gca , obj.FontSize );
                    
                grid on
                title( sprintf( 'cos coefs vs index (Signal %d)' , nn ) )
                
                subplot(3,2,2)
                stem( 0:obj.M , obj.coefs(nn).sin , 'filled' , 'LineWidth' , 3 , 'MarkerSize' , 12 , 'MarkerFaceColor' , 'r' )
                
                xlim( gca , [ 0 obj.M ] )
                static_plotters.os_setAxes( gca , obj.FontSize );
                    
                grid on
                title( sprintf( 'sin coefs vs index (Signal %d)' , nn ) )
                
                subplot(3,2,3)
                stem( -obj.M:obj.M , real( obj.x_f_matrix(nn,:) ) , 'filled' , 'LineWidth' , 3 , 'MarkerSize' , 12 , 'MarkerFaceColor' , 'r' )
                
                xlim( gca , [ -obj.M obj.M ] )
                static_plotters.os_setAxes( gca , obj.FontSize );
                    
                grid on
                title( sprintf( 'real parts of coefs vs index (Signal %d)' , nn ) )
                
                subplot(3,2,4)
                stem( -obj.M:obj.M , imag( obj.x_f_matrix(nn,:) ) , 'filled' , 'LineWidth' , 3 , 'MarkerSize' , 12 , 'MarkerFaceColor' , 'r' )
                
                xlim( gca , [ -obj.M obj.M ] )
                static_plotters.os_setAxes( gca , obj.FontSize );
                    
                grid on
                title( sprintf( 'imag parts of coefs vs index (Signal %d)' , nn ) )
                
                subplot(3,2,5)
                stem( -obj.M:obj.M , abs( obj.x_f_matrix(nn,:) ) , 'filled' , 'LineWidth' , 3 , 'MarkerSize' , 12 , 'MarkerFaceColor' , 'r' )
                
                xlim( gca , [ -obj.M obj.M ] )
                static_plotters.os_setAxes( gca , obj.FontSize );
                    
                grid on
                title( sprintf( 'magnitudes of coefs vs index (Signal %d)' , nn ) )
                
                subplot(3,2,6)
                stem( -obj.M:obj.M , 180 / pi * atan2( imag( obj.x_f_matrix(nn,:) ) , real( obj.x_f_matrix(nn,:) ) ) , 'filled' , 'LineWidth' , 3 , 'MarkerSize' , 12 , 'MarkerFaceColor' , 'r' )
                
                xlim( gca , [ -obj.M obj.M ] )
                static_plotters.os_setAxes( gca , obj.FontSize );
                    
                grid on
                title( sprintf( 'phases of coefs vs index (Signal %d)' , nn ) )
                
                static_plotters.os_setFigure( gcf );
            
            end %for
            
        end % function
        
        function runPhaseShiftingMovie(obj,varargin)
            import os_numerical_composite.utilities.plotters.d_20170520_1515.*
            import os_numerical_composite.utilities.fourier_transformers.d_20171111_1931.*
            
            ptsPerPeriod = 50;
            waitPause    = 0.2;
        
            no_args = 1;
            
            no_args = no_args + 1;
            if nargin >= no_args
                ptsPerPeriod = varargin{no_args-1};
            end
            
            no_args = no_args + 1;
            if nargin >= no_args
                waitPause = varargin{no_args-1};
            end
            
            myRangePhases = linspace( 0 , obj.T , ptsPerPeriod );
            ofour = fftTransformer;
            
            figure;
            for ll = 1:numel(myRangePhases)
                x_f_vec_temp = ofour.blockTimeShifter( obj.x_f_vec , obj.N , 1 + 2 * obj.M , obj.f , myRangePhases(ll) );
                x_t_vec_temp = real( ofour.blockFFTInv( x_f_vec_temp , obj.N , 1 + 2 * obj.M ) );
                
                plot( obj.myUniformTimeRange , reshape( x_t_vec_temp , obj.N , 1 + 2 * obj.M ) , 'LineWidth' , 4 )
                
                xlim( gca , [ obj.myUniformTimeRange(1) obj.myUniformTimeRange(end) ] )
                static_plotters.os_setAxes( gca , obj.FontSize );
                
                grid on
                title( sprintf( 'Step %d/%d - (%.2e sec) Shifted Fourier Generated Signal vs time (sec)' , ll , numel(myRangePhases) , myRangePhases(ll) ) )
                
                static_plotters.os_setFigure( gcf );
            
                pause(waitPause);
                drawnow;
                pause(waitPause);
            end % for
            
        end % function
        
        function runPhaseShiftingMovieForSingleEntry(obj,varargin)
            import os_numerical_composite.utilities.plotters.d_20170520_1515.*
            import os_numerical_composite.utilities.fourier_transformers.d_20171111_1931.*
            
            signalNo     = 1;
            ptsPerPeriod = 50;
            waitPause    = 0.2;
        
            no_args = 1;
            
            no_args = no_args + 1;
            if nargin >= no_args
                signalNo = varargin{no_args-1};
                if signalNo > obj.N
                    error( sprintf( 'Requested signalNo (%d) > Total No of Variables (%d).' , signalNo , obj.N ) )
                end
            end
            
            no_args = no_args + 1;
            if nargin >= no_args
                ptsPerPeriod = varargin{no_args-1};
            end
            
            no_args = no_args + 1;
            if nargin >= no_args
                waitPause = varargin{no_args-1};
            end
            
            myRangePhases = linspace( 0 , obj.T , ptsPerPeriod );
            ofour = fftTransformer;
            
            figure;
            for ll = 1:numel(myRangePhases)
                x_f_vec_temp = ofour.blockTimeShifter( obj.x_f_vec , obj.N , 1 + 2 * obj.M , obj.f , myRangePhases(ll) );
                x_t_vec_temp = real( ofour.blockFFTInv( x_f_vec_temp , obj.N , 1 + 2 * obj.M ) );
                
                % 1
                subplot(3,2,1)
                plot( obj.myUniformTimeRange , reshape( x_t_vec_temp , obj.N , 1 + 2 * obj.M ) , 'LineWidth' , 4 )
                
                xlim( gca , [ obj.myUniformTimeRange(1) obj.myUniformTimeRange(end) ] )
                static_plotters.os_setAxes( gca , obj.FontSize );
                
                grid on
                title( sprintf( 'Step %d/%d - (%.2e sec) Shifted Signal %d vs time (sec)' , ll , numel(myRangePhases) , myRangePhases(ll) , signalNo ) )
                
                % 2
                subplot(3,2,2)
                plot( obj.myUniformTimeRange , reshape( x_t_vec_temp , obj.N , 1 + 2 * obj.M ) , 'LineWidth' , 4 )
                
                xlim( gca , [ obj.myUniformTimeRange(1) obj.myUniformTimeRange(end) ] )
                static_plotters.os_setAxes( gca , obj.FontSize );
                
                grid on
                title( sprintf( 'Step %d/%d - (%.2e sec) Shifted Signal %d vs time (sec)' , ll , numel(myRangePhases) , myRangePhases(ll) , signalNo ) )
                
                % prepare signal harmonics
                x_f = x_f_vec_temp( signalNo:obj.N:(2*obj.M)*obj.N+signalNo );
                
                % 3 - real parts
                subplot(3,2,3)
                stem( -obj.M:obj.M , real( x_f ) , 'filled' , 'LineWidth' , 3 , 'MarkerSize' , 12 , 'MarkerFaceColor' , 'r' )
                
                xlim( gca , [ -obj.M obj.M ] )
                static_plotters.os_setAxes( gca , obj.FontSize );
                    
                grid on
                title( 'real parts of coefs vs index' )
                
                % 5 - imag parts
                subplot(3,2,5)
                stem( -obj.M:obj.M , imag( x_f ) , 'filled' , 'LineWidth' , 3 , 'MarkerSize' , 12 , 'MarkerFaceColor' , 'r' )
                
                xlim( gca , [ -obj.M obj.M ] )
                static_plotters.os_setAxes( gca , obj.FontSize );
                    
                grid on
                title( 'imag parts of coefs vs index' )
                
                % 4 - magnitudes
                subplot(3,2,4)
                stem( -obj.M:obj.M , abs( x_f ) , 'filled' , 'LineWidth' , 3 , 'MarkerSize' , 12 , 'MarkerFaceColor' , 'r' )
                
                xlim( gca , [ -obj.M obj.M ] )
                static_plotters.os_setAxes( gca , obj.FontSize );
                    
                grid on
                title( 'magnitudes of coefs vs index' )
                
                % 6 - phases
                subplot(3,2,6)
                stem( -obj.M:obj.M , 180 / pi * atan2( imag( x_f ) , real( x_f ) ) , 'filled' , 'LineWidth' , 3 , 'MarkerSize' , 12 , 'MarkerFaceColor' , 'r' )
                
                xlim( gca , [ -obj.M obj.M ] )
                static_plotters.os_setAxes( gca , obj.FontSize );
                    
                grid on
                title( 'phases of coefs vs index' )
                
                % arrange figure
                static_plotters.os_setFigure( gcf );
            
                % pause and draw
                pause(waitPause);
                drawnow;
                pause(waitPause);
            end % for
            
        end % function
        
    end % methods
    
    methods(Access=private)
    
        % These next two methods remain hard-coded as they are (max order 3)
        % since I do not want to deal with the peculiarities of the
        % symbolic toolbox.
        function m = poly_cos_max_order_3(obj,tt,w,order)
            m = zeros(4,length(tt));
            for kk = 1:length(tt)
                t = tt(kk);
                m(4,kk) = sin(t*w)/w;
                m(3,kk) = (cos(t*w) + t*w*sin(t*w))/w^2;
                m(2,kk) = (t^2*w^2*sin(t*w) - 2*sin(t*w) + 2*t*w*cos(t*w))/w^3;
                m(1,kk) = -(6*cos(t*w) + 6*t*w*sin(t*w) - 3*t^2*w^2*cos(t*w) - t^3*w^3*sin(t*w))/w^4;
            end
            m = m( end-order:end , : );
        end
        
        function m = poly_sin_max_order_3(obj,tt,w,order)
            m = zeros(4,length(tt));
            for kk = 1:length(tt)
                t = tt(kk);
                m(4,kk) = -cos(t*w)/w;
                m(3,kk) = (sin(t*w) - t*w*cos(t*w))/w^2;
                m(2,kk) = (2*t*sin(t*w))/w^2 - cos(t*w)*(t^2/w - 2/w^3);
                m(1,kk) = sin(t*w)*((3*t^2)/w^2 - 6/w^4) - cos(t*w)*(t^3/w - (6*t)/w^3);
            end
            m = m( end-order:end , : );
        end
        
        % These next two methods should be restructured
        % such that the given order is conducive to the computation
        % of the output.
        function m = poly_func_max_order_3(obj,tt,w,order)
            m = zeros(4,length(tt));
            for kk = 1:length(tt)
                t = tt(kk);
                m(4,kk) = polyval( polyint( [1] ) , t );
                m(3,kk) = polyval( polyint( [1 0] ) , t );
                m(2,kk) = polyval( polyint( [1 0 0] ) , t );
                m(1,kk) = polyval( polyint( [1 0 0 0] ) , t );
            end
            m = m( end-order:end , : );
        end
        
        function m = tr_matrix_max_order_3(obj,a,order)
            m = ...
                [ ...
                    1 -3*a +3*a^2 -a^3 ; ...
                    0    1 -2*a   +a^2 ; ...
                    0    0    1   -a   ; ...
                    0    0    0    1     ...
                ];
            % get the lower rightmost submatrix
            m = m( end-order:end , end-order:end );
        end
        
    end % methods

end % class