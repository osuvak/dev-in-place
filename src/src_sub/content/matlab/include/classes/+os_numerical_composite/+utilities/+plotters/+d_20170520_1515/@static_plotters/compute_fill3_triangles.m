function [ xInfo , yInfo , zInfo , zAvInfo ] = ...
    compute_fill3_triangles( edgePtsL , edgePtsW , zValues )
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

    import os_numerical_composite.utilities.data_containers.d_20170423_1211.*
        
    pts = zeros( size(edgePtsW.data , 1) * size(edgePtsL.data , 1) , 3);
            
    pts(:,1) = kron( ones( size(edgePtsW.data,1) , 1 ) , edgePtsL.data );
    pts(:,2) = kron( edgePtsW.data , ones( size(edgePtsL.data,1) , 1 ) );
    pts(:,3) = zValues.data;

    triangles = zeros( 2 * (numel(edgePtsW.data)-1) * (numel(edgePtsL.data)-1) , 3 );
            
    for kk = 1:numel(edgePtsW.data)-1
        for ll = 1:numel(edgePtsL.data)-1
                
            indTriTemp = ...
                (kk-1) * 2 * (numel(edgePtsL.data)-1) ...
                + ...
                2 * ll - 1;
                    
            triangles(indTriTemp,:) = [ (kk-1)*numel(edgePtsL.data)+ll (kk-1)*numel(edgePtsL.data)+ll+1 (kk)*numel(edgePtsL.data)+ll+1 ];
        
            indTriTemp = indTriTemp + 1;
            triangles(indTriTemp,:) = [ (kk-1)*numel(edgePtsL.data)+ll (kk)*numel(edgePtsL.data)+ll (kk)*numel(edgePtsL.data)+ll+1 ];
        
        end % for
    end % for

    % instantiate x y z container handlers
    xInfo   = matrix_container();
    yInfo   = matrix_container();
    zInfo   = matrix_container();
    zAvInfo = matrix_container();
            
    xInfo.data = zeros( 3 , size(triangles,1) );
    yInfo.data = xInfo.data;
    zInfo.data = xInfo.data;

    zAvInfo.data = zeros( 1 , size(triangles,1) );

    for kk = 1:size(triangles,1)
        ptsIndices = triangles(kk,:);
        tmp = pts(ptsIndices,:);
        xInfo.data(:,kk) = tmp(:,1);
        yInfo.data(:,kk) = tmp(:,2);
        zInfo.data(:,kk) = tmp(:,3);
    
        zAvInfo.data(kk) = sum(zInfo.data(:,kk)) / 3;
    end % for

end % function
 