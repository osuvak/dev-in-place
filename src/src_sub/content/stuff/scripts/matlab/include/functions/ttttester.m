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

close all
clear variables
clear classes

format long e
rng( 'shuffle' , 'twister' );

content = what;
testFiles = cell(0,1);

for kk = 1:numel(content.m);
    if strncmpi( content.m{kk} , 'test_' , length('test_') );
        testFiles{end+1,1} = content.m{kk}(1:end-2);
    end
end % for kk
testFiles = sort(testFiles);

myChoice = 0;
lastMessage = 'Welcome to ttttester script!';
flag_chosen = logical(0);
flag_quits  = logical(0);
while ~flag_chosen
    clc;
    disp(lastMessage);
%      try
        disp(' ')
        disp('Testing Scripts :')
        disp(' ')
        for kk = 1:numel(testFiles)
            disp( sprintf( '%6d  %s' , kk , testFiles{kk,1}(length('test_')+1:end) ) );
        end % for kk
        disp(' ')

        ch = input('Choose one of the tests above (0 to quit) : ');
%          someUnknownCommandToInvokeCatchBelow
%      catch me
%          lastMessage = 'Problem with the choice. Try again...';
%          continue;
%      end
    
    if isnumeric(ch)
        if isreal(ch)
            logicVal = ( ch >= 1 ) && ( ch <= numel(testFiles) );
            if ch == 0
                flag_chosen = logical(1);
                flag_quits  = logical(1);
            elseif ~logicVal
                lastMessage = 'Choice not in range. Try again...';
            else
                myChoice = ch;
                flag_chosen = logical(1);
            end
        else
            lastMessage = 'Expecting real numeric input. Try again...';
        end
    else
        lastMessage = 'Expecting numeric input. Try again...';
    end
    
    clear ch;
end % while

% clear unnecessary variables
clear kk
clear ch
clear content
clear flag_chosen
clear lastMessage
clear logicVal

% run if requested
disp(' ');
if flag_quits
    disp('You have chosen to quit. Bye.');
    disp(' ');
else
    disp( sprintf('Evaluating the test ''%s''.' , testFiles{myChoice,1} ) );
    disp(' ');
    eval(testFiles{myChoice,1});
end