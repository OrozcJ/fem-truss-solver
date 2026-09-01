function K = appendBar(K,Ke,L)
%APPENDBAR Assemble an element stiffness matrix into the global stiffness matrix.
%   K = APPENDBAR(K, Ke, L) adds the global element stiffness matrix Ke into
%   the global stiffness matrix K, using the location vector L to map local
%   degrees of freedom to global DOFs.

    sz = size(Ke);

    Kebool = (isequal(sz,[4 4]) || isequal(sz,[6 6]));
    Lbool = (ismember(size(L,2),[4 6]));

    if sz(2) ~= size(L,2)
        error("Element matrix (Ke) and location matrix (L) sizes does not agree")
    end

    if Kebool && Lbool
        for i = 1:sz(1)
            for j = 1:sz(2)
                K(L(i),L(j)) = K(L(i),L(j)) + Ke(i,j);
            end
        end
    else
        error("invalid matrix size for L or Ke");
    end
end