function [fitness] = welding_beam_design(x)
    % Define the parameters for the welding beam design problem
    b = x(1);
    h = x(2);
    L = x(3);
    delta_max = x(4);
    
    % Objective function
    fitness = 1.10471 * b^2 * L + 0.04811 * h * delta_max * (14 + L);
    
    % Constraints
    g1 = delta_max - (6000 / (b * h^2));
    g2 = L - 5;
    g3 = b - 5;
    g4 = 0.125 - b;
    g5 = h - 5;
    g6 = 0.125 - h;
    
    penalty = 0;
    if g1 > 0
        penalty = penalty + g1;
    end
    if g2 < 0
        penalty = penalty + abs(g2);
    end
    if g3 < 0
        penalty = penalty + abs(g3);
    end
    if g4 > 0
        penalty = penalty + g4;
    end
    if g5 < 0
        penalty = penalty + abs(g5);
    end
    if g6 > 0
        penalty = penalty + g6;
    end
    
    fitness = fitness + penalty * 10^5;
end
