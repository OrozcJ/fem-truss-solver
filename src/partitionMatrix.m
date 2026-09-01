function M = partitionMatrix(KG,active_vec)
%PARTITIONMATRIX Partition a global matrix by active/constrained DOFs.
%   M = PARTITIONMATRIX(KG, active_vector) splits KG into a 2x2 cell array
%   of submatrices based on which DOFs are active (free) vs constrained.
%
%   Inputs:
%       KG            - Global square matrix (e.g. stiffness matrix).
%       active_vector - 1xN logical/numeric vector, nonzero = active DOF,
%                       zero = constrained DOF. N must match size(KG).
%
%   Output:
%       M - 2x2 cell array {Kcc, Kca; Kac, Kaa}, partitioned by
%           constrained (c) and active (a) DOFs.

arguments
    KG 
    active_vec (1,:)
end

    sz_avec = size(active_vec,2);
    if  (sz_avec ~= size(KG,2) || sz_avec ~= size(KG,1))
        error(['Node number in active_vector (%d) ' ...
            'does not coincide with global matrix size (%d) '], ...
            sz_avec, size(KG,1));
    end
    active_nodes = find(active_vec);
    constrained_nodes = find(~active_vec);

    Kaa = KG(active_nodes,active_nodes);
    Kcc = KG(constrained_nodes, constrained_nodes);
    Kca = KG(constrained_nodes, active_nodes);
    Kac = Kca'; % Transpose Kca to form Kac

    M = {Kcc Kca; Kac Kaa};
end