classdef stick_breaking_test < os_numerical_composite.testers.d_20170204_2252.GenericTesterWOpts
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

    properties(SetAccess=private,GetAccess=public)
        L                    % length of stick
        N                    % number of Monte Carlo experiments
        
        p                    % position of scratch on the stick
        
        ss                   % structure holding computed data
        
        noPartitions         % number of partitions in bar plots
        tol_interval_support % tolerance used in pdf cdf support intervals
    end % properties

    methods(Access=public)
        function obj = stick_breaking_test()
            import os_numerical_composite.testers.d_20170204_2252.*
            
            opts = tester_options_set;
            
            opts.title       = ...
                'Stick Breaking Test - on the length of the segment that holds a prepositioned scratch on a stick';
            opts.description = ...
                { ...
                'A stick of length L is scratched at position p. The stick is randomly broken' , ...
                'into two at a position U (where U is a uniformly distributed random variable).' , ...
                'We monitor the length of the sub-stick holding the scratch at p. For several' , ...
                'values of p, we compute expectations, variances, pdfs and cdfs.' ...
                };
        
%              opts.flag_in_realquick     = 0;
%              opts.flag_expected_to_fail = 0;
            opts.flag_plottable        = 1;
        
            obj@os_numerical_composite.testers.d_20170204_2252.GenericTesterWOpts( opts );
                
            % instance-specific initializations
            obj.L = 1;
            obj.N = 5e5;
            
            obj.p = 0.2:0.05:0.8;
            
            obj.noPartitions = 50;
            obj.tol_interval_support = 0.001;
        end % function
        
        function delete(obj)
        end % function
    end % methods
    
    % methods
    methods(Access=private)
    
function ss = stick_breaker(obj,p)
rng('shuffle','twister');

ss = [];

for ll = 1:numel(p)
    % break stick at U
    U = obj.L * rand(obj.N,1);
    LpU = zeros(size(U));

    % compute the length of the sub-stick that contains the scratch at p
    for kk = 1:numel(U)
        LpU(kk) = U(kk);
        if U(kk) <= p(ll)
            LpU(kk) = obj.L - U(kk);
        end
    end
    
    ss(ll).U   = U;
    ss(ll).LpU = LpU;
end % for
end % function
    
function core(obj)
obj.ss = obj.stick_breaker(obj.p);
for kk = 1:numel(obj.ss)
    % expectation
    obj.ss(kk).exp_LpU = sum( obj.ss(kk).LpU ) / numel( obj.ss(kk).LpU );
    % variance
    obj.ss(kk).var_LpU = std( obj.ss(kk).LpU )^2;
    
    % preliminaries for pdf computation
    [ LpU_min_eff , LpU_max_eff ] = obj.compute_effective_min_max( obj.ss(kk).LpU );
    obj.ss(kk).LpU_min_eff = LpU_min_eff;
    obj.ss(kk).LpU_max_eff = LpU_max_eff;
    obj.ss(kk).L_eff = abs( LpU_min_eff - LpU_max_eff );
    
    obj.ss(kk).groups = ...
      floor( ( obj.ss(kk).LpU - obj.ss(kk).LpU_min_eff ) / obj.ss(kk).L_eff * obj.noPartitions );
      
    obj.ss(kk).freqCount = zeros( obj.noPartitions , 1 );
    for ll = 1:length(obj.ss(kk).freqCount)
        obj.ss(kk).freqCount(ll) = length( find( obj.ss(kk).groups == ll-1 ) );
    end
    obj.ss(kk).freqCount(end) = obj.ss(kk).freqCount(end) + length( find( obj.ss(kk).groups == length(obj.ss(kk).freqCount) ) );

    % pdf
    obj.ss(kk).freqCount = obj.ss(kk).freqCount / obj.N * obj.noPartitions / obj.ss(kk).L_eff;
    % cdf
    obj.ss(kk).cdf = cumsum(obj.ss(kk).freqCount) / obj.noPartitions * obj.ss(kk).L_eff;
    % range for pdf cdf
    obj.ss(kk).pRange = ( (0:obj.noPartitions-1) + 0.5 ) / obj.noPartitions * obj.ss(kk).L_eff + obj.ss(kk).LpU_min_eff;
end % for
end % function

function [ min_eff , max_eff ] = compute_effective_min_max( obj , val )
len = abs( min(val) - max(val) );

min_eff = min(val) - len * obj.tol_interval_support;
max_eff = max(val) + len * obj.tol_interval_support;
end % function

function limits = plot_limiter( obj , x_data , y_data , tol_x_plot , tol_y_plot )
len_y = abs( min(y_data) - max(y_data) );
len_x = abs( min(x_data) - max(x_data) );

