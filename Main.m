clc;
clear;
close all;

%% Problem Definition

problem.CostFunction = @(x1,x2) MinOne(x1,x2);
problem.nVar = 5;


%% GA Parameters

params.MaxIt = 100;
params.nPop = 6;
params.beta = 1;
params.pC = 0.9;
params.mu = 0.05;


%% Run GA

out = RunGA(problem, params);


%% Results

figure;
plot(out.bestcost, 'LineWidth', 2);
xlabel('Iterations');
ylabel('Best Cost');
grid on;





