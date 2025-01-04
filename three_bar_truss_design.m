function [fitness] = three_bar_truss_design(x)
    % Define the parameters for the three-bar truss design problem
    A1 = x(1);
    A2 = x(2);
    A3 = x(3);
    
    % Objective function
    fitness = A1 + A2 + A3;
    
    % Constraints
    g1 = 10 - (sqrt((A1 + A3)^2 + A2^2) / A1);
    g2 = 10 - (sqrt((A1 + A3)^2 + A2^2) / A2);
    
    penalty = 0;
    if g1 > 0
        penalty = penalty + g1;
    end
    if g2 > 0
        penalty = penalty + g2;
    end
    
    fitness = fitness + penalty * 10^5;
end