min_y = min(y_data) - tol_y_plot * len_y;
max_y = max(y_data) + tol_y_plot * len_y;

min_x = min(x_data) - tol_x_plot * len_x;
max_x = max(x_data) + tol_x_plot * len_x;

limits = [ min_x max_x min_y max_y ];
end % function

    end % methods
    
    % methods
    methods(Access=public)
    
function run(obj,varargin)
obj.core()
end

function run_with_plots(obj,varargin)
FontSize = 16;

flag_quality_pub = 0;
if ( nargin >= 2 ) && ( varargin{1} > 0 )
    flag_quality_pub = 1;
end

obj.core()

figure;
plot( obj.p , [obj.ss(:).exp_LpU] , 'Color' , 'b' , 'LineWidth' , 4 )
hold off;
hold on;
plot ...
    ( ...
    obj.p , [obj.ss(:).exp_LpU] , 'o' , ...
    'MarkerSize' , 20 , 'MarkerEdgeColor' , 'k' , 'MarkerFaceColor' , 'r' , 'LineWidth' , 2 ...
    )
hold off;

axis( obj.plot_limiter( obj.p , [obj.ss(:).exp_LpU] , 0.01 , 0.05 ) )

set(gca,'units','normalized')
set(gca,'Box','on','FontName','Arial',...
    'FontSize',FontSize,'FontWeight','bold','LineWidth',4)

grid on;
title('Expectation of Length of Sub-Stick Containing point p vs. p')

if flag_quality_pub
    set( gcf , 'units' , 'normalized' , 'Position' , [0 0 1 1] );
    style = hgexport('factorystyle');
    style.Bounds = 'tight';
    hgexport( gcf , '.tmpmatlab' , style , 'applystyle' , true );
end

figure;
plot( obj.p , [obj.ss(:).var_LpU] , 'Color' , 'b' , 'LineWidth' , 4 )
hold off;
hold on;
plot ...
    ( ...
    obj.p , [obj.ss(:).var_LpU] , 'o' , ...
    'MarkerSize' , 20 , 'MarkerEdgeColor' , 'k' , 'MarkerFaceColor' , 'r' , 'LineWidth' , 2 ...
    )
hold off;

axis( obj.plot_limiter( obj.p , [obj.ss(:).var_LpU] , 0.01 , 0.08 ) )

set(gca,'units','normalized')
set(gca,'Box','on','FontName','Arial',...
    'FontSize',FontSize,'FontWeight','bold','LineWidth',4)

grid on;
title('Variance of Length of Sub-Stick Containing point p vs. p')

if flag_quality_pub
    set( gcf , 'units' , 'normalized' , 'Position' , [0 0 1 1] );
    style = hgexport('factorystyle');
    style.Bounds = 'tight';
    hgexport( gcf , '.tmpmatlab' , style , 'applystyle' , true );
end

%  plot pdf cdf
for kk = 1:numel(obj.p)
    % cdf
    figure;
    bar( obj.ss(kk).pRange , obj.ss(kk).cdf )
    colormap(cool)

    axis( obj.plot_limiter( obj.ss(kk).pRange , obj.ss(kk).cdf , 0.02 , 0.05 ) );

    set(gca,'units','normalized')
    set(gca,'Box','on','FontName','Arial',...
        'FontSize',FontSize,'FontWeight','bold','LineWidth',4)

    grid on;
    title( sprintf('CDF vs Support Range ( p = %f )',obj.p(kk)) )

    if flag_quality_pub
        set( gcf , 'units' , 'normalized' , 'Position' , [0 0 1 1] );
        style = hgexport('factorystyle');
        style.Bounds = 'tight';
        hgexport( gcf , '.tmpmatlab' , style , 'applystyle' , true );
    end
    
    % pdf
    figure;
    bar( obj.ss(kk).pRange , obj.ss(kk).freqCount )
    colormap(cool)

    % to do : more elegant axis limit control necessary
%      axis( obj.plot_limiter( obj.ss(kk).pRange , obj.ss(kk).freqCount , 0.02 , 0.05 ) );

    set(gca,'units','normalized')
    set(gca,'Box','on','FontName','Arial',...
        'FontSize',FontSize,'FontWeight','bold','LineWidth',4)

    grid on;
    title( sprintf('PDF vs Support Range ( p = %f )',obj.p(kk)) )

    if flag_quality_pub
        set( gcf , 'units' , 'normalized' , 'Position' , [0 0 1 1] );
        style = hgexport('factorystyle');
        style.Bounds = 'tight';
        hgexport( gcf , '.tmpmatlab' , style , 'applystyle' , true );
    end
end % for

end % function

    end % methods
    
end % class
