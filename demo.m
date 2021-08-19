%%   
%   Demo program:   
%   Y. Liu, Y. Wang, Guang Chen, Alois Knoll, M. Wang, Z. Song
%   Globally Optimal Linear Model Fitting with Unit Norm Constraint.   
%   If you encounter any problems or questions please email to yiruwang18@fudan.edu.cn.   
%***********************************************************************
%   The program is free for non-commercial academic use. 
%   Any commercial use is strictly prohibited without the authors' consent. 
%   Please cite the above paper in any academic publications that have made use of this package or part of it.
%***********************************************************************
    clear;
    close all;
    addpath(genpath('data/')); 
    addpath(genpath('src/')); 
    
    disp('Before you fisrt run GoCR, please run compile_me.m');
    pause;
%     compile_me;
    

%% Problem List --- Method List 

%   Synthetic Linear Problem on N/Outlier/Dim (Synthetic)
%   Plane Fitting (Plane)                                     
%   Translation Estimation (Translation)                      
%   Affine Fundamental Matrix Estimation (AffineF)                                    
                       
    problemList = {'Synthetic',...,
                            'Plane',...,
                            'Translation',...,
                            'AffineF'};

    methodList = {'GoCR'}; 
                    
    selectedProblem = 4; 
    selectedMethod = 1; 
 
%% excute  
%   You can set the timeLimit to avoid extremely long runtime in each run. 
%   Please notice that the method would not guarantee the global optimality,
%   if it cannot converge within the timeLimit.
%   The output of RESULT.flagofGlobal indicates that if one run guarantees the
%   global optimality.
 
    warning('off', 'all');
    currentProblem = problemList{selectedProblem};
    if strcmp(currentProblem, 'Synthetic')   
 
        timeLimit = 50;
        N = 200; % number of data points
        OutlierRatio = 0.2; % 0 < outlier ratio < 1
        Dim = 3; % dimensionality of linear model
        Repeats = 5; % times of randomly generated data 
        noise_in = 0.01; % noise varience of inliers
        noise_out = 1.5; % noise varience of outliers
        
        RESULT = demoLinearSynth(N, OutlierRatio, Dim, Repeats, noise_in, noise_out, timeLimit, selectedMethod, methodList);

    elseif strcmp(currentProblem, 'Plane')
        % PlaneFitting
        
        timeLimit = 50;%200
        NumofPlane = 1; % number of planes 
        epsilon = 0.01; %*** inlier threshold
        [RESULT, RESULT_Sum] = demoPlaneFitting(epsilon, NumofPlane, timeLimit, selectedMethod, methodList);
      
    elseif strcmp(currentProblem, 'Translation')
         % TranslationEstimation
         
        timeLimit = 50;
        load('./data/TranslationEstimationData.mat');
        epsilon = 0.0025; 
        RESULT = demoTranslationEstimation(TranslationEstimationData, epsilon, timeLimit, selectedMethod, methodList);

    elseif strcmp(currentProblem, 'AffineF')
         % Affine fundamentatl matrix estimation
         
        timeLimit = 50;
        load('./data/AffineFData-S.mat');
        epsilon = 2; %*** inlier threshold. We recommend that the inlier threshold of GoIA-UN (0.0025) is half of that of GoIA-LR (0.005).
        RESULT = demoAffineF(AffineFData, epsilon, timeLimit, selectedMethod, methodList;
    
     end

     disp(['Please see the output of RESULT to check the detailed results.']);

%  close all;
 






