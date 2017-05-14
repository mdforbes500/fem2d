% 2D Finite Element Main Script

%NOTE: This script uses the distmesh package (under the GNU licesnse) created
%by Pers Olaf-Persson, MIT. Per the GNU license, this script is also
%GNU. In addition, the distmesh package is functionally organized, not
%class organized, and its subfolder must be added to the user's path to
%run.

clc
clear
close all

%Step 1:
%Define domain

%omega is a circle with a hole in it
omega = @(p) ddiff(drectangle(p,0,4,0,2),dcircle(p,4,0,1));

%Step 2:
%Discretize Domain

%Mesh Refinement Function:
%creates a larger element size away from the edge of the circlular cutout,
%and a smaller element size around the hole
mesh_refine = @(p) 0.1+0.05*dcircle(p,4,0,1);
%mesh_refine = @huniform;

%Creation and display of initial mesh before manipulation:
[p,t] = distmesh2d(omega,mesh_refine, 0.1, [0,0;4,2],[0,0;0,2;3,0;4,1;4,2]);
[p,t] = fixmesh(p,t);
lambda = boundedges(p,t);

%Define element properties 
a = [1 0;0 1];
f = 0;
elements = avengers(a, f, p, t, lambda);

%Step 3, 4, and 5: create local stiffness matrices, force vectors, and 
%boundary conditions; assemble global siffness matrices, force vectors, and
%boundary conditions
[K,F] = assembler(elements, t);

%Create Boundary Condition matrix for natural BC
U_0 = 1;
Q = zeros(max(max(t)),1);
for i = 1:size(lambda,1)
    for j = 1:size(lambda,2)
        if (p(lambda(i,j),1) >= -0.00001 && p(lambda(i,j),1) <= 0.00001)
            Q(lambda(i,j),1) = U_0;
        if (p(lambda(i,j),1 >= 7.9998 && p(lambda(i,j),1) <= 8.0001)
            Q(lambda(i,j),1) = -U_0;
        end
    end
end

%Since the streamline is specified at the top and bottom of the channel,
%across the surface of the cylinder, and along the inlet of the channel;
%these should be removed for computation of U (i.e., the submatrix of U).
K_copy = K;
F_copy = F + Q;

array = [];
counter = 1;
for i = 1:size(lambda,1)
    for j = 1:size(lambda,2)
        if ~((p(lambda(i,j),1) >= -0.00001 && p(lambda(i,j),1) <= 0.00001) && ((p(lambda(i,j),2) ~= 0) || (p(lambda(i,j),2) ~= 2))) && ~((p(lambda(i,j),1) >= 7.99998 && p(lambda(i,j),1) <= 8.00001) && ((p(lambda(i,j),2) ~= 0) || (p(lambda(i,j),2) ~= 2)))
            array(end +1,1) = lambda(i,j);
        end
        if (p(lambda(i,j),1) == 8 && p(lambda(i,j),2) == 1) || (p(lambda(i,j),1) == 8 && p(lambda(i,j),2) == 2)
            array(end+1,1) = lambda(i,j);
        end
    end
end

array = unique(array);
K_copy(:,array) = [];
K_copy(array,:) = [];
F_copy(array) = [];

%Step 6:
%Solve matrix equation at global nodes not specified as essential BC
U_copy = inv(K_copy)*F_copy;

%Interpolate between nodes

%Step 7:
%Post-processing of results

%Creation of streamlines


%Ploting 2D graph