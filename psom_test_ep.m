function [pipel,opt_pipe] = psom_test_ep(path_test,opt)
% A test pipeline with embarassingly parallel jobs
%
% [pipe,opt_pipe] = psom_test_ep(path_test,opt)
%
% PATH_TEST (string, default current path) where to run the test.
% OPT (structure) any option passed to PSOM will do. In addition the 
%   following options are available:
%   PATH_LOGS is forced to [path_test filesep 'logs']
%   TIME (scalar, default 3) the time (in seconds) that takes each 
%      job.
%   NB_JOBS (integer, default 100) the number of jobs.
%   FLAG_TEST (boolean, default false) if FLAG_TEST is on, the pipeline
%     is generated but not executed.
% PIPE (structure) the pipeline.
% OPT_PIPE (structure) the options to run the pipeline.
%
% Copyright (c) Pierre Bellec, 
% Departement d'informatique et de recherche operationnelle
% Centre de recherche de l'institut de Geriatrie de Montreal
% Universite de Montreal, 2015.
% Maintainer : pierre.bellec@criugm.qc.ca
% See licensing information the LICENSE file.
% Keywords : pipeline, PSOM, test

%% Set up default options
pipel = struct;

if nargin < 2
    opt = struct;
end

list_opt = { 'time' , 'nb_jobs' , 'flag_test' };
list_def = { 3      , 100       , false       };
opt = psom_struct_defaults(opt,list_opt,list_def,false);

if (nargin < 1)||isempty(path_test)
    path_test = pwd;
end
if ~strcmp(path_test(end),filesep)
    path_test = [path_test filesep];
end

opt.path_logs = [path_test 'logs'];

%% The options for PSOM
opt_pipe = rmfield(opt,list_opt);

%% Build the pipeline
for num_j = 1:opt.nb_jobs
    job_name = sprintf('job%i',num_j);   
    pipel.(job_name).command = sprintf('system(''sleep %i'');',opt.time);
end

%% Run the pipeline
if ~opt.flag_test
    psom_run_pipeline(pipel,opt_pipe);
end