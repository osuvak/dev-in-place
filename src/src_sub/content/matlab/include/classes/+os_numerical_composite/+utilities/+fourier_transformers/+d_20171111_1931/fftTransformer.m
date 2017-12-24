classdef fftTransformer
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

    methods (Access = protected)
        
        function checkOdd(obj,N)
            if rem(N,2) ~= 1
                error('Number of timepoints ''N'' must be odd.');
            end
        end
    end
    
    methods (Access = protected)
        
        function checkLength(obj,v,M,N)
            if size(v,1) ~= M*N
                error('Vector length must be ''M*N''');
            end
        end
        
    end
    
    methods (Access = protected)
        
        function v = fftShift(obj,v,M,N)
            K = ( N - 1 ) / 2;
            v = [ v((K+1)*M+1:N*M) ; v(1:(K+1)*M) ];
        end
        
        function v = fftShiftBack(obj,v,M,N)
            K = ( N - 1 ) / 2;
            v = [ v(K*M+1:N*M) ; v(1:K*M) ];
        end
        
    end
    
    methods (Access = public)
        
        % fft
        function res = blockFFT(obj,v,M,N)
            
            checkOdd(obj,N);
            checkLength(obj,v,M,N);
            
%              res = [];
            res = zeros( size(v) );

            for n = 1:size(v,2)

                m = zeros(M*N,1);

                % treat each signal separately
                for h = 1:M
                    theRange = h : M : h + (N-1) * M ;
                    m( theRange ) = fft( v(theRange,n) ) / N;
                end

                % shift the signals
                m = obj.fftShift(m,M,N);

%                  res = [res m];
                res(:,n) = m;

            end
        end
        
        % fft inverse
        function res = blockFFTInv(obj,v,M,N)
            
            checkOdd(obj,N);
            checkLength(obj,v,M,N);
            
%              res = [];
            res = zeros( size(v) );

            for n = 1:size(v,2)

                % shift the signals back
                m = obj.fftShiftBack(v(:,n),M,N);
                
                % treat each signal separately
                for h = 1:M
                    theRange = h : M : h + (N-1) * M ;
                    m( theRange ) = ifft( m(theRange) ) * N;
                end

%                  res = [res m];
                res(:,n) = m;

            end
        end
        
        % freq. domain differentiator
        function res = blockDiff(obj,v,M,N,f)
            
            res = blockDiffPi(obj,v,M,N);
            res = res * f;
            
        end
        
        % 2 pi times the helper method return
        function res = blockDiffPi(obj,v,M,N)
            res = blockDiffRaw(obj,v,M,N);
            res = res * 2 * pi;
        end
        
        % helper method for differentiator
        function res = blockDiffRaw(obj,v,M,N)
            
            checkOdd(obj,N);
            checkLength(obj,v,M,N);
            
            K = floor(N/2);
            offset = K + 1;
            
%              res = [];
            res = zeros( size(v) );

            for n = 1:size(v,2)
                
                m = zeros(N*M,1);
                
                for kk = 1:K
                    interval = M*( offset-1-kk )+1:M*( offset-1-kk )+M;
                    m(interval,1) = ...
                        - j * kk *...
                        v(interval,n);
                    
                    interval = M*( offset-1+kk )+1:M*( offset-1+kk )+M;
                    m(interval,1) = ...
                        + j * kk *...
                        v(interval,n);
                    
                end
                
%                  res = [res m];
                res(:,n) = m;

            end
            
        end
        
        % time-shifter in freq domain
        function res = blockTimeShifter(obj,v,M,N,f,howMuch)
            
            checkOdd(obj,N);
            checkLength(obj,v,M,N);
            
            K = floor(N/2);
            
%              res = [];
            res = zeros( size(v) );
            
            for n = 1:size(v,2)
                
                m = zeros(N*M,1);
                
                for kk = 1:N
                    interval = (kk-1) * M + 1 : kk * M;
                    sc = ( kk - 1 - K ) * j * 2 * pi * f * howMuch;
                    m(interval,1) = exp(sc) * v(interval,n);
                end
                
%                  res = [res m];
                res(:,n) = m;

            end
            
        end
        
        % zero particular component in f-domain vector
        % used for initial time-domain shifting in HB
        function res = zeroParticComponent(obj,v,M,N,sigNo)
            
            checkOdd(obj,N);
            checkLength(obj,v,M,N);
            
            if ( sigNo > M ) || ( sigNo < 0 )
                error('sigNo is not valid.');
            end
            
            K = floor(N/2);
            
%              res = [];
            res = zeros( size(v) );
            
            for n = 1:size(v,2)
                
                m = v(:,n);
                
                % first harmonic
                comp = m( ( K + 1 ) * M + sigNo , n );
                
                % phase multiplier
                a = atan( imag(comp) / real(comp) );

                % shift in the time domain
                % done for all the signals
                for h = 1:K
                    rangeP = (K + h)*M+1:(K + h)*M+M;
                    rangeN = (K - h)*M+1:(K - h)*M+M;
                    m( rangeP , n ) = exp(-j*a*h) * m( rangeP , n );
                    m( rangeN , n ) = exp(+j*a*h) * m( rangeN , n );
                end
                
%                  res = [res m];
                res(:,n) = m;

            end
        end
    end
end