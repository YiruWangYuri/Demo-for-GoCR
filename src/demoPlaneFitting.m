function [RESULT, RESULT_Sum] = demoPlaneFitting(epsilon_IN, NumofPlane, timeLimit, selectedMethod, methodList)
% demo program for plane fitting
% In one scene, we estimated only one plane.
% epsilon: inlier threshold
% NumofPlane: number of planes 

%% prepare data
    disp(['****************Plane fitting experiments *******************'])
    disp(['*********Estimate ', num2str(NumofPlane), ' plane(s) in each scene sequencially.*********']);
    disp(['----------------------------------------------------------------------------------------'])
    temp = 0;
    temp_full = 0;
    
    load('livingRoom');  
    Repeats = size(livingRoomData, 2);
    gridStep = 0.07; 

    for i = 1: Repeats   
        
        pc = livingRoomData{i};
        [ptCloud,indices]= removeInvalidPoints(pc);
        
      %% excute each method in each scene
         for idxMethod = selectedMethod
            currentMethod = methodList{idxMethod};                
            if  strcmp(currentMethod, 'GoCR') 
                ptCloudA = pcdownsample(ptCloud,'gridAverage',gridStep);
            end
            
%             figure
%             pcshow(ptCloud);
            
            data_X=ptCloudA.Location(:,1);
            data_Y=ptCloudA.Location(:,2);
            data_Z=ptCloudA.Location(:,3);
            data = [data_X'; data_Y';data_Z';ones(1, numel(data_X))];
            data_Normalize = [data(1:end-2,:); data(end, :); data(end-1,:)];
            data_Normalize = double(data_Normalize);
            
            data_X_full=ptCloud.Location(:,1);
            data_Y_full=ptCloud.Location(:,2);
            data_Z_full=ptCloud.Location(:,3);
            data_full = [data_X_full'; data_Y_full';data_Z_full';ones(1, numel(data_X_full))];
            data_Normalize_full = [data_full(1:end-2,:); data_full(end, :); data_full(end-1,:)];
            data_Normalize_full = double(data_Normalize_full);            
            
            if strcmp(currentMethod, 'GoCR')
                solInit = rand(size(data_Normalize,1),1);                
            end   

             %prepare parameters--inlier thre
             if strcmp(currentMethod, 'GoCR')
                epsilon = epsilon_IN;
            end      

             %gap  
            gap = 0; %the relative gap between Upper and Lower bound

            datainput = data_Normalize;            
            flaginput = zeros(1, size(data_Normalize,2));
            flagdraw = zeros(1, size(data_Normalize_full,2));  
            runtime_ = 0;
            CS_ = 0;
            iter_ = 0;
            CS_full_ = 0;
            for numP = 1:NumofPlane
                [runtime, solution, CS, flagofGlobal, iter, outindex] = SloveLinearProm(currentMethod, datainput, 3, solInit, epsilon, timeLimit, gap);           
                 if strcmp(currentMethod, 'GoCR') 
                    flaginput (...
                    abs(solution' * data_Normalize) < epsilon + eps...
                    ) = numP;

                    flagdraw (...
                    abs(solution' * data_Normalize_full) < epsilon + eps...
                    ) = numP;
                
                end                
                
                

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %%%  RESULT =  [i, method, N, dim, noise, outlierRatio, runtime, flagofGlobal, iter, CS, solution]  %%%
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
                
                temp = temp + 1;
                RESULT(temp).repeats = i;
                RESULT(temp).currentMethod = currentMethod;
                RESULT(temp).N = size(data, 2);
                RESULT(temp).numP = numP;
                RESULT(temp).runtime = runtime; runtime_ = runtime_ + runtime;
                RESULT(temp).CS = CS; CS_ = CS_ + CS;
                RESULT(temp).iter = iter; iter_ = iter_ + iter;
                RESULT(temp).flagofGlobal = flagofGlobal;
                RESULT(temp).solution = solution;

                if strcmp(currentMethod, 'GoCR')  
                    RESULT(temp).CS_full = sum (abs(solution' * data_Normalize_full) < epsilon + eps);
                    CS_full = RESULT(temp).CS_full;
                end
                CS_full_ = CS_full_ + CS_full;
                
                data_Normalize(:, flaginput==numP) = Inf;
                data_Normalize_full(:, flagdraw==numP) = Inf;
                datainput = data_Normalize(:, flaginput==0) ;
%                 hold on
%                 plot3(data_full(1,flagdraw==numP), data_full(2,flagdraw==numP), data_full(3,flagdraw==numP), '.', 'Color', [numP/10, 0.7 , numP/10]);
              
            end
            
            temp_full = temp_full + 1;
            RESULT_Sum(temp_full).repeats = i;
            RESULT_Sum(temp_full).currentMethod = currentMethod;
            RESULT_Sum(temp_full).runtime = runtime_;
            RESULT_Sum(temp_full).CS = CS_;
            RESULT_Sum(temp_full).iter = iter_;
            RESULT_Sum(temp_full).CS_full = CS_full_;
            
            hold off
            disp([currentMethod, 'done!'])
%             if strcmp(currentMethod, 'GoIA-UN')  || strcmp(currentMethod, 'RANSAC') %|| strcmp(currentMethod, 'UN_bmvc')
%                 saveas(gcf, ['fig',num2str(i),'-',num2str(currentMethod)]);            
%             end
            close all;
         end
               
    end
end



