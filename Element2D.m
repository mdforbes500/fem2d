classdef Element2D
    %ELEMENT2D A class modeling a 2D finite element (FEA).
    %   Models a triangular finite element in 2-dimensions. Contains
    %   element properties: a_a, c_e, f_e, and h_e. Also contains a method 
    %   for generating an elemental stiffness matrix, K_e, from the 
    %   elemental properties and storing it as a dependent property. In
    %   additon, the elemental force vector, f_e, is generated using a 
    %   method and stored, similar to K_e.
    
    properties
        a_e
        c_e
        h_e
        d1_e
        d2_e
        d3_e        
    end
    
    properties (Dependent)
        K_e
        f_e
    end
    
    methods
        function element = Element2D(a, c, h, n, p, t)
            %CONSTRUCTOR Constructor for element class.
            %   Assigns parameters to class properties.
            element.a_e = a;
            element.c_e = c;
            element.h_e = h;
            
            %Positions of each node as a coordinate list
            %Node 1
            element.d1_e = [p(t(n,1),1), p(t(n,1),2)];
            %Node 2
            element.d2_e = [p(t(n,2),1), p(t(n,2),2)];
            %Node 3
            element.d3_e = [p(t(n,3),1), p(t(n,3),2)];
        end
        
        function K_e = stiffness_matrix(element)
            %STIFFNESS_MATRIX Generates stiffness matrix for element class.
            %   
            
            %Create side lengths of triangle from distance formula
            sideA = sqrt((element.d1_e(1) - element.d2_e(1))^2 + (element.d1_e(2) - element.d2_e(2))^2);
            sideB = sqrt((element.d2_e(1) - element.d3_e(1))^2 + (element.d2_e(2) - element.d3_e(2))^2);
            sideC = sqrt((element.d3_e(1) - element.d1_e(1))^2 + (element.d3_e(2) - element.d1_e(2))^2);
            
            %Create area of triangle from Heron's formula
            half_peri = (sideA+sideB+sideC)/2;
            area = sqrt(half_peri*(half_peri-sideA)*(half_peri-sideB)*(half_peri-sideC));
            
            %Using area, create elemental stiffness matrix
            
        end
    end
    
end

