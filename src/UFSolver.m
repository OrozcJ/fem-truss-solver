function [Ua,Fc] = UFSolver(M, Uc, Fa)
% Calculates the displacement and the reaction forces of a truss.
% 
%   Inputs:
%       M  - 2x2 cell array from partitionMatrix: {Kcc Kca; Kac Kaa}
%
%   Outputs:
%       Uc - prescribed displacements at constrained DOFs
%       Fa - applied forces at active (free) DOFs

    Ua = M{2,2}\(Fa - M{2,1}*Uc);
    Fc = M{1,1}*Uc + M{1,2}*Ua;
end