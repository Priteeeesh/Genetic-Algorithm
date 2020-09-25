function out = RunGA(problem, params)

    % Problem
    CostFunction = problem.CostFunction;
    nVar = problem.nVar;
    
    % Params
    MaxIt = params.MaxIt;
    nPop = params.nPop;
    beta = params.beta;
    pC = params.pC;
    nC = round(pC*nPop/2)*2;
    mu = params.mu;
    
    % Template for Empty Individuals
    empty_individual.Position1 = [];
    empty_individual.Position2 = [];
    empty_individual.Cost = [];
    
    % Best Solution Ever Found
    bestsol.Cost = inf;
    
    % Initialization
    pop = repmat(empty_individual, nPop, 1);
    for i = 1:nPop
        
        % Generate Random Solution
        pop(i).Position1 = randi([0, 1], 1, nVar);
        pop(i).Position2 = randi([0, 1], 1, nVar);
        
        % Evaluate Solution
        pop(i).Cost = CostFunction(pop(i).Position1, pop(i).Position1);
        
        % Compare Solution to Best Solution Ever Found
        if pop(i).Cost < bestsol.Cost
            bestsol = pop(i);
        end
        
    end
    
    % Best Cost of Iterations
    bestcost = nan(MaxIt, 1);
    
    % Main Loop
    for it = 1:MaxIt
        
        % Selection Probabilities
        c = [pop.Cost];
        avgc = mean(c);
        if avgc ~= 0
            c = c/avgc;
        end
        probs = exp(-beta*c);
        
        % Initialize Offsprings Population
        popc = repmat(empty_individual, nC/2, 2);
        
        % Crossover
        for k = 1:nC/2
            
            % Select Parents
            p1.Position1 = pop(RouletteWheelSelection(probs)).Position1;
            p1.Position2 = pop(RouletteWheelSelection(probs)).Position2;
            p2.Position1 = pop(RouletteWheelSelection(probs)).Position1;
            p2.Position2 = pop(RouletteWheelSelection(probs)).Position2;
            
            % Perform Crossover
            [popc(k, 1).Position1, popc(k, 2).Position1] = ...
                DoublePointCrossover(p1.Position1, p2.Position1);
            [popc(k, 1).Position2, popc(k, 2).Position2] = ...
                DoublePointCrossover(p1.Position2, p2.Position2);
        end
        
        % Convert popc to Single-Column Matrix
        popc = popc(:);
        
        % Mutation
        for l = 1:nC
            
            % Perform Mutation
            popc(l).Position1 = Mutate(popc(l).Position1, mu);
            popc(l).Position2 = Mutate(popc(l).Position2, mu);
            
            % Evaluation
            popc(l).Cost = CostFunction(popc(l).Position1,popc(l).Position2);
            
            % Compare Solution to Best Solution Ever Found
            if popc(l).Cost < bestsol.Cost
                bestsol = popc(l);
            end
            
        end
        
        % Merge and Sort Populations
        pop = SortPopulation([pop; popc]);
        
        % Remove Extra Individuals
        pop = pop(1:nPop);
        
        % Update Best Cost of Iteration
        bestcost(it) = bestsol.Cost;

        % Display Itertion Information
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(bestcost(it))]);
        
    end
    
    
    % Results
    out.pop = pop;
    out.bestsol = bestsol;
    out.bestcost = bestcost;
    
end