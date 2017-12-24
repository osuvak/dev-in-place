function pathSetter(base,id,fd)
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

    if nargin < 3
        warning('Matlab:PathAction','Nothing to do.');
        return
    end
    
    cur = pwd;
    
    eval(sprintf('cd %s',base));
    basePath = pwd;
    
    eval(sprintf('cd %s',cur));
    
    if id == 1
        
        for kk = 1:size(fd,2)
            % eval( sprintf( 'addpath %s/%s -END'   , basePath , fd{kk} ) );
            eval( sprintf( 'addpath %s -END'   , fullfile( basePath , fd{kk} ) ) );
            fprintf( '''%s'' added to path.\n' , fullfile( basePath , fd{kk} ) );
        end
        
    elseif id == 2
        
        for kk = 1:size(fd,2)
            % eval( sprintf( 'rmpath %s/%s'             , basePath , fd{kk} ) );
            eval( sprintf( 'rmpath %s'             , fullfile( basePath , fd{kk} ) ) );
            fprintf( '''%s'' removed from path.\n' , fullfile( basePath , fd{kk} ) );
        end
        
    else
        
        warning('Matlab:PathAction','No change to path.');
        
    end

end