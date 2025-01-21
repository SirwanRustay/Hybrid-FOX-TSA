Cite as :
Sirwan A. Aula, Tarik A. Rashid. (2024). FOX-TSA hybrid algorithm: Advancing for superior predictive accuracy in tourism-driven multi-layer perceptron models, Systems and Soft Computing, Volume 6, https://doi.org/10.1016/j.sasc.2024.200178 

Sirwan A. Aula, Tarik A. Rashid. (2024). Foxtsage vs. Adam: Revolution or Evolution in Optimization?.Arxiv 
https://doi.org/10.48550/arXiv.2412.17855

Sirwan A. Aula, Tarik A. Rashid.(2025). FOX-TSA: Navigating Complex Search Spaces and Superior Performance in Benchmark and Real-World Optimization Problems, Ain Shams Engineering Journal, Vol 16, Issue 1,https://doi.org/10.1016/j.asej.2024.103185



function [Best_score, Best_pos, convergence_curve, all_scores] = Hybrid_FOX_TSA_func(pop_size, max_iter, lb, ub, dim, fobj)
    Best_pos = zeros(1, dim);
    Best_score = inf; % Change this to -inf for maximization problems

    % Initialize the positions of search agents using the corrected initialization
    X = initialization(pop_size, dim, ub, lb);  % Initialize population within bounds

    % Initialize variables
    Distance_Fox_Rat = zeros(pop_size, dim);   
    convergence_curve = zeros(1, max_iter);
    all_scores = zeros(pop_size, max_iter);

    l = 0; % Loop counter
    c1 = 0.18;  % Constant parameter for the FOX part
    c2 = 0.82;  % Constant parameter for the FOX part

    % TSA parameters
    low = ceil(0.1 * pop_size);  % Minimum number of seeds
    high = ceil(0.25 * pop_size);  % Maximum number of seeds
    ST = 0.1;  % Threshold value for TSA

    % Main loop
    while l < max_iter
        for i = 1:pop_size  
            % Return back the search agents that go beyond the boundaries of the search space
            Flag4ub = X(i, :) > ub;
            Flag4lb = X(i, :) < lb;
            X(i, :) = (X(i, :) .* (~(Flag4ub + Flag4lb))) + ub .* Flag4ub + lb .* Flag4lb;

            % Calculate objective function for each search agent
            fitness = fobj(X(i, :));  % Passing row vector to fobj

            % Store all fitness scores
            all_scores(i, l + 1) = fitness;

            % Update the best position
            if fitness < Best_score
                Best_score = fitness; % Update best score
                Best_pos = X(i, :);   % Update best position
            end
        end
        
        % Store best fitness for this iteration
        convergence_curve(l + 1) = Best_score;
        
        a = 2 * (1 - (l / max_iter));  % Decreasing factor over time
        Jump = 0;

        % FOX part: Update the positions
        for i = 1:pop_size  
            r = rand;
            p = rand;
            if r >= 0.5
                if p > 0.18
                    Time = rand(1, dim);
                    sps = Best_pos ./ Time;
                    Distance_S_Travel = sps .* Time;
                    Distance_Fox_Rat(i, :) = 0.5 * Distance_S_Travel;
                    tt = sum(Time) / dim;
                    t = tt / 2;
                    Jump = 0.5 * 9.81 * t^2;
                    X(i, :) = Distance_Fox_Rat(i, :) .* Jump * c1;
                else
                    Time = rand(1, dim);
                    sps = Best_pos ./ Time;
                    Distance_S_Travel = sps .* Time;
                    Distance_Fox_Rat(i, :) = 0.5 * Distance_S_Travel;
                    tt = sum(Time) / dim;
                    t = tt / 2;
                    Jump = 0.5 * 9.81 * t^2;
                    X(i, :) = Distance_Fox_Rat(i, :) .* Jump * c2;
                end
            else
                % TSA Seed Production Phase
                ns = low + randi(high - low + 1) - 1;
                seeds = zeros(ns, dim);
                objs = zeros(1, ns);
                
                for j = 1:ns
                    rand_idx = fix(rand * pop_size) + 1;  
                    while i == rand_idx
                        rand_idx = fix(rand * pop_size) + 1;  
                    end
                    % Seed generation
                    for d = 1:dim
                        if rand < ST
                            seeds(j, d) = X(i, d) + (Best_pos(d) - X(rand_idx, d)) * (rand - 0.5) * 2;
                        else
                            seeds(j, d) = X(i, d) + (X(rand_idx, d) - X(i, d)) * (rand - 0.5) * 2;
                        end
                    end
                    % Boundary checking
                    Flag4ub = seeds(j, :) > ub;
                    Flag4lb = seeds(j, :) < lb;
                    seeds(j, :) = (seeds(j, :) .* (~(Flag4ub + Flag4lb))) + ub .* Flag4ub + lb .* Flag4lb;
                end
                
                % Evaluate fitness of the seeds
                objs = arrayfun(@(idx) fobj(seeds(idx, :)), 1:ns);
                [val, indis] = min(objs);
                if objs(indis) < fobj(X(i, :))
                    X(i, :) = seeds(indis, :);
                end
            end
        end
        l = l + 1;
        
        % Optionally, print or log intermediate results
        fprintf('Hybrid FOX-TSA Iteration %d: Best Fitness = %f\n', l, Best_score);
    end
end
