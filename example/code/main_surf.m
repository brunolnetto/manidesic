clear all
clc

syms x y u v zeta eta real;

r = 1;
q = 1;

name = 'Ricatti';
manifold.surf = [u; v; (u + sqrt(u^2 + (1/r)*v^2*q))/((1/r)*v^2)];
manifold.symbs = [];
manifold.nums = [];
manifold.symvars = [u, v];
manifold.metric = @(u, v) u.'*eye(3)*v;

uv0 = [1; 1];
uvf = [-1; -1];

tspan = linspace(0, 1, 20);

% Intrinsic properties of a manifold
manifold = manifold_params(manifold);

sol = get_geodesic(tspan, manifold, uv0, uvf);

span_u = [-2, 2];
span_v = [-2, 2];

n_plot = 50;
u_plot = linspace(span_u(1), span_u(2), n_plot);
v_plot = linspace(span_v(1), span_v(2), n_plot);
[U, V] = meshgrid(u_plot, v_plot);

X = zeros(size(U));
Y = zeros(size(U));
Z = zeros(size(U));

for i = 1:length(u_plot) 
    for j = 1:length(v_plot)
        X(i, j) = subs(manifold.surf(1), [u, v], [U(i, j), V(i, j)]);
        Y(i, j) = subs(manifold.surf(2), [u, v], [U(i, j), V(i, j)]);
        Z(i, j) = subs(manifold.surf(3), [u, v], [U(i, j), V(i, j)]);
    end
end

hfig_surf = figure();
surf(X, Y, Z);
shading flat
hold on; 

% geocurve = zeros(3, length(sol.x));
% geovars = [u; v; zeta; eta];
%  
% for i = 1:length(sol.x)
%     geocurve(:, i) = subs(manifold.surf, geovars, sol.y(:, i));
% end

xlabel('a')
ylabel('b')
zlabel('p')

X = geocurve(1, :)';
Y = geocurve(2, :)';
Z = geocurve(3, :)';

p = plot3(X, Y, Z, 'r');
legend('a', 'b', 'c')

p.LineWidth = 3;

hold off;
axis equal

% Plot properties
plot_info.titles = {'', '', '', ''};
plot_info.xlabels = {'', '', 's', 's'};
plot_info.ylabels = {'u', 'v', '$\dot{u}$', '$\dot{v}$'};
plot_info.grid_size = [2, 2];

hfig_param = my_plot(sol.x, sol.y', plot_info);

saveas(hfig_surf, ['../imgs/', name, '_surf.eps'], 'epsc');
saveas(hfig_param, ['../imgs/', name, '_parametrize.eps'], 'epsc');