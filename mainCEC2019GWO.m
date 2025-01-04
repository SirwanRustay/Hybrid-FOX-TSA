clear all;
close all;
clc;

% Parameters
D = 10; % Dimensionality of the problem
Xmin = -100;
Xmax = 100;
pop_size = 100; % Population size
iter_max = 500; % Number of iterations
runs = 30; % Number of runs
cec_funcs = {@cec01, @cec02, @cec03, @cec04, @cec05, @cec06, @cec07, @cec08, @cec09, @cec10}; % CEC functions

% Initialize storage for results
results = struct('GWO', []);  % Change PSO to GWO
time_taken = zeros(10, runs); % For storing computational time for each function and run
fitness_history = zeros(10, iter_max); % For storing the best fitness at each iteration
average_fitness = zeros(10, 1); % For storing the average best fitness per function
average_time = zeros(10, 1); % For storing average time per function

% Additional metrics
best_fitness = zeros(10, 1); % Best fitness across all runs
worst_fitness = zeros(10, 1); % Worst fitness across all runs
std_fitness = zeros(10, 1); % Standard deviation of fitness across all runs
% Main loop for functions
for func_num = 1:10
    disp(['Running CEC Function ', num2str(func_num)]);
    
    all_fitnesses = zeros(runs, 1); % For storing best fitness of each run
    temp_fitness_history = zeros(iter_max, runs); % Temporary storage for fitness history per run
    
    for run = 1:runs
        % Initialize population (X)
        X = Xmin + (Xmax - Xmin) * rand(pop_size, D);
        fhd = cec_funcs{func_num}; % Select CEC function
        
        % Start timer for computational time
        tic;
        
        % Call GWO function
        [best_solution, best_fitness_run, history] = GWO_func(fhd, X, pop_size, iter_max, Xmin, Xmax, D);
        
        % End timer
        time_taken(func_num, run) = toc;
        
        % Store best fitness for each run
        results(func_num).GWO(run).best_fitness = best_fitness_run; % Store the best fitness value for the current run
        results(func_num).GWO(run).best_solution = best_solution;   % Store the best solution if needed
        results(func_num).GWO(run).history = history;               % Store the history if needed
        
        % Store the fitness history for this run
        temp_fitness_history(:, run) = history; % Store the history for the current run
        
        % Display the result of the current run
        disp(['Function ', num2str(func_num), ', Run ', num2str(run), ': Best Fitness = ', num2str(best_fitness_run)]);
        
        % Store the best fitness of the run for further analysis
        all_fitnesses(run) = best_fitness_run;
    end
    
    % Calculate average fitness for this function
    average_fitness(func_num) = mean(all_fitnesses);
    
    % Calculate the average fitness history across runs
    fitness_history(func_num, :) = mean(temp_fitness_history, 2)'; % Average across runs for each iteration
    
    % Calculate average time for this function
    average_time(func_num) = mean(time_taken(func_num, :));
    
    % Calculate best, worst, and std fitness for this function
    best_fitness(func_num) = min(all_fitnesses);
    worst_fitness(func_num) = max(all_fitnesses);
    std_fitness(func_num) = std(all_fitnesses);
end


% Plot convergence graph for all CEC functions in a 3x4 layout
figure;
tiledlayout(4, 3, 'TileSpacing', 'compact');
for func_num = 1:10
    nexttile;
    plot(1:iter_max, fitness_history(func_num, :), 'LineWidth', 2);
    title(['CEC ', num2str(func_num)]);
    xlabel('Iterations');
    ylabel('Average Best Fitness');
    grid on;
end
sgtitle('Convergence of GWO across CEC-06-2019 Functions');

% Save results and computational time to Excel
filename = 'GWO_Results_Comparison.xlsx';
sheet = 1;

% Write headers for the results
xlswrite(filename, {'Function', 'Average Fitness', 'Best Fitness', 'Worst Fitness', 'Std Fitness', 'Average Time (s)'}, sheet, 'A1');

% Write results for each function
xlswrite(filename, (1:10)', sheet, 'A2'); % Function number
xlswrite(filename, average_fitness, sheet, 'B2'); % Average fitness
xlswrite(filename, best_fitness, sheet, 'C2'); % Best fitness
xlswrite(filename, worst_fitness, sheet, 'D2'); % Worst fitness
xlswrite(filename, std_fitness, sheet, 'E2'); % Standard deviation of fitness
xlswrite(filename, average_time, sheet, 'F2'); % Average time

% Write the fitness history for each function (for convergence comparison)
for func_num = 1:10
    start_row = 2 + (func_num - 1) * (iter_max + 2);
    xlswrite(filename, {'Iteration', ['CEC ', num2str(func_num), ' Fitness']}, sheet, ['H', num2str(start_row)]);
    xlswrite(filename, (1:iter_max)', sheet, ['H', num2str(start_row + 1)]); % Iteration numbers
    xlswrite(filename, fitness_history(func_num, :)', sheet, ['I', num2str(start_row + 1)]); % Fitness history for each function
end

% Display message confirming data is saved
disp('Results and evaluation statistics saved to Excel file.');
