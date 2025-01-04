clear all
close all
clc

% Parameters
D = 10; % Dimensionality of the problem
Xmin = -100;
Xmax = 100;
pop_size = 20; % Population size
iter_max = 100; % Number of iterations
runs = 10; % Number of runs
fhd = str2func('cec1_func'); % Starting with CEC01 function

% Initialize storage for results
results = struct('PSO', [], 'TSA', [], 'GWO', [], 'FOX', [], 'Hybrid_FOX_TSA', []);

% Number of functions to test
num_functions = 10; % CEC01 to CEC10
functions_to_skip = []; % Functions to skip

% Main loop
for func_num = 1:num_functions
    if ismember(func_num, functions_to_skip)
        disp(['Skipping Function ', num2str(func_num)]);
        continue; % Skip the functions that have caused issues
    end
    
    % Initialize the structures
    PSO(func_num).gbest = [];
    PSO(func_num).gbestval = [];
    PSO(func_num).con = [];
    
    TSA(func_num).gbest = [];
    TSA(func_num).gbestval = [];
    TSA(func_num).con = [];
    
    GWO(func_num).gbest = [];
    GWO(func_num).gbestval = [];
    GWO(func_num).con = [];
    
    FOX(func_num).gbest = [];
    FOX(func_num).gbestval = [];
    FOX(func_num).con = [];
    
    Hybrid_FOX_TSA(func_num).gbest = [];
    Hybrid_FOX_TSA(func_num).gbestval = [];
    Hybrid_FOX_TSA(func_num).con = [];

    disp(['Running Function ', num2str(func_num)]);
    for j = 1:runs
        try
            % PSO
            [PSO(func_num).gbest(j,:), PSO(func_num).gbestval(j,:), PSO(func_num).con(j,:)] = PSO_func(fhd, D, pop_size, iter_max, Xmin, Xmax, func_num);
            % TSA
            [TSA(func_num).gbest(j,:), TSA(func_num).gbestval(j,:), TSA(func_num).con(j,:)] = TSA_func(fhd, D, pop_size, iter_max, Xmin, Xmax, func_num);
            % GWO
            [GWO(func_num).gbest(j,:), GWO(func_num).gbestval(j,:), GWO(func_num).con(j,:)] = GWO_func(fhd, D, pop_size, iter_max, Xmin, Xmax, func_num);
            % FOX
            [FOX(func_num).gbest(j,:), FOX(func_num).gbestval(j,:), FOX(func_num).con(j,:)] = FOX_func(pop_size, iter_max, Xmin, Xmax, D, fhd, func_num);
            % Hybrid_FOX_TSA
            [Hybrid_FOX_TSA(func_num).gbest(j,:), Hybrid_FOX_TSA(func_num).gbestval(j,:), Hybrid_FOX_TSA(func_num).con(j,:)] = Hybrid_FOX_TSA_func(pop_size, iter_max, Xmin, Xmax, D, fhd, func_num);
            disp(['Function ', num2str(func_num), ', Run ', num2str(j), ': Success']);
        catch ME
            disp(['Error in Function ', num2str(func_num), ', Run ', num2str(j), ': ', ME.message]);
            if contains(ME.message, 'Too many output arguments')
                disp('Check if the function returns the correct number of outputs.');
            end
            if contains(ME.message, 'Cannot open input file for reading')
                disp('Please check if the input files are in the correct directory.');
                functions_to_skip = [functions_to_skip, func_num]; % Add the function to the skip list
            end
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

% Continue processing results and plotting...
