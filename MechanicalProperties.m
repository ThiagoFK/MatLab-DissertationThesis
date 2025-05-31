% Directions and materials
directions = {'RD', 'DD', 'TD'};
materials = {'1.4512', '1.4509'};
colors = lines(2);  % Colors for materials

% Test data
sut_14512 = [399.27-3.48, 399.27, 399.27+3.48;
             394.85-18.35, 394.85, 394.85+18.35;
             398.17-8.15, 398.17, 398.17+8.15];

sut_14509 = [462.33-6.37, 462.33, 462.33+6.37;
             471.25-22.36, 471.25, 471.25+22.36;
             480.86-6.82, 480.86, 480.86+6.82];

% EN 10088-1 ultimate tensile strength limits (example)
limits_14512 = [380, 560];  % [min, max] for 1.4512
limits_14509 = [430, 630];  % [min, max] for 1.4509

% Plot setup
x_base = [1, 2, 3];  % RD, DD, TD
offset = 0.15;

figure; hold on;

% Plot for 1.4512 (left boxplots)
for i = 1:3
    boxchart(repmat(x_base(i) - offset, 3, 1), sut_14512(i,:)', ...
        'BoxFaceColor', colors(1,:), 'BoxFaceAlpha', 0.6);
end

% Plot for 1.4509 (right boxplots)
for i = 1:3
    boxchart(repmat(x_base(i) + offset, 3, 1), sut_14509(i,:)', ...
        'BoxFaceColor', colors(2,:), 'BoxFaceAlpha', 0.6);
end

% Draw full-width limit lines for 1.4512 (red)
h1_min = plot(xlim, [limits_14512(1) limits_14512(1)], 'Color', colors(1,:), 'LineStyle', '--', 'LineWidth', 1);
h1_max = plot(xlim, [limits_14512(2) limits_14512(2)], 'Color', colors(1,:), 'LineStyle', '--', 'LineWidth', 1);

% Draw full-width limit lines for 1.4509 (blue)
h2_min = plot(xlim, [limits_14509(1) limits_14509(1)], 'Color', colors(2,:), 'LineStyle', '--', 'LineWidth', 1);
h2_max = plot(xlim, [limits_14509(2) limits_14509(2)], 'Color', colors(2,:), 'LineStyle', '--', 'LineWidth', 1);

% Add labels above the limit lines (x position near left side)
ylims = ylim;
x_text = xlim;
x_text_pos = x_text(1) + 0.05*(x_text(2)-x_text(1)); % small offset from left edge

text(x_text_pos, limits_14512(2)+5, 'EN 10088 Max 1.4512', 'Color', colors(1,:), 'FontWeight', 'bold')
text(x_text_pos, limits_14512(1)-10, 'EN 10088 Min 1.4512', 'Color', colors(1,:), 'FontWeight', 'bold')

text(x_text_pos, limits_14509(2)+5, 'EN 10088 Max 1.4509', 'Color', colors(2,:), 'FontWeight', 'bold')
text(x_text_pos, limits_14509(1)-10, 'EN 10088 Min 1.4509', 'Color', colors(2,:), 'FontWeight', 'bold')

% Axis settings
xticks(x_base)
xticklabels(directions)
ylabel('S_{ut} [MPa]')
title('Ultimate Tensile Strength by Direction')
legend(materials, 'Location', 'northwest')
grid on; box on;

hold off;
