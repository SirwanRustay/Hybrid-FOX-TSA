function [fitness] = spring_design(x)
    % Define the parameters for the spring design problem
    D = x(1);
    d = x(2);
    N = x(3);
    
    % Objective function
    fitness = (N + 2) * d * D^2;
    
    % Constraints
    g1 = 1 - ((D^3 * N) / (71785 * d^4));
    g2 = ((4 * D^2 - D * d) / (12566 * (D * d^3 - d^4))) + 1 / (5108 * d^2) - 1;
    g3 = 1 - (140.45 * d / (D^2 * N));
    g4 = D + d - 3;
    
    penalty = 0;
    if g1 > 0
        penalty = penalty + g1;
    end
    if g2 > 0
        penalty = penalty + g2;
    end
    if g3 > 0
        penalty = penalty + g3;
    end
    if g4 < 0
        penalty = penalty + abs(g4);
    end
    
    fitness = fitness + penalty * 10^5;
end
