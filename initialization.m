function [X] = initialization(pop_size, dim, ub, lb)
    % Ensure ub and lb are numeric and properly sized
    if isscalar(ub)
        ub = repmat(ub, 1, dim);  % If scalar, replicate across all dimensions
    end
    if isscalar(lb)
        lb = repmat(lb, 1, dim);  % If scalar, replicate across all dimensions
    end

    % Debug: Check and display bounds to verify correctness
    fprintf('ub: %s\n', mat2str(ub));  % Print upper bound
    fprintf('lb: %s\n', mat2str(lb));  % Print lower bound
    
    % Ensure ub and lb are numeric and vectors of correct length
    if ~isnumeric(ub) || ~isnumeric(lb) || length(ub) ~= dim || length(lb) ~= dim
        error('Bounds ub and lb must be numeric and vectors of length equal to dim.');
    end
    
    % Initialize population positions within the bounds using elementwise multiplication
    X = rand(pop_size, dim) .* (ub - lb) + lb;  % Use elementwise operations (.*)
end
