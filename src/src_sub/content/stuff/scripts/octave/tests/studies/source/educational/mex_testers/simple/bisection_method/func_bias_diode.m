function m = func_bias_diode(VD)
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

R   = 1e3;
IS  = 3e-15;
VIN = 3.3;
VT  = 25e-3;

m = zeros(size(VD));

for kk = 1:numel(m)
    m(kk) = VT * log( ( VIN - VD(kk) ) / ( R * IS ) ) - VD(kk);
end

end
