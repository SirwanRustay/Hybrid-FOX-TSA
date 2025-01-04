clear all
close all

% Parameters
D = 20; % Reduce the dimensionality of the problem
Xmin = -100;
Xmax = 100;
pop_size = 20; % Reduce the population size
iter_max = 200; % Reduce the number of iterations
runs = 20; % Adjust the number of runs
fhd = str2func('cec22_func');

% Initialize storage for results
results = struct('PSO', [], 'TSA', [], 'GWO', [], 'FOX', [], 'Hybrid_FOX_TSA', []);

% Number of functions to test
num_functions = 12;

% Main loop
for func_num = 1:num_functions % Test all 12 functions
    disp(['Running Function ', num2str(func_num)]);
    for j = 1:runs
        [PSO(func_num).gbest(j,:), PSO(func_num).gbestval(j,:), PSO(func_num).con(j,:)] = PSO_func(fhd, D, pop_size, iter_max, Xmin, Xmax, func_num);
        [TSA(func_num).gbest(j,:), TSA(func_num).gbestval(j,:), TSA(func_num).con(j,:)] = TSA_func(fhd, D, pop_size, iter_max, Xmin, Xmax, func_num);
        [GWO(func_num).gbest(j,:), GWO(func_num).gbestval(j,:), GWO(func_num).con(j,:)] = GWO_func(fhd, D, pop_size, iter_max, Xmin, Xmax, func_num);
        [FOX(func_num).gbest(j,:), FOX(func_num).gbestval(j,:), FOX(func_num).con(j,:)] = FOX_func(pop_size, iter_max, Xmin, Xmax, D, fhd, func_num);
        [Hybrid_FOX_TSA(func_num).gbest(j,:), Hybrid_FOX_TSA(func_num).gbestval(j,:), Hybrid_FOX_TSA(func_num).con(j,:)] = Hybrid_FOX_TSA_func(pop_size, iter_max, Xmin, Xmax, D, fhd, func_num);
    end
    
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

% Create table to display results
TestFunction = (1:num_functions)';
PSO_mean = [results.PSO]';
TSA_mean = [results.TSA]';
GWO_mean = [results.GWO]';
FOX_mean = [results.FOX]';
Hybrid_FOX_TSA_mean = [results.Hybrid_FOX_TSA]';

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

% Plot the results as a bar graph
figure;
bar(TestFunction, [PSO_mean, TSA_mean, GWO_mean, FOX_mean, Hybrid_FOX_TSA_mean]);
legend('PSO', 'TSA', 'GWO', 'FOX', 'Hybrid_FOX_TSA');
title('Performance Comparison of Algorithms');
xlabel('Test Function');
ylabel('Mean Best Score');
set(gca, 'FontSize', 12); % Adjust font size for bar graph

% Plot the convergence graphs
figure;
for i = 1:num_functions
    subplot(3, 4, i);
    semilogy(mean(PSO(i).con), 'LineWidth', 1); hold on;
    semilogy(mean(TSA(i).con), 'LineWidth', 1); hold on;
    semilogy(mean(GWO(i).con), 'LineWidth', 1); hold on;
    semilogy(mean(FOX(i).con), 'LineWidth', 1); hold on;
    semilogy(mean(Hybrid_FOX_TSA(i).con), 'LineWidth', 1); hold on;
    legend('PSO', 'TSA', 'GWO', 'FOX', 'Hybrid_FOX_TSA', 'FontSize', 8); % Adjust font size for legend
    title(['Function ', num2str(i)], 'FontSize', 10); % Adjust font size for title
    xlabel('Iteration', 'FontSize', 8); % Adjust font size for x-axis label
    ylabel('Best score obtained so far', 'FontSize', 8); % Adjust font size for y-axis label
    set(gca, 'FontSize', 8); % Adjust font size for ticks
end

% Save the results if needed
save('results.mat', 'results', 'T');
