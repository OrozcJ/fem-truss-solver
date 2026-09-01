function plotTruss(connectivity, coordinates, displacements, multiplier, plotTitle, o_scale)
%PLOTTRUSS Plot undeformed and deformed shapes of a 2D or 3D truss.
%   PLOTTRUSS(connectivity, coordinates, displacements, multiplier, plotTitle)
%   draws the undeformed truss (blue) and deformed shape (green, red, markers),
%   scaled by a multiplier. Dimension is inferred from coordinates.
%
%   Inputs:
%       connectivity  - Nx2 matrix of [nodeA, nodeB] per element.
%       coordinates   - Node coordinate matrix (2D or 3D).
%       displacements - Global DOF displacement vector (interleaved per
%                       node, matching INDEXTRANSFORMER's convention).
%       multiplier    - Deformation scale factor (default: 100).
%       plotTitle     - Custom title text (default: "Truss plot").
%
%   Notes:
%       - 3D view remaps axes as plot3(Z, -X, Y); calls DRAWORIGIN(10).
%       - Opens a new figure; no return value.

arguments
    connectivity
    coordinates
    displacements  
    multiplier = 100;
    plotTitle = "";
    o_scale = 10; 
end
    figure;
    numElements = size(connectivity,1);
    dim = size(coordinates,2);
    if plotTitle == ""
        txttitle = "Truss plot  (X" + multiplier +")";
    else
        txttitle = plotTitle + " (X" + multiplier + ")";
    end

    % Undeformed shape
    if dim == 2
        for e=1:numElements
            hold on; % Keep the current plot
            cd = [coordinates(connectivity(e, 1),:); coordinates(connectivity(e, 2),:)];
            if e == 1
                hUndef = plot(cd(:,1), cd(:,2), 'b-', 'LineWidth', 2); % PLot first element, assign it to a legend.
            else
                plot(cd(:,1), cd(:,2), 'b-', 'LineWidth', 2,'HandleVisibility', 'off'); % Plot others elements, ignore the legend
            end
            title(txttitle)
        end
    else
        for e=1:numElements
            hold on; % Keep the current plot
            view(3)
            % view(-15, 15);                          % ángulo de "punto de vista" (ajustable)
            % set(gca, 'CameraUpVector', [0 1 0]);    % fuerza a que Y se dibuje vertical
            cd = [coordinates(connectivity(e, 1),:); coordinates(connectivity(e, 2),:)];

            if e == 1
                hUndef = plot3(cd(:,3), -cd(:,1),cd(:,2), 'b-', 'LineWidth', 2); 
            else
                plot3(cd(:,3), -cd(:,1),cd(:,2), 'b-', 'LineWidth', 2,'HandleVisibility', 'off');
            end
            title(txttitle)
        end
    end


    % Deformed shape
    dofs = 1:size(coordinates,1)*dim;

    if dim == 2
        xDofs = dofs(mod(dofs, 2) == 1);   % all x-direction DOFs
        yDofs = dofs(mod(dofs, 2) == 0);   % all y-direction DOFs
        displacements = [displacements(xDofs), displacements(yDofs)];
        deformedCoordinates = coordinates + multiplier*displacements; % Calculate deformed shape

        for e = 1:numElements
            cdDef = [deformedCoordinates(connectivity(e, 1),:); deformedCoordinates(connectivity(e, 2),:)];
            if e == 1
                hDef = plot(cdDef(:,1), cdDef(:,2), '-o', 'Color', 'g', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r', 'LineWidth', 1.5, 'MarkerSize', 6);
            else
                plot(cdDef(:,1), cdDef(:,2), '-o', 'Color', 'g', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r', 'LineWidth', 1.5, 'MarkerSize', 6, 'HandleVisibility', 'off');
            end
            title(txttitle)
        end
    else
        xDofs = dofs(mod(dofs-1, 3) == 0);
        yDofs = dofs(mod(dofs-1, 3) == 1);
        zDofs = dofs(mod(dofs-1, 3) == 2);   % all z-direction DOFs

        displacements = [displacements(xDofs), displacements(yDofs), displacements(zDofs)];
        deformedCoordinates = coordinates + multiplier*displacements; % Calculate deformed shape

        for e = 1:numElements
            cdDef = [deformedCoordinates(connectivity(e, 1),:); deformedCoordinates(connectivity(e, 2),:)];
             if e == 1
                hDef = plot3(cdDef(:,3), -cdDef(:,1), cdDef(:,2), '-o', 'Color', 'g', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r', 'LineWidth', 1.5, 'MarkerSize', 6);
            else
                plot3(cdDef(:,3), -cdDef(:,1), cdDef(:,2), '-o', 'Color', 'g', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r', 'LineWidth', 1.5, 'MarkerSize', 6, 'HandleVisibility', 'off');
            end
            title(txttitle)
        end
        drawOrigin(o_scale)
    end
    
    grid on 
    axis equal
    legend([hUndef, hDef], {'Undeformed shape', 'Deformed shape'}, 'Location', 'best');
end