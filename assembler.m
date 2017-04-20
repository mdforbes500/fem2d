function [K, K_e, F_e] = assembler( element_array, t )
%ASSEMBLER Assembles the global stiffness matrix for FEM.
%   Builds cells of the elemental stiffness matrices and elemental force 
%   vectors, then assembles them through the nodal equivalence principle.

%Constructs cells of elemental stiffness matrices and force vectors
N = size(element_array);
K_e = cell(1,N(2));
F_e = cell(1,N(2));
for i = 1:N(2)
    K_e{i} = stiffness_matrix(element_array(i));
    F_e{i} = force_vector(element_array(i));
end

%Assembles stiffness matrix
K = zeros(max(max(t)),max(max(t)));

for i = 1:max(max(t))
    for j = 1:max(max(t))
        for e = 1:size(t,1)
            for l = 1:size(t,2)
                if t(e,l) == j
                    K(i,j) = K_e{1,e}(l,l)+K(i,j);
                end
            end
        end
    end
end
%Assembles force vector

%Assemble boundary condition vector

end

