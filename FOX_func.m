function [Best_score, Best_pos, convergence_curve] = FOX_func(SearchAgents_no, Max_iter, lb, ub, dim, fobj)
    % Initialization
    Best_pos = zeros(1, dim);
    Best_score = inf; % Set for minimization problems
    
    % Initialize the positions of search agents
    X = initialization(SearchAgents_no, dim, ub, lb);
    convergence_curve = zeros(1, Max_iter);

    % FOX parameters
    c1 = 0.18;  % range of c1 is [0, 0.18]
    c2 = 0.82;  % range of c2 is [0.19, 1]
    
    % Initialize velocity (if FOX uses some movement strategy, otherwise ignore)
    for iter = 1:Max_iter
        % Evaluate each agent's fitness
        for i = 1:SearchAgents_no
            % Return back the search agents that go beyond the boundaries of the search space
            Flag4ub = X(i, :) > ub;
            Flag4lb = X(i, :) < lb;
            X(i, :) = (X(i, :) .* (~(Flag4ub + Flag4lb))) + ub .* Flag4ub + lb .* Flag4lb;

            % Calculate fitness
            fitness = fobj(X(i, :));
            
            % Update Alpha (Best Score)
            if fitness < Best_score
                Best_score = fitness;
                Best_pos = X(i, :);
            end
        end
        
        % Update position of agents based on FOX dynamics
        for i = 1:SearchAgents_no
            r = rand;
            p = rand;
            if r >= 0.5
                if p > 0.18
                    Time = rand(1, dim);
                    sps = Best_pos ./ Time;
                    Distance_S_Travel = sps .* Time;
                    tt = sum(Time) / dim;
                    t = tt / 2;
                    Jump = 0.5 * 9.81 * t^2;
                    X(i, :) = Distance_S_Travel .* Jump * c1;
                else
                    Time = rand(1, dim);
                    sps = Best_pos ./ Time;
                    Distance_S_Travel = sps .* Time;
                    tt = sum(Time) / dim;
                    t = tt / 2;
                    Jump = 0.5 * 9.81 * t^2;
                    X(i, :) = Distance_S_Travel .* Jump * c2;
                end
            else
                % Exploration step
                X(i, :) = Best_pos + randn(1, dim) .* (2 * (1 - iter / Max_iter));
            end
        end
        
        % Store the best fitness at this iteration
        convergence_curve(iter) = Best_score;
        
        % Optionally, print the iteration result
        fprintf('FOX Iteration %d: Best Fitness = %f\n', iter, Best_score);
    end
end
