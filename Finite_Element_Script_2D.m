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
%omega = @(p) drectangle(p, -1,1,-1,1);

%Step 2:
%Discretize Domain

%Mesh Refinement Function:
%creates a larger element size away from the edge of the circlular cutout,
%and a smaller element size around the hole
mesh_refine = @(p) 0.1+0.25*dcircle(p,4,0,1);
%mesh_refine = @huniform;

%Creation and display of initial mesh before manipulation:
[p,t] = distmesh2d(omega,mesh_refine, 0.1, [0,0;4,2],[0,0;0,2;3,0;4,1;4,2]);
lambda = boundedges(p,t);

%Define element properties 
a = [1 0;0 1];
f = 1;
elements = avengers(a, f, p, t, lambda);

%Step 3, 4, and 5: create local stiffness matrices, force vectors, and 
%boundary conditions; assemble global siffness matrices, force vectors, and
%boundary conditions
[K,F] = assembler(elements, t);

%Create Boundary Condition matrix
U_0 = 1;
Q = zeros(max(max(t)),1);
% for i = 1:size(lambda,1)
%     for j = 1:size(lambda,2)
%         if (p(lambda(i,j),1) <= -3.9998 && p(lambda(i,j),1) >= -4.0001) || (abs(p(lambda(i,j),2)) <= 2.0001 && abs(p(lambda(i,j),2)) >= 1.9998)
%             Q(lambda(i,j),1) = abs(p(lambda(i,j),2)*U_0);
%         end
%     end
% end

%Step 6:
%Solve matrix equation at global nodes
%Since the streamline is specified at the top and bottom of the channel,
%across the surface of the cylinder, and along the inlet of the channel;
%these should be removed for computation of U (i.e., the submatrix of U).
K_copy = K;
F_copy = F + Q;

array = [];
counter = 1;
for i = 1:size(lambda,1)
    for j = 1:size(lambda,2)
        if ~(p(lambda(i,j),1)<4.0001 && p(lambda(i,j),1)>3.9997) && (p(lambda(i,j),2)~=1 && p(lambda(i,j),2)~=2)
            array(end +1) = lambda(i,j);
        end
    end
end
array = unique(array);
K_copy(:,array) = [];
K_copy(array,:) = [];
F_copy(array) = [];

U_copy = K_copy\F_copy;

%Interpolate between nodes

%Setp 7:
%Post-processing of results
%u = [p(:,1) p(:,2) U(:,1)];



%Creation of streamlines


%Ploting 2D graph