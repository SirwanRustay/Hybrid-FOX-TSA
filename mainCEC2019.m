% Hybrid FOX-TSA vs other algorithms (PSO, GWO, TSA, FOX) on CEC Functions
clear; clc; close all;

% Parameters
D = 10;  % Dimensionality of the problem
Xmin = -100;
Xmax = 100;
pop_sizes = [10, 20, 50]; % Population sizes for sensitivity analysis
iterations = [50, 100, 200]; % Iteration counts for sensitivity analysis
runs = 10;  % Number of runs for each algorithm
num_functions = 10; % We are testing CEC1 to CEC10

% Initialize storage for results
results = {}; % For storing results in Excel later

% Function handlers for CEC functions
fhd = {@cec01, @cec02, @cec03, @cec04, @cec05, @cec06, @cec07, @cec08, @cec09, @cec10};

% Loop over each test function
for func_num = 1:num_functions
    disp(['Running CEC Function ', num2str(func_num)]);
    
    % Loop over different population sizes and iteration settings
    for pop_size = pop_sizes
        for iter_max = iterations
            
            % Initialize result tracking variables for each algorithm
            PSO_best_vals = zeros(runs, iter_max);
            TSA_best_vals = zeros(runs, iter_max);
            GWO_best_vals = zeros(runs, iter_max);
            FOX_best_vals = zeros(runs, iter_max);
            Hybrid_FOX_TSA_best_vals = zeros(runs, iter_max);
            time_results = zeros(runs, 5); % To store time for each algorithm per run
            
            % Run multiple runs to gather average results
            for run = 1:runs
                X = Xmin + rand(pop_size, D) * (Xmax - Xmin); % Initialize population
                
                % PSO
                tic;
                [PSO_gbest, PSO_history] = PSO_func(fhd{func_num}, X, pop_size, iter_max, Xmin, Xmax, D);
                time_results(run, 1) = toc;
                PSO_best_vals(run, :) = PSO_history;

                % TSA
                tic;
                [TSA_gbest, TSA_history] = TSA_func(fhd{func_num}, X, pop_size, iter_max, Xmin, Xmax, D);
                time_results(run, 2) = toc;
                TSA_best_vals(run, :) = TSA_history;

                % GWO
                tic;
                [GWO_gbest, GWO_history] = GWO_func(fhd{func_num}, X, pop_size, iter_max, Xmin, Xmax, D);
                time_results(run, 3) = toc;
                GWO_best_vals(run, :) = GWO_history;

                % FOX
                tic;
                [FOX_gbest, FOX_history] = FOX_func(fhd{func_num}, X, pop_size, iter_max, Xmin, Xmax, D);
                time_results(run, 4) = toc;
                FOX_best_vals(run, :) = FOX_history;

                % Hybrid FOX-TSA
                tic;
                [Hybrid_FOX_TSA_gbest, Hybrid_FOX_TSA_history] = Hybrid_FOX_TSA_func(fhd{func_num}, X, pop_size, iter_max, Xmin, Xmax, D);
                time_results(run, 5) = toc;
                Hybrid_FOX_TSA_best_vals(run, :) = Hybrid_FOX_TSA_history;
            end
            
            % Compute average best fitness for all algorithms
            PSO_avg_fitness = mean(PSO_best_vals);
            TSA_avg_fitness = mean(TSA_best_vals);
            GWO_avg_fitness = mean(GWO_best_vals);
            FOX_avg_fitness = mean(FOX_best_vals);
            Hybrid_FOX_TSA_avg_fitness = mean(Hybrid_FOX_TSA_best_vals);
            
            % Store the results to a cell array for Excel
            results = [results; {func_num, pop_size, iter_max, ...
                mean(PSO_avg_fitness), mean(TSA_avg_fitness), mean(GWO_avg_fitness), ...
                mean(FOX_avg_fitness), mean(Hybrid_FOX_TSA_avg_fitness), ...
                mean(time_results(:, 1)), mean(time_results(:, 2)), ...
                mean(time_results(:, 3)), mean(time_results(:, 4)), ...
                mean(time_results(:, 5))}];
            
            % Plot the combined convergence graph for this function
            figure;
            plot(1:iter_max, PSO_avg_fitness, 'r', 'LineWidth', 1.5); hold on;
            plot(1:iter_max, TSA_avg_fitness, 'b', 'LineWidth', 1.5); hold on;
            plot(1:iter_max, GWO_avg_fitness, 'g', 'LineWidth', 1.5); hold on;
            plot(1:iter_max, FOX_avg_fitness, 'm', 'LineWidth', 1.5); hold on;
            plot(1:iter_max, Hybrid_FOX_TSA_avg_fitness, 'k', 'LineWidth', 1.5);
            legend('PSO', 'TSA', 'GWO', 'FOX', 'Hybrid FOX-TSA');
            xlabel('Iterations');
            ylabel('Average Best Fitness');
            title(['Convergence of Algorithms on CEC Function ', num2str(func_num)]);
        end
    end
end

% Save the results to an Excel file
filename = 'Hybrid_FOX_TSA_Comparison_CEC.xlsx';
headers = {'Function', 'Pop Size', 'Iterations', 'PSO Fitness', 'TSA Fitness', 'GWO Fitness', 'FOX Fitness', ...
    'Hybrid FOX-TSA Fitness', 'PSO Time', 'TSA Time', 'GWO Time', 'FOX Time', 'Hybrid FOX-TSA Time'};
xlswrite(filename, [headers; results]);

disp('Results saved to Excel file.');
