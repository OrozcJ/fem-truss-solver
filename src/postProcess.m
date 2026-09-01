function [strain, stress] = postProcess(connectivity,coordinates,U,E,dim)
%POSTPROCESS Compute axial strain and stress for each truss element.
%   [strain, stress] = POSTPROCESS(connectivity, coordinates, U, E, dim)
%   projects global displacements onto each element's axis to get axial
%   strain, then applies Hooke's law (stress = E*strain).
%
%   Inputs:
%       connectivity - Nx2 element node index matrix.
%       coordinates  - Node coordinate matrix.
%       U            - Global displacement vector.
%       E            - Young's modulus, scalar or 1xN per-element vector.
%       dim          - "2d" or "3d" (default: "2d").
%
%   Outputs:
%       strain, stress - 1xN vectors, one value per element

arguments
    connectivity 
    coordinates 
    U 
    E (:,1)
    dim {mustBeMember(dim,{'2d','3d'})} = "2d"
end
    numEl = size(connectivity,1);
    szE = size(E,1);
    if szE ~= 1 && szE ~= numEl
    error(['vector E size (%d) does not coincide with '...
        'the number of elements (%d) '], szE, numEl);
    end
    
    strain = zeros(numEl,1);
    ndof = 2 + (dim == "3d");   % 2 si es 2d, 3 si es 3d
    for e = 1:numEl
        cd = [coordinates(connectivity(e, 1),:); coordinates(connectivity(e, 2),:)];
        d = cd(2,:) - cd(1,:);
        L = norm(d); 
        lambda = d/L;            % Normalized unit vector
        L_v = indexTransformer(connectivity(e,:),dim);
        U_e = U(L_v);
        u1 = lambda * U_e(1:ndof);          % U(1:2) para 2d, U(1:3) para 3d
        u2 = lambda * U_e(ndof+1:2*ndof);   % U(3:4) para 2d, U(4:6) para 3d
        strain(e) = (u2 - u1)/L;
    end
    stress = strain.*E;
end