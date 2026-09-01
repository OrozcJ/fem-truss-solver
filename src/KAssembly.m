function KG = KAssembly(connectivity, stf, coordinates, dim)
%KASSEMBLY Assemble the global stiffness matrix for a truss structure.
%
%   Inputs:
%       connectivity - Nx2 matrix of [nodeA, nodeB] per element.
%       stiffness    - 1xN per-element stiffness data.
%       coordinates  - Node coordinate matrix.
%       dim          - "2d" or "3d" (default: "2d").
%
%   Output:
%       KG - Global stiffness matrix (numDOF x numDOF).
%
%   See also: INDEXTRANSFORMER, APPENDBAR

arguments
    connectivity (:,2)
    stf (1,:)
    coordinates 
    dim {mustBeMember(dim,{'2d','3d'})} = "2d"
end

    if size(connectivity,1) ~= size(stf,2)
        error(['Element number in connectivity (%d) ' ...
            'does not coincide with stiffness table (%d) '], ...
            size(connectivity,1), size(stf,2));
    end
    numElements = size(connectivity,1);
    dimCheck = 2 + (dim == "3d"); 
    numDOF = max(connectivity,[],"all")*dimCheck;
    KG = zeros(numDOF,numDOF);

    for e=1:numElements
        
        L = indexTransformer(connectivity(e, :),dim);
        cd = [coordinates(connectivity(e, 1),:); coordinates(connectivity(e, 2),:)];
        Ke = transformStiffness(stf(e), cd, dim);
        KG = appendBar(KG,Ke,L);
    end
end