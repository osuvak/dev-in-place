function runmytest(scrtest,varargin)
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

cltype = 'os_numerical_composite.testers.d_20170204_2252.GenericTesterBase';

if ~isa( scrtest , cltype )
    error('The object is not derived from the required class.');
end

%  tic;
t1 = clock;
if nargin <= 1
    scrtest.run();
elseif ( nargin >= 2 ) && ( varargin{1} > 0 )
    if ( nargin >= 3 ) && ( varargin{2} > 0 )
        scrtest.run_with_plots(1);
    else
        scrtest.run_with_plots();
    end
end
t2 = clock;
disp(' ');
disp('The test duration is:');
%  toc;
fprintf( '    %f seconds.\n' , etime(t2,t1) );

disp(' ');
disp('Title of the Test:');
disp(sprintf('  %s',scrtest.title));

disp(' ');
disp('Description of the Test:');
if ~iscell(scrtest.description)
    disp(sprintf('  %s',scrtest.description));
else
    for kk = 1:size(scrtest.description,2)
        disp(sprintf('  %s',scrtest.description{kk}));
    end
end
disp(' ');

end % function
