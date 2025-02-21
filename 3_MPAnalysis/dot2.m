function scalar = dot2(vec1,vec2)
% calculates dot-product, faster than the dot.m-function of Matlab

%Copyright (C) 2023, M.F. Glaner
%Adapted by GCC Group
%--------------------------------------------------------------------------

scalar = vec1(:)'*vec2(:);