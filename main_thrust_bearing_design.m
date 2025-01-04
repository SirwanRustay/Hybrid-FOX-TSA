clear all;
close all;
clc;

% Parameters
pop_size = 20; % Population size
iter_max = 100; % Number of iterations
runs = 1; % Number of runs for debugging
lb = [2, 2, 0.02];
ub = [8, 8, 0.1];
dim = 3;
fobj = @thrust_bearing_design;

% Initialize storage for results
PSO = struct('gbest', [], 'gbestval', [], 'con', []);
TSA = struct('gbest', [], 'gbestval', [], 'con', []);
GWO = struct('gbest', [], 'gbestval', [], 'con', []);
FOX = struct('gbest', [], 'gbestval', [], 'con', []);
Hybrid_FOX_TSA = struct('gbest', [], 'gbestval', [], 'con', []);
results = struct('PSO', [], 'TSA', [], 'GWO', [], 'FOX', [], 'Hybrid_FOX_TSA', []);

disp('Running Thrust Bearing Design Problem');

% Debugging each algorithm separately
for j = 1:runs
    try
        % PSO
        [PSO(j).gbest, PSO(j).gbestval, PSO(j).con] = PSO_func(fobj, dim, pop_size, iter_max, lb, ub);
        disp(['Run ', num2str(j), ': PSO Success']);
        disp(['PSO gbest size: ', mat2str(size(PSO(j).gbest))]);
        disp(['PSO gbestval size: ', mat2str(size(PSO(j).gbestval))]);
        disp(['PSO con size: ', mat2str(size(PSO(j).con))]);

        % TSA
        [TSA(j).gbest, TSA(j).gbestval, TSA(j).con] = TSA_func(fobj, dim, pop_size, iter_max, lb, ub);
        disp(['Run ', num2str(j), ': TSA Success']);
        disp(['TSA gbest size: ', mat2str(size(TSA(j).gbest))]);
        disp(['TSA gbestval size: ', mat2str(size(TSA(j).gbestval))]);
        disp(['TSA con size: ', mat2str(size(TSA(j).con))]);

        % GWO
        [GWO(j).gbest, GWO(j).gbestval, GWO(j).con] = GWO_func(fobj, dim, pop_size, iter_max, lb, ub);
        disp(['Run ', num2str(j), ': GWO Success']);
        disp(['GWO gbest size: ', mat2str(size(GWO(j).gbest))]);
        disp(['GWO gbestval size: ', mat2str(size(GWO(j).gbestval))]);
        disp(['GWO con size: ', mat2str(size(GWO(j).con))]);

        % FOX
        [FOX(j).gbest, FOX(j).gbestval, FOX(j).con] = FOX_func(pop_size, iter_max, lb, ub, dim, fobj);
        disp(['Run ', num2str(j), ': FOX Success']);
        disp(['FOX gbest size: ', mat2str(size(FOX(j).gbest))]);
        disp(['FOX gbestval size: ', mat2str(size(FOX(j).gbestval))]);
        disp(['FOX con size: ', mat2str(size(FOX(j).con))]);

        % Hybrid_FOX_TSA
        [Hybrid_FOX_TSA(j).gbest, Hybrid_FOX_TSA(j).gbestval, Hybrid_FOX_TSA(j).con] = Hybrid_FOX_TSA_func(pop_size, iter_max, lb, ub, dim, fobj);
        disp(['Run ', num2str(j), ': Hybrid_FOX_TSA Success']);
        disp(['Hybrid_FOX_TSA gbest size: ', mat2str(size(Hybrid_FOX_TSA(j).gbest))]);
        disp(['Hybrid_FOX_TSA gbestval size: ', mat2str(size(Hybrid_FOX_TSA(j).gbestval))]);
        disp(['Hybrid_FOX_TSA con size: ', mat2str(size(Hybrid_FOX_TSA(j).con))]);
    catch ME
        disp(['Error in Run ', num2str(j), ': ', ME.message]);
        break; % Break out of the loop if an error occurs
    end
end

