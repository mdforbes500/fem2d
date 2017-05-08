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
omega = @(p) ddiff(drectangle(p,-4,4,-2,2),dcircle(p,0,0,1));
%omega = @(p) drectangle(p, -1,1,-1,1);

%Step 2:
%Discretize Domain

%Mesh Refinement Function:
%creates a larger element size away from the edge of the circlular cutout,
%and a smaller element size around the hole
mesh_refine = @(p) 0.1+0.25*dcircle(p,0,0,1);
%mesh_refine = @huniform;

%Creation and display of initial mesh before manipulation:
[p,t] = distmesh2d(omega,mesh_refine, 0.09, [-4,-2;4,2],[-4,-2;-4,2;4,-2;4,2]);

%Define element properties 
a = [1 1;1 1];
f = 1;
elements = avengers(a, f, p, t, lambda);

%Step 3, 4, and 5: create local stiffness matrices, force vectors, and 
%boundary conditions; assemble global siffness matrices, force vectors, and
%boundary conditions
[K,F] = assembler(elements, t);

%Create Boundary Condition matrix
lambda = boundedges(p,t);
innerBC = 0;
outerBC = 2*U_0;
Q = zeros(size(t,1),1);
for i = 1:size(lambda,1)
    


%Step 6:
%Solve matrix equation at global nodes
U = K\(F+Q);

%Interpolate between nodes


%Setp 7:
%Post-processing of results

%Creation of streamlines


%Ploting 2D graph