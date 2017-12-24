function [ h_fig , h_plot , h_ca ] = plot_tran(vec_x,vec_y,flag_maximize)
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

if size(vec_x,1) ~= 1
    error('vec_x should be a row vector.');
end

if size(vec_x,2) ~= size(vec_y,2)
    error('vec_x and vec_y should have the same number of columns.');
end

FontSize = 16;

tol = 0.1;

enc_max = max( max(vec_y,[],2) , [] , 1 );
enc_min = min( min(vec_y,[],2) , [] , 1 );

lim_y_max = enc_max + tol * abs(enc_max-enc_min);
lim_y_min = enc_min - tol * abs(enc_max-enc_min);

figure;
h_plot = plot( vec_x , vec_y , 'LineWidth' , 4 );

axis([vec_x(1) vec_x(end) lim_y_min lim_y_max]);

set(gca,'units','normalized')
set(gca,'Box','on','FontName','Arial',...
    'FontSize',FontSize,'FontWeight','bold','LineWidth',4)

grid on;
title('Transient Analysis Vectors vs. time')
xlabel('time (sec)')

if flag_maximize
    set( gcf , 'units' , 'normalized' , 'Position' , [0 0 1 1] );
    style = hgexport('factorystyle');
    style.Bounds = 'tight';
    hgexport( gcf , '.tmpmatlab' , style , 'applystyle' , true );
end

h_fig = gcf;
h_ca  = gca;

return;

end