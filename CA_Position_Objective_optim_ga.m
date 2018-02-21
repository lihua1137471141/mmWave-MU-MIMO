function [x,fval,exitflag,output,population,score] = CA_Position_Objective_optim_ga(conf,problem,lb,ub,PopulationSize_Data,EliteCount_Data,CrossoverFraction_Data,MaxGenerations_Data,MaxStallGenerations_Data)
%% This is an auto generated MATLAB file from Optimization Tool.
% Copyright 2017  The MathWorks, Inc.
%% Start with the default options
options = optimoptions('ga');
%% Modify options setting
options = optimoptions(options,'PopulationSize', PopulationSize_Data);
options = optimoptions(options,'EliteCount', EliteCount_Data);
options = optimoptions(options,'CrossoverFraction', CrossoverFraction_Data);
options = optimoptions(options,'NonlinearConstraintAlgorithm', 'auglag'); % 'penalty'
options = optimoptions(options,'MaxGenerations', MaxGenerations_Data);
options = optimoptions(options,'MaxStallGenerations', MaxStallGenerations_Data);
options = optimoptions(options,'Display', 'off');
options = optimoptions(options,'PlotFcn', {@gaplotbestf,@gaplotstopping});
nvar = numel(lb); % == numel(ub) == num. variables in the gen
if strcmp(conf.genStructure, 'nchoosek')
    integervars = 1;
    if conf.multiPath
        [x,fval,exitflag,output,population,score] = ...
        ga(@(x)Position_Objective_optim_cost_multipath(x,conf,problem),...
        nvar,[],[],[],[],lb,ub,@(x)all_NonLinear_Constraints(x,conf,problem),...
        integervars,options);
    else
        [x,fval,exitflag,output,population,score] = ...
        ga(@(x)Position_Objective_optim_cost_singlepath(x,conf,problem),...
        nvar,[],[],[],[],lb,ub,@(x)all_NonLinear_Constraints(x,conf,problem),...
        integervars,options);
    end
elseif strcmp(conf.genStructure, 'allAntennas')
    options = optimoptions(options,'CrossoverFcn',...
        @(p,o,n,z1,z2,t)crossoverArrayGA(p,o,n,z1,z2,t,problem));
    options = optimoptions(options,'MutationFcn',...
        @(p,o,n,z1,z2,z3,t)mutationArrayGA(p,o,n,z1,z2,z3,t,problem));
    options = optimoptions(options,'CreationFcn',...
        @(g,f,o)creationArrayGA(g,f,o,problem));
    if conf.multiPath
        [x,fval,exitflag,output,population,score] = ...
        ga(@(x)Position_Objective_optim_cost_multipath(x,conf,problem),...
        nvar,[],[],[],[],[],[],[],[],options);
    else
        [x,fval,exitflag,output,population,score] = ...
        ga(@(x)Position_Objective_optim_cost_singlepath(x,conf,problem),...
        nvar,[],[],[],[],[],[],[],[],options);
    end
else
    integervars = 1:problem.Nmax;
    if conf.multiPath
        [x,fval,exitflag,output,population,score] = ...
        ga(@(x)Position_Objective_optim_cost_multipath(x,conf,problem),...
        nvar,[],[],[],[],lb,ub,@(x)all_NonLinear_Constraints(x,conf,problem),...
        integervars,options);
    else
        [x,fval,exitflag,output,population,score] = ...
        ga(@(x)Position_Objective_optim_cost_singlepath(x,conf,problem),...
        nvar,[],[],[],[],lb,ub,@(x)all_NonLinear_Constraints(x,conf,problem),...
        integervars,options);
    end
end