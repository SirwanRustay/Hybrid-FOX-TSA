function [best_solution, best_fitness, history] = GWO_func(fhd, X, pop_size, max_iter, lb, ub, dim)
    % Initialize the positions of alpha, beta, and delta
    Alpha_pos = zeros(1, dim);  % Position of the best wolf (alpha)
    Beta_pos = zeros(1, dim);   % Position of the second-best wolf (beta)
    Delta_pos = zeros(1, dim);  % Position of the third-best wolf (delta)
    
    % Initialize the fitness of alpha, beta, and delta
    Alpha_score = inf;  % Fitness of the best wolf (alpha)
    Beta_score = inf;   % Fitness of the second-best wolf (beta)
    Delta_score = inf;  % Fitness of the third-best wolf (delta)

    % Initialize population
    X = initialization(pop_size, dim, ub, lb);
    fitness = zeros(pop_size, 1);

    % Store the convergence history
    history = zeros(max_iter, 1);

    % Main loop
    for iter = 1:max_iter
        for i = 1:pop_size
            % Calculate the fitness of the current solution
            fitness(i) = fhd(X(i, :));
            
            % Update Alpha, Beta, and Delta
            if fitness(i) < Alpha_score
                Alpha_score = fitness(i);  % Update alpha
                Alpha_pos = X(i, :);
            elseif fitness(i) < Beta_score
                Beta_score = fitness(i);  % Update beta
                Beta_pos = X(i, :);
            elseif fitness(i) < Delta_score
                Delta_score = fitness(i);  % Update delta
                Delta_pos = X(i, :);
            end
        end

        % Update the positions of the wolves
        a = 2 - iter * (2 / max_iter);  % a decreases linearly from 2 to 0
        
        for i = 1:pop_size
            for j = 1:dim
                % Calculate A1, A2, A3, C1, C2, C3
                r1 = rand(); r2 = rand();
                A1 = 2 * a * r1 - a;
                C1 = 2 * r2;
                
                r1 = rand(); r2 = rand();
                A2 = 2 * a * r1 - a;
                C2 = 2 * r2;
                
                r1 = rand(); r2 = rand();
                A3 = 2 * a * r1 - a;
                C3 = 2 * r2;
                
                % Calculate the three positions
                D_alpha = abs(C1 * Alpha_pos(j) - X(i, j));
                X1 = Alpha_pos(j) - A1 * D_alpha;
                
                D_beta = abs(C2 * Beta_pos(j) - X(i, j));
                X2 = Beta_pos(j) - A2 * D_beta;
                
                D_delta = abs(C3 * Delta_pos(j) - X(i, j));
                X3 = Delta_pos(j) - A3 * D_delta;
                
                % Update the position of the current wolf
                X(i, j) = (X1 + X2 + X3) / 3;
            end
            
            % Ensure that wolves stay within the search space
            X(i, :) = max(X(i, :), lb);
            X(i, :) = min(X(i, :), ub);
        end

        % Store the best fitness value in this iteration
        history(iter) = Alpha_score;

        % Optional: Display progress
        fprintf('Iteration %d: Best Fitness = %f\n', iter, Alpha_score);
    end

    % Return the best solution found and its fitness
    best_solution = Alpha_pos;
    best_fitness = Alpha_score;  % Return the best fitness value
end
