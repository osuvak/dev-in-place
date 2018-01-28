function rrrruntests(varargin)
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

flag_plotFancy = 1;
if nargin >= 1
    if 0 == varargin{1}
        flag_plotFancy = 0;
    end
end

cltype = 'os_numerical_composite.testers.d_20170204_2252.GenericTesterBase';

%  !$HOME/dev_in_place/scripts/analyze_matlab_testers_classes
system( '$HOME/dev_in_place/scripts/analyze_matlab_testers_classes' );

perl_comm;

if stinfo.flag_existTests

    if ~stinfo.flag_chosen
        disp('No tests were chosen. Cannot run any.');
        return
    end
    
    try 
        eval( sprintf( 'oa = %s.%s;' , stinfo.prefix_package , stinfo.class_ch ) );
    catch ME
        disp( 'There is a problem initializing the indicated test.' );
        disp( ME.identifier );
        disp( ME.message );
        return;
    end
    
    if ~isa( oa , cltype )
        error('The object is not derived from the required class.');
    end
    
    if oa.flag_expected_to_fail
        disp( 'Note that the test is expected to fail.' );
    end
    
    if oa.flag_plottable
        if flag_plotFancy
            eval( sprintf( 'runmytest(%s.%s , 1 , 1)' , stinfo.prefix_package , stinfo.class_ch ) );
        else
            eval( sprintf( 'runmytest(%s.%s , 1)' , stinfo.prefix_package , stinfo.class_ch ) );
        end
    else
        eval( sprintf( 'runmytest( %s.%s )' , stinfo.prefix_package , stinfo.class_ch ) );
    end
    
else
    disp('No tests exist. Cannot run any.');
    return
end

end % function