function L = indexTransformer(idx,dim)
%INDEXTRANSFORMER Converts a pair of node indices(i,j) into the corresponding
% vector L of global degree-of-freedom (DOF) indices (see APPENDBAR).
%
% Returns a Location vector (L) of global DOF indices for the given nodes:
% 4 entries if dim = "2d", 6 entries if dim = "3d".

arguments
    idx (1,2) {mustBePositive}
    dim string {mustBeMember(dim,{'2d','3d'})} = "2d"
end 
    if dim == "2d"
        L = [2*idx(1)-1, 2*idx(1), 2*idx(2)-1, 2*idx(2)];
    else 
        L = [3*idx(1)-2, 3*idx(1)-1, 3*idx(1), 3*idx(2)-2, 3*idx(2)-1, 3*idx(2)];
    end
end