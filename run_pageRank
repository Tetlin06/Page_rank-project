% Define starting URL and parameters
root_url = 'https://www.gradescope.com/'; % Replace with your chosen website
N_values = [100, 200, 300, 400, 500]; % Different N values to test
p_values = [0.05, 0.10, 0.85, 0.90, 0.95]; % p values (2 close to 0, 2 close to 1, 1 normal)
printon = 0; % Set to 1 if you want to display progress

% Add the directory containing surfer.m to the MATLAB path
% Update the path to where your 'surfer' function is located
addpath('/MATLAB Drive/HW 2');

% Initialize cell arrays to store results
num_N = length(N_values);
num_p = length(p_values);

% Preallocate cell arrays for results
top_pages_eig = cell(num_N, num_p);
top_pages_power = cell(num_N, num_p);
timings_eig = zeros(num_N, num_p);
timings_power = zeros(num_N, num_p);
iterations_power = zeros(num_N, num_p);

% Loop over different N values
for n_idx = 1:num_N
    N = N_values(n_idx);
    fprintf('\nProcessing N = %d\n', N);
    
    % Clear variables specific to each iteration
    clear U G P_original P
    
    % Run surfer function to generate URLs and adjacency matrix
    [U, G] = surfer(root_url, N, printon);
    
    % Update N in case fewer pages were crawled
    N_actual = size(G, 1);
    U = U(1:N_actual);
    G = G(1:N_actual, 1:N_actual);
    
    %% Handle dangling nodes by setting entire column in G to 1
    dangling_nodes = find(sum(G, 1) == 0);
    G(:, dangling_nodes) = 1;
    
    % Normalize columns of G to construct P_original
    column_sums = sum(G, 1);
    P_original = G ./ column_sums;
    
    % Loop over different p values
    for p_idx = 1:num_p
        p = p_values(p_idx);
        fprintf('\nProcessing p = %.2f\n', p);
        
        % Apply the random surfer model
        P = p * P_original + (1 - p) * (1 / N_actual) * ones(N_actual, N_actual);
        
        %% Method 1: Eigenvector Method
        tic; % Start timing
        [V, D] = eig(P);
        % Find the eigenvector corresponding to the eigenvalue closest to 1
        [~, idx_eig] = min(abs(diag(D) - 1));
        principal_eigenvector = abs(real(V(:, idx_eig)));
        % Normalize the eigenvector
        pagerank_eig = principal_eigenvector / sum(principal_eigenvector);
        timings_eig(n_idx, p_idx) = toc; % Record timing
        
        % Extract top 10 pages
        [prob_eig, indices_eig] = sort(pagerank_eig, 'descend');
        top_pages_eig{n_idx, p_idx} = [U(indices_eig(1:min(10, length(U)))), num2cell(prob_eig(1:min(10, length(U))))];
        
%% Method 2: Power Method
tic; % Start timing
% Initial probability distribution: uniform over all nodes
rank = ones(N_actual, 1) / N_actual;

% Power method parameters
tolerance = 1e-6;
max_iterations = 1000;
for iter = 1:max_iterations
    rank_new = P * rank;
    % Normalize the rank vector
    rank_new = rank_new / sum(rank_new);
    % Check convergence
    if norm(rank_new - rank, 1) < tolerance
        break;
    end
    rank = rank_new;
end
pagerank_power = rank;
timings_power(n_idx, p_idx) = toc; % Record timing
iterations_power(n_idx, p_idx) = iter; % Record number of iterations

% Extract top 10 pages
[prob_power, indices_power] = sort(pagerank_power, 'descend');
top_pages_power{n_idx, p_idx} = [U(indices_power(1:min(10, length(U)))), num2cell(prob_power(1:min(10, length(U))))];
        
        %% Display Results for Current N and p
        fprintf('\nTop 10 pages using Eigenvector method for N = %d, p = %.2f:\n', N, p);
        for i = 1:min(10, length(U))
            fprintf('Rank %d: %s (Probability: %.6f)\n', i, top_pages_eig{n_idx, p_idx}{i,1}, top_pages_eig{n_idx, p_idx}{i,2});
        end
        
        fprintf('\nTop 10 pages using Power method for N = %d, p = %.2f:\n', N, p);
        for i = 1:min(10, length(U))
            fprintf('Rank %d: %s (Probability: %.6f)\n', i, top_pages_power{n_idx, p_idx}{i,1}, top_pages_power{n_idx, p_idx}{i,2});
        end
        
        %% Performance Metrics
        fprintf('\nPerformance for N = %d, p = %.2f:\n', N, p);
        fprintf('Eigenvector method time: %.4f seconds\n', timings_eig(n_idx, p_idx));
        fprintf('Power method time: %.4f seconds, iterations: %d\n', timings_power(n_idx, p_idx), iterations_power(n_idx, p_idx));
    end
end

%% Format Results for Comparison

% Create tables for performance metrics
PerformanceTable = cell(num_N + 1, num_p + 1);
PerformanceTable{1, 1} = 'N / p';

for p_idx = 1:num_p
    PerformanceTable{1, p_idx + 1} = sprintf('p = %.2f', p_values(p_idx));
end

for n_idx = 1:num_N
    N = N_values(n_idx);
    PerformanceTable{n_idx + 1, 1} = sprintf('N = %d', N);
    for p_idx = 1:num_p
        eig_time = timings_eig(n_idx, p_idx);
        power_time = timings_power(n_idx, p_idx);
        power_iter = iterations_power(n_idx, p_idx);
        PerformanceTable{n_idx + 1, p_idx + 1} = sprintf('Eig: %.4fs\nPower: %.4fs, %d iter', eig_time, power_time, power_iter);
    end
end

% Display the performance table
fprintf('\nPerformance Comparison Table:\n');
for row = 1:size(PerformanceTable, 1)
    for col = 1:size(PerformanceTable, 2)
        fprintf('%20s', PerformanceTable{row, col});
    end
    fprintf('\n');
end

% Optionally, save the results to a file
% save('PageRankResults.mat', 'top_pages_eig', 'top_pages_power', 'PerformanceTable');
