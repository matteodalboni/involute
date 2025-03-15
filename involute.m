clear; close all; clc;

%% Data
r = 1;                           % Radius of pitch circle
z = 20;                          % Number of teeth
alpha = deg2rad(20);             % Pressure angle
x = 0.2;                         % Profile shift coefficient
phi = linspace(-pi/6, pi/6, 50); % Vector of cutter rotations

%% Fundamental parameters of the gear
m = 2*r/z;                       % Module
add = (1    + x)*m;              % Addendum
ded = (1.25 - x)*m;              % Dedendum
p = pi*m;                        % Reference pitch
rb = r*cos(alpha);               % Radius of base circle
rd = r - ded;                    % Radius of dedendum circle
ra = r + add;                    % Radius of addendum circle

%% Gear generation by envelope
tooth = [
    - 1.25*m*tan(alpha) - p/4 + 1i*1.25*m
    + 1.25*m*tan(alpha) - p/4 - 1i*1.25*m
    - 1.25*m*tan(alpha) + p/4 - 1i*1.25*m
    + 1.25*m*tan(alpha) + p/4 + 1i*1.25*m
    ].' + 1i*x*m;
cutter = [tooth - p, tooth, tooth + p];
invol = exp(1i.*phi(:)).*r.*phi(:) - r.*sin(phi(:)) + r.*1i.*cos(phi(:));
envel = (exp(1i.*phi(:)).*repmat(cutter, length(phi(:)), 1) + invol).';
rot = repmat(exp(1i.*linspace(0, 2*pi, z + 1)), size(envel, 2), 1);
envels = repmat(rot(:).', size(envel, 1), 1).*repmat(envel, 1, z + 1);

%% Figures
figure
patch(real(envel), imag(envel), 'k', 'FaceAlpha', 0, 'EdgeColor', 'k');
axis equal; box on;

figure
patch(real(envels), imag(envels), 'k', 'FaceAlpha', 0, 'EdgeColor', 'k');
axis equal; hold on; box on; plot_circles(r, rb, rd, ra, 1e3);

figure
rectangle('Position', [-ra, -ra, 2*ra, 2*ra], 'Curvature', [1, 1], ...
    'FaceColor', 'b', 'EdgeColor', 'none');
patch(real(envels), imag(envels), 'w', 'EdgeColor', 'none');
axis equal; hold on; box on; plot_circles(r, rb, rd, ra, 1e3);

function plot_circles(r, rb, rd, ra, np)
    theta = linspace(0, 2*pi, np);
    plot(rd.*cos(theta), rd.*sin(theta), 'k-' )
    plot(rb.*cos(theta), rb.*sin(theta), 'k--' )
    plot(r.*cos(theta), r.*sin(theta), 'k-.')
    plot(ra.*cos(theta), ra.*sin(theta), 'k-' )
end