function [best_fitness, history] = PSO_func(fhd, X, pop_size, max_iter, lb, ub, dim)
    % Parameters
    c1 = 1.5;  % Cognitive coefficient
    c2 = 2.0;  % Social coefficient
    w = 0.5;   % Inertia weight
    v_max = (ub - lb) * 0.1;  % Velocity limit

    % Initialize velocity
    V = zeros(pop_size, dim);
    
    % Initialize personal bests and global best
    pbest = X;
    pbest_fitness = arrayfun(@(i) fhd(X(i,:)), 1:pop_size);
    [global_best_fitness, best_idx] = min(pbest_fitness);
    global_best = X(best_idx, :);
    
    history = zeros(1, max_iter);  % Ensure it's a row vector of size 1-by-max_iter
    
    % PSO Main Loop
    for iter = 1:max_iter
        for i = 1:pop_size
            % Update velocity
            V(i, :) = w * V(i, :) + c1 * rand * (pbest(i, :) - X(i, :)) + c2 * rand * (global_best - X(i, :));
            V(i, :) = max(min(V(i, :), v_max), -v_max);  % Clamp velocity

            % Update position
            X(i, :) = X(i, :) + V(i, :);
            X(i, :) = max(min(X(i, :), ub), lb);  % Clamp positions
            
            % Evaluate new solution
            fitness = fhd(X(i, :));
            
            % Update personal best
            if fitness < pbest_fitness(i)
                pbest(i, :) = X(i, :);
                pbest_fitness(i) = fitness;
            end
            
            % Update global best
            if fitness < global_best_fitness
                global_best_fitness = fitness;
                global_best = X(i, :);
            end
        end
        
        % Store global best fitness at this iteration
        history(iter) = global_best_fitness;
        
        % Optionally, print or plot intermediate results
        fprintf('Iteration %d: Best Fitness = %f\n', iter, global_best_fitness);
    end
    
    % Return the best fitness (a scalar) and the history of best fitnesses (a 1-by-max_iter vector)
    best_fitness = global_best_fitness;
end
