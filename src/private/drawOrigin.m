function drawOrigin(scale, arrowColor, sphereRadius)
% DRAWORIGIN Draws the origin as a sphere with 3 arrows (x, y, z axes)
%   The axes are plotted with the remapping (x,y,z) -> (z,-x,y)
%
%   drawOrigin() uses default values
%   drawOrigin(scale) sets the length of the 3 arrows
%   drawOrigin(scale, arrowColor) also sets the color of the arrows
%   drawOrigin(scale, arrowColor, sphereRadius) also sets the radius of the sphere

arguments
    scale = 1;
    arrowColor = 'k';
    sphereRadius = 0.1 * scale;
end

% Sphere at the origin
    hold on;
    [xs, ys, zs] = sphere(30);
    surf(xs*sphereRadius, ys*sphereRadius, zs*sphereRadius, ...
    'FaceColor', [0.2 0.2 0.2], ...
    'EdgeColor', 'none', ...
    'FaceLighting', 'gouraud', ...
    'AmbientStrength', 0.5, ...
    'HandleVisibility', 'off');

% Axis remapping: (x,y,z) -> (z,-x,y)
    remap = @(v) [-v(3), -v(1), v(2)];
    origin = [0 0 0];
    xDir = remap([scale, 0, 0]);
    yDir = remap([0, scale, 0]);
    zDir = remap([0, 0, scale]);

% Arrows (X, Y, Z axes, remapped) 
    quiver3(origin(1), origin(2), origin(3), xDir(1), xDir(2), xDir(3), ...
    'Color', arrowColor, 'LineWidth', 2, 'MaxHeadSize', 0.8, ...
    'AutoScale', 'off', 'HandleVisibility', 'off');

    quiver3(origin(1), origin(2), origin(3), yDir(1), yDir(2), yDir(3), ...
    'Color', arrowColor, 'LineWidth', 2, 'MaxHeadSize', 0.8, ...
    'AutoScale', 'off', 'HandleVisibility', 'off');

    quiver3(origin(1), origin(2), origin(3), zDir(1), zDir(2), zDir(3), ...
    'Color', arrowColor, 'LineWidth', 2, 'MaxHeadSize', 0.8, ...
    'AutoScale', 'off', 'HandleVisibility', 'off');

% Labels (remapped)
    xLabelPos = remap([scale*1.1, 0, 0]);
    yLabelPos = remap([0, scale*1.1, 0]);
    zLabelPos = remap([0, 0, scale*1.1]);
    text(xLabelPos(1), xLabelPos(2), xLabelPos(3), 'X', 'Color', arrowColor, 'FontWeight', 'bold');
    text(yLabelPos(1), yLabelPos(2), yLabelPos(3), 'Y', 'Color', arrowColor, 'FontWeight', 'bold');
    text(zLabelPos(1), zLabelPos(2), zLabelPos(3), 'Z', 'Color', arrowColor, 'FontWeight', 'bold');

% 3D lighting (so the sphere reads with volume)
if isempty(findobj(gca, 'Type', 'light'))
        light('Position', [1 1 1], 'Style', 'infinite');
end
    lighting gouraud
    material dull
    hold off;
end