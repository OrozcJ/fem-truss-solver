function [stiffness, ke] = BarElStiffness(E, A, L)
%BARELSTIFFNESS Compute axial stiffness and local stiffness matrix of bar elements.
%    Accepts scalars or equal-length column vectors for batch computation.
%
%   Inputs:
%       E, A, L - Column vectors (or scalars) of Young's modulus,
%                 cross-sectional area, and length, same size.
%
%   Outputs:
%       stiffness - Axial stiffness value(s), E.*A./L.
%       ke        - Local 2x2 stiffness matrix (single element), or a
%                   1xN cell array of 2x2 matrices (multiple elements).
%
%   See also: TRANSFORMSTIFFNESS

arguments
    E (:,1)  {mustBePositive}
    A (:,1)  {mustBePositive}
    L (:,1)  {mustBePositive}
end
    n = size(E,1);
    if (size(A,1) ~= n || size(L,1) ~= n)
        error("vectors E, A and L must have the same size")
    end
    
    stiffness = E.*A./L;
    if n == 1
        ke = stiffness*[ 1 -1; -1 1];
    else
        ke = cell(1,n);
        for e=1:n
            ke{e} = stiffness(e)*[ 1 -1 ; -1 1];
        end
    end
end