% If we have results, calculate mean convergence and best values
if isfield(PSO, 'con') && ~isempty([PSO.con])
    PSO_con_cat = cat(1, PSO.con);
    PSO_conmean = mean(reshape(PSO_con_cat, [], runs), 2);
    PSO_bestmean = mean([PSO.gbestval]);
else
    PSO_conmean = [];
    PSO_bestmean = [];
end

if isfield(TSA, 'con') && ~isempty([TSA.con])
    TSA_con_cat = cat(1, TSA.con);
    TSA_conmean = mean(reshape(TSA_con_cat, [], runs), 2);
    TSA_bestmean = mean([TSA.gbestval]);
else
    TSA_conmean = [];
    TSA_bestmean = [];
end

if isfield(GWO, 'con') && ~isempty([GWO.con])
    GWO_con_cat = cat(1, GWO.con);
    GWO_conmean = mean(reshape(GWO_con_cat, [], runs), 2);
    GWO_bestmean = mean([GWO.gbestval]);
else
    GWO_conmean = [];
    GWO_bestmean = [];
end

if isfield(FOX, 'con') && ~isempty([FOX.con])
    FOX_con_cat = cat(1, FOX.con);
    FOX_conmean = mean(reshape(FOX_con_cat, [], runs), 2);
    FOX_bestmean = mean([FOX.gbestval]);
else
    FOX_conmean = [];
    FOX_bestmean = [];
end

if isfield(Hybrid_FOX_TSA, 'con') && ~isempty([Hybrid_FOX_TSA.con])
    Hybrid_FOX_TSA_con_cat = cat(1, Hybrid_FOX_TSA.con);
    Hybrid_FOX_TSA_conmean = mean(reshape(Hybrid_FOX_TSA_con_cat, [], runs), 2);
    Hybrid_FOX_TSA_bestmean = mean([Hybrid_FOX_TSA.gbestval]);
else
    Hybrid_FOX_TSA_conmean = [];
    Hybrid_FOX_TSA_bestmean = [];
end

% Store results
results.PSO = PSO_bestmean;
results.TSA = TSA_bestmean;
results.GWO = GWO_bestmean;
results.FOX = FOX_bestmean;
results.Hybrid_FOX_TSA = Hybrid_FOX_TSA_bestmean;

% Display the results
disp('Results:');
disp(results);

% Plot the results if any algorithm has succeeded
if ~isempty(PSO_bestmean) || ~isempty(TSA_bestmean) || ~isempty(GWO_bestmean) || ~isempty(FOX_bestmean) || ~isempty(Hybrid_FOX_TSA_bestmean)
    figure;
    bar([results.PSO, results.TSA, results.GWO, results.FOX, results.Hybrid_FOX_TSA]);
    set(gca, 'XTickLabel', {'PSO', 'TSA', 'GWO', 'FOX', 'Hybrid_FOX_TSA'});
    ylabel('Mean Best Score');
    title('Performance on Thrust Bearing Design Problem');

    % Plot convergence curves
    figure;
    hold on;
    if exist('PSO_conmean', 'var') && ~isempty(PSO_conmean)
        semilogy(PSO_conmean, 'LineWidth', 1);
    end
    if exist('TSA_conmean', 'var') && ~isempty(TSA_conmean)
        semilogy(TSA_conmean, 'LineWidth', 1);
    end
    if exist('GWO_conmean', 'var') && ~isempty(GWO_conmean)
        semilogy(GWO_conmean, 'LineWidth', 1);
    end
    if exist('FOX_conmean', 'var') && ~isempty(FOX_conmean)
        semilogy(FOX_conmean, 'LineWidth', 1);
    end
    if exist('Hybrid_FOX_TSA_conmean', 'var') && ~isempty(Hybrid_FOX_TSA_conmean)
        semilogy(Hybrid_FOX_TSA_conmean, 'LineWidth', 1);
    end
    legend('PSO', 'TSA', 'GWO', 'FOX', 'Hybrid_FOX_TSA');
    xlabel('Iteration');
    ylabel('Best Score Obtained So Far');
    title('Convergence Curve on Thrust Bearing Design Problem');
end

% Save the results if needed
save('thrust_bearing_design_results.mat', 'results');
