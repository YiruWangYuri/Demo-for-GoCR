function [RESULT] = demoAffineF(Data, epsilon_IN, timeLimit, selectedMethod, methodList)
% demo program for affine fundamentatl matrix estimation
% KITTI Odometry dataset
% Data: prepocessed data 
% epsilon: inlier threshold

%% prepare data
    disp(['****************Affine fundamentatl matrix estimation experiments *******************'])
    disp(['----------------------------------------------------------------------------------------'])

    
    
    
    
    Repeats =  size(Data, 2);
    temp=0;
    for i = 1: Repeats   
        
        data_ = Data{i};
        data = [data_.XYZ; ones(1, size(data_.XYZ, 2)) ];
        data_Normalize = [data(1:end-2, :); data(end, :); data(end-1,:)];
             
         for idxMethod = selectedMethod
            currentMethod = methodList{idxMethod};    
            %solInit 
            if  strcmp(currentMethod, 'GoCR') 
                solInit = rand(size(data_Normalize,1),1);                
            end   

             %prepare parameters--inlier thre
             if strcmp(currentMethod, 'GoCR')  
                epsilon = epsilon_IN*data_.T1(1,1);
             end   
            
             %gap  
            gap = 0; %the relative gap between Upper and Lower bound    
            [runtime, solution, CS, flagofGlobal, iter, outindex] = SloveLinearProm(currentMethod, data_Normalize, 4, solInit, epsilon, timeLimit, gap);           

%             figure
%             imagesc(cat(2,data_.imargb,data_.imcrgb));
%             hold on
%             plot(data_.X(1,:),data_.X(2,:),'r+','MarkerSize',10);
%             hold on
%             plot(data_.X(4,:)+size(data_.imargb,2),data_.X(5,:),'b+','MarkerSize',10);
% 
%             
%             flag_in = 1:size(data_.XYZ,2);
%             flag_out = outindex;
%             flag_in(flag_out)=[];
%             xa = data_.X(1,:);
%             ya = data_.X(2,:);
%             xb = data_.X(4,:)+size(data_.imargb,2);
%             yb = data_.X(5,:);
%             
%             h = line([xa(flag_in);xb(flag_in)],[ya(flag_in);yb(flag_in)]);
%             set(h,'linewidth',1,'color','g');
%             ho = line([xa(flag_out);xb(flag_out)],[ya(flag_out);yb(flag_out)]);
%             set(ho,'linewidth',1,'color','r');

            

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%  RESULT =  [i, method, N, dim, noise, outlierRatio, runtime, flagofGlobal, iter, CS, solution]  %%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
            temp = temp + 1;
            RESULT(temp).repeats = i;
            RESULT(temp).currentMethod = currentMethod;
            RESULT(temp).epsilon = epsilon;
            RESULT(temp).N = size(data_Normalize, 2);
            RESULT(temp).runtime = runtime;
            RESULT(temp).CS = CS;
            RESULT(temp).iter = iter;
            RESULT(temp).flagofGlobal = flagofGlobal;
            RESULT(temp).solution = solution;                                 
            RESULT(temp).pair = data_.selectedImg;                                 
            disp([currentMethod, ' ', num2str(i), '-scene finished!'])
            

         end
                 
         close all;
    end

end
