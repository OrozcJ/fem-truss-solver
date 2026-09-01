function y = transformStiffness(k, coordinates, dim)
%TRANSFORMSTIFFNESS Transform a local element stiffness to global coordinates.
%   y = TRANSFORMSTIFFNESS(k, coordinates, dim) computes the element
%   stiffness matrix in global coordinates from axial stiffness k and the
%   element's node coordinates, ready for assembly (see APPENDBAR).
%
%   Inputs:
%       k           - Scalar axial stiffness (e.g. E*A/L) of the element.
%       coordinates - 2x2 (2D) or 2x3 (3D) matrix, node coordinates
%                     [node1; node2].
%       dim         - "2d" or "3d" (default: "2d").
%
%   Output:
%       y - Global element stiffness matrix (4x4 for 2D, 6x6 for 3D).

arguments
    k (1,1)
    coordinates
    dim {mustBeMember(dim,{'2d','3d'})} = "2d"

end

    d = coordinates(2,:) - coordinates(1,:);
    L = norm(d); 
    lambda = d/L;  % Normalized unit vector

    if dim == "2d"
        c = lambda(1); s = lambda(2); % cos and sin
        R = [c^2  s*c  -c^2  -s*c;
            s*c  s^2  -s*c  -s^2;
            -c^2  -s*c  c^2  s*c;
            -s*c  -s^2  s*c  s^2];
    else
        % Cosines of the element for each axis 
        cx = lambda(1); cy = lambda(2); cz = lambda(3); 
        
        % Stiffness matrix for a 3D Truss
        R = [ cx^2     cx*cy    cx*cz   -cx^2    -cx*cy   -cx*cz;
              cx*cy    cy^2     cy*cz   -cx*cy   -cy^2    -cy*cz;
              cx*cz    cy*cz    cz^2    -cx*cz   -cy*cz   -cz^2;
             -cx^2    -cx*cy   -cx*cz    cx^2     cx*cy    cx*cz;
             -cx*cy   -cy^2    -cy*cz    cx*cy    cy^2     cy*cz;
             -cx*cz   -cy*cz   -cz^2     cx*cz    cy*cz    cz^2 ];
    end
    % Transformation to global coordinates
    y = k*R;
end