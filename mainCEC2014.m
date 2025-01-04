clear all
close all

% Reinitialize to the default generator and set seed
rng(0, 'twister');

% Parameters
D = 10; % Dimensionality of the problem
Xmin = -100;
Xmax = 100;
pop_size = 20; % Population size
iter_max = 100; % Number of iterations
runs = 10; % Number of runs
fhd = str2func('cec14_func'); % Using the CEC 2014 functions

% Initialize storage for results
results = struct('PSO', [], 'TSA', [], 'GWO', [], 'FOX', [], 'Hybrid_FOX_TSA', []);

% Number of functions to test
num_functions = 30; % CEC 2014 has 30 functions
functions_to_skip = [13:30]; % Skip functions causing issues

% Main loop
for func_num = 1:num_functions
    if ismember(func_num, functions_to_skip)
        disp(['Skipping Function ', num2str(func_num)]);
        continue; % Skip the functions that have caused issues
    end
    
    disp(['Running Function ', num2str(func_num)]);
    for j = 1:runs
        try
            [PSO(func_num).gbest(j,:), PSO(func_num).gbestval(j,:), PSO(func_num).con(j,:)] = PSO_func(fhd, D, pop_size, iter_max, Xmin, Xmax, func_num);
            [TSA(func_num).gbest(j,:), TSA(func_num).gbestval(j,:), TSA(func_num).con(j,:)] = TSA_func(fhd, D, pop_size, iter_max, Xmin, Xmax, func_num);
            [GWO(func_num).gbest(j,:), GWO(func_num).gbestval(j,:), GWO(func_num).con(j,:)] = GWO_func(fhd, D, pop_size, iter_max, Xmin, Xmax, func_num);
            [FOX(func_num).gbest(j,:), FOX(func_num).gbestval(j,:), FOX(func_num).con(j,:)] = FOX_func(pop_size, iter_max, Xmin, Xmax, D, fhd, func_num);
            [Hybrid_FOX_TSA(func_num).gbest(j,:), Hybrid_FOX_TSA(func_num).gbestval(j,:), Hybrid_FOX_TSA(func_num).con(j,:)] = Hybrid_FOX_TSA_func(pop_size, iter_max, Xmin, Xmax, D, fhd, func_num);
        catch ME
            disp(['Error in Function ', num2str(func_num), ', Run ', num2str(j), ': ', ME.message]);
            functions_to_skip = [functions_to_skip, func_num]; % Add the function to the skip list
            break; % Break out of the loop if an error occurs
        end
    end
    
    % Only process results if the function was not skipped
    if ~ismember(func_num, functions_to_skip)
        % Calculate mean convergence and best values
        PSO(func_num).conmean = mean(PSO(func_num).con);
        TSA(func_num).conmean = mean(TSA(func_num).con);
        GWO(func_num).conmean = mean(GWO(func_num).con);
        FOX(func_num).conmean = mean(FOX(func_num).con);
        Hybrid_FOX_TSA(func_num).conmean = mean(Hybrid_FOX_TSA(func_num).con);
        
        PSO(func_num).bestmean = mean(PSO(func_num).gbestval(:));
        TSA(func_num).bestmean = mean(TSA(func_num).gbestval(:));
        GWO(func_num).bestmean = mean(GWO(func_num).gbestval(:));
        FOX(func_num).bestmean = mean(FOX(func_num).gbestval(:));
        Hybrid_FOX_TSA(func_num).bestmean = mean(Hybrid_FOX_TSA(func_num).gbestval(:));
        
        % Store results
        results(func_num).PSO = PSO(func_num).bestmean;
        results(func_num).TSA = TSA(func_num).bestmean;
        results(func_num).GWO = GWO(func_num).bestmean;
        results(func_num).FOX = FOX(func_num).bestmean;
        results(func_num).Hybrid_FOX_TSA = Hybrid_FOX_TSA(func_num).bestmean;
    end
end

% Filter out skipped functions
valid_funcs = setdiff(1:num_functions, functions_to_skip);
TestFunction = valid_funcs';
PSO_mean = [results(valid_funcs).PSO]';
TSA_mean = [results(valid_funcs).TSA]';
GWO_mean = [results(valid_funcs).GWO]';
FOX_mean = [results(valid_funcs).FOX]';
Hybrid_FOX_TSA_mean = [results(valid_funcs).Hybrid_FOX_TSA]';

% Create table to display results
T = table(TestFunction, PSO_mean, TSA_mean, GWO_mean, FOX_mean, Hybrid_FOX_TSA_mean);

% Find the best algorithm for each test function
[~, best_idx] = min([PSO_mean, TSA_mean, GWO_mean, FOX_mean, Hybrid_FOX_TSA_mean], [], 2);

% Add a column to the table indicating the best algorithm
algorithms = {'PSO', 'TSA', 'GWO', 'FOX', 'Hybrid_FOX_TSA'};
BestAlgorithm = algorithms(best_idx)';
T.BestAlgorithm = BestAlgorithm;

% Calculate the overall best algorithm
total_mean_scores = sum([PSO_mean, TSA_mean, GWO_mean, FOX_mean, Hybrid_FOX_TSA_mean], 1);
[~, overall_best_idx] = min(total_mean_scores);
OverallBestAlgorithm = algorithms{overall_best_idx};

% Display the table and the overall best algorithm
disp(T);
disp(['Overall Best Algorithm: ', OverallBestAlgorithm]);

% Plot GWO data separately
figure;
subplot(2, 1, 1);
bar(TestFunction, GWO_mean);
title('GWO Performance');
xlabel('Test Function');
ylabel('Mean Best Score');

% Plot other data without GWO
subplot(2, 1, 2);
bar_data = [PSO_mean, TSA_mean, FOX_mean, Hybrid_FOX_TSA_mean];
bar(TestFunction, bar_data);
legend('PSO', 'TSA', 'FOX', 'Hybrid_FOX_TSA');
title('Performance Comparison of Algorithms (Excluding GWO)');
xlabel('Test Function');
ylabel('Mean Best Score');


% Plot the convergence graphs
figure;
for i = 1:length(valid_funcs)
    func_num = valid_funcs(i);
    subplot(3, 4, i);
    semilogy(mean(PSO(func_num).con), 'LineWidth', 1); hold on;
    semilogy(mean(TSA(func_num).con), 'LineWidth', 1); hold on;
    semilogy(mean(GWO(func_num).con), 'LineWidth', 1); hold on;
    semilogy(mean(FOX(func_num).con), 'LineWidth', 1); hold on;
    semilogy(mean(Hybrid_FOX_TSA(func_num).con), 'LineWidth', 1); hold on;
    title(['Function ', num2str(func_num)], 'FontSize', 10); % Adjust font size for title
    xlabel('Iteration', 'FontSize', 8); % Adjust font size for x-axis label
    ylabel('Best score obtained so far', 'FontSize', 8); % Adjust font size for y-axis label
    set(gca, 'FontSize', 8); % Adjust font size for ticks
end
legend('PSO', 'TSA', 'GWO', 'FOX', 'Hybrid_FOX_TSA', 'FontSize', 8); % Display legend only once

% Save the results if needed
save('results.mat', 'results', 'T');
