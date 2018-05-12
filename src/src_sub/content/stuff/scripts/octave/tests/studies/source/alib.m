function alib(varargin)

%  choice - add to or remove from path
if nargin <= 0
    ch = 1;
else
    ch = varargin{1};
end

%  look for this one
str = 'zzz_strange_folder_name';

%  determine location
here = pwd;

flag = 0;
cnt  = 0;
while (flag <= 0)
    chdir('..');
    cnt = cnt + 1;
    list = dir();
    % for kk = 1:size(list,1)
    for kk = 1:length(list)
        lval = ( strcmpi( list(kk).name , str ) && ( list(kk).isdir == 1 ) );
        if lval
            flag = 1;
            break;
        end
    end
end

chdir(here);

%  go back, do the job, return
here = pwd;
ss = '';
for kk = 1:cnt-1
    ss = sprintf( '%s''..'',' , ss );
end
ss = sprintf( '%s''..''' , ss );
eval( sprintf( 'chdir( fullfile(%s) );' , ss ) );
chdir( fullfile('..','path_setting') );
otools;
alib(ch);
chdir(here);

end
