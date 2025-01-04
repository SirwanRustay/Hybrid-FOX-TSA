function [best_fitness, convergence_curve] = TSA_func(fhd, X, pop_size, iter_max, Xmin, Xmax, D)

    % Initialize population and other parameters
    trees = X; % Initial population (position of trees)
    fitness = zeros(pop_size, 1); % Fitness values for population
    convergence_curve = zeros(1, iter_max); % To store the best fitness at each iteration

    % Define the upper and lower bounds as vectors of size D
    lb = Xmin * ones(1, D); % Lower bound (vector)
    ub = Xmax * ones(1, D); % Upper bound (vector)

    % Evaluate initial population fitness
    for i = 1:pop_size
        fitness(i) = fhd(trees(i, :)); % Evaluate each tree's fitness
    end
    
    % Find the initial best tree (seed) and best fitness
    [best_fitness, best_index] = min(fitness);
    best_tree = trees(best_index, :);

    % Main optimization loop
    for iter = 1:iter_max
        for i = 1:pop_size
            % Update the position of each tree
            for d = 1:D
                % TSA position update mechanism (simplified version)
                r = rand(); % Random number
                if r < 0.5
                    trees(i, d) = best_tree(d) + randn(); % Move towards the best tree
                else
                    trees(i, d) = trees(i, d) + randn(); % Random movement
                end

                % Ensure the updated tree position stays within bounds
                trees(i, d) = max(min(trees(i, d), ub(d)), lb(d)); % Correct the bounds
            end

            % Evaluate the new fitness of the updated tree
            new_fitness = fhd(trees(i, :));

            % Replace if the new position is better
            if new_fitness < fitness(i)
                fitness(i) = new_fitness;
                if new_fitness < best_fitness
                    best_fitness = new_fitness;
                    best_tree = trees(i, :);
                end
            end
        end

        % Store the best fitness at each iteration
        convergence_curve(iter) = best_fitness;
    end
end
