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
lambda = boundedges(p,t);

%Define element properties 
a = [1 0;0 1];
f = 0;
elements = avengers(a, f, p, t, lambda);

%Step 3, 4, and 5: create local stiffness matrices, force vectors, and 
%boundary conditions; assemble global siffness matrices, force vectors, and
%boundary conditions
[K,F] = assembler(elements, t);

%Create Boundary Condition matrix
U_0 = 1;
Q = zeros(max(max(t)),1);
for k = 1:size(p,1)
    if p(k,1) == -4 && p(k,2) > 0 %side face
        for i = 1:size(lambda,1)
            for j = 1:2
                if lambda(i,j) == k
                    Q(lambda(i,j),1) = U_0*p(k,2)+Q(lambda(i,j),1);
                end
            end
        end
    end
    if p(k,1) == -4 && p(k,2) < 0
        for i = 1:size(lambda,1)
            for j = 1:2
                if lambda(i,j) == k
                    Q(lambda(i,j),1) = -U_0*p(k,2)+Q(lambda(i,j),1);
                end
            end
        end
    end
	if p(k,2) == -2 %upper face
        for i = 1:size(lambda,1)
            for j = 1:2
                if lambda(i,j) == k
                    Q(lambda(i,j),1) = 2*U_0+Q(lambda(i,j),1);
                end
            end
        end
    end
	if p(k,2) == 2 %lower face
        for i = 1:size(lambda,1)
            for j = 1:2
                if lambda(i,j) == k
                    Q(lambda(i,j),1) = 2*U_0+Q(lambda(i,j),1);
                end
            end
        end
    end
    
end


%Step 6:
%Solve matrix equation at global nodes
% U = K\(F+Q);

%Interpolate between nodes


%Setp 7:
%Post-processing of results

%Creation of streamlines


%Ploting 2D graph