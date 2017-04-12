function elements_array = avengers(a, f, p, t )
%AVENGERS Constructs the object array of elements for FEM.
%   Builds the element array to be used in assembling the global stiffness
%   matrix (AVENGERS ASSEMBLE!)

for i = 1:size(t)
    elements_array(i) = Element2D(a,f, i, p, t);
    stiffness_matrix(elements_array(i));
    force_vector(elements_array(i));
end

end %end avengers

