% Written by Malcolm Forbes & Jay Park 
% Analytical Solution Streamlines

U_i = 1;            % Ambient velocity
a = 1;               % cylinder radius

c = -a*4;            % starting coordinate (x)
b = a*4;            % ending coordinate (x)
d = -2;             % starting coordinate (y)
e = 2;              % ending coordinate (y)

n = a*20;            % number of intervals (step size in grid)

[x,y] = meshgrid([c:(b-c)/n:b],[d:(e-d)/n:e]'); % Create mesh

for i = 1:length(x)
    for k = 1:length(x);
        f = sqrt(x(i,k).^2 + y(i,k).^2);
        if f < a
            x(i,k) = 0;
            y(i,k) = 0;
        end
    end
end

% Definition of polar variables
r = sqrt(x.^2+y.^2);
theta = atan2(y,x);                               

%% Creation of Streamline function 
z = U_i.*r.*(1-a^2./r.^2).*sin(theta);

%% Creation of Figure

m = 100; 
s = ones(1,m+1)*a;
t = [0:2*pi/m:2*pi];

%% Streamline plot

for i=1:2
    for j =1:21
        if i == 1
            z(i,j) = -2;
        elseif i == 2
            z(21,j) = 2;
        end
    end
end            

contour(x,y,z,20);
hold on 
polar(t,s,'-k');
title('Stream Lines');
grid off