clc;clear;close all;
%% 程序概述
% 仿真实验：平面拟合 ax+by+cz+d=0
% dim = 4, compact_dim = 4-1.
%----------------------------Data generation and Parameter set-------
Result = [];
nexp = 10;
% Num = 1000;
% noise_in = 0.01;
noise_out = 1;
% outlierRatio = 50;  %表示百分数，例outierRatio = 20，表示20%
dim = 4;
compact_dim = dim-1;
bits_per_dim = 2;
% epsilon = 0.015;
addpath('D:\20190409 model fitting 4\code20190409\version1 code\01 synthetic-plane\data')
for Num = [5000]%100 1000 2000 3000 4000 5000
for noise_in = [0.01]% 0.001 0.01 0.015 0.02 0.025 0.03
for outlierRatio = [80] %0 10 20 30 40 50 60 70 80
for epsilon = [0.015]
for r = 1:nexp
    
    
% [X_Data, theta_gt ,guide_max_thre] = generateLinearData(Num, noise_in, noise_out, outlierRatio, dim);
% if theta_gt(1)<0
%     theta_gt = -theta_gt;
% end
% save(['X_Data',num2str(Num),'-',num2str(noise_in),'-',num2str(outlierRatio),'-',num2str(r),'.mat'],'X_Data','theta_gt','guide_max_thre')
% guide_max_thre
% theta_gt
% disp('generate synthetic data')
% disp('------------------------------------------------------------------------------')
% %----------------------------Data generation and Parameter set-------

load(['X_Data',num2str(Num),'-',num2str(noise_in),'-',num2str(outlierRatio),'-',num2str(r),'.mat'])
guide_max_thre
theta_gt
disp(['load synthetic data: ','X_Data',num2str(Num),'-',num2str(noise_in),'-',num2str(outlierRatio),'-',num2str(r),'.mat'])
disp('------------------------------------------------------------------------------')
%----------------------------Data generation and Parameter set-------


tic

[h_L,h_U,result_compact] = Search(X_Data, epsilon, compact_dim, bits_per_dim);
theta_result = compact2sphere(result_compact);
time = toc


% figure;
% plot(h_L,'g');
% hold on
% plot(h_U,'r');
Result = [Result;Num,0,noise_in,0,outlierRatio,0,epsilon,0,time,0,theta_gt',0,theta_result',0,norm(theta_gt'-theta_result'),0,sum(theta_gt.*theta_result)]
end
end
end
end
end



