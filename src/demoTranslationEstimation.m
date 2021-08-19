function [RESULT] = demoTranslationEstimation(Data, epsilon_IN, timeLimit, selectedMethod, methodList)
% demo program for translation estimation
% KITTI Odometry dataset
% Data: prepocessed data 
% epsilon: inlier threshold

%% prepare data
    disp(['****************Translation estimation experiments *******************'])
    disp(['----------------------------------------------------------------------------------------'])
    Repeats = size(Data, 2);
    temp=0;
    for i = 1: Repeats   
        % In one image pair, 
        % originaldata: the location of 2D matching points
        % data: y*Ry' in eq.(20) 
        % t_GT(1)*data(1,:) + t_GT(2)*data(2,:) + t_GT(3)*data(3,:) =
        % 0;
        data_ = Data{i};
        data = data_.data;
        data_Normalize = [data(1:end-2, :); data(end, :); data(end-1,:)];
      
         for idxMethod = selectedMethod
            currentMethod = methodList{idxMethod};    
            %solInit 
            if strcmp(currentMethod, 'GoCR') 
                solInit = rand(size(data_Normalize,1),1);                
            end   

             %prepare parameters--inlier thre
             if strcmp(currentMethod, 'GoCR') 
                epsilon = epsilon_IN;
            end      

             %gap  
            gap = 0; %the relative gap between Upper and Lower bound    
            [runtime, solution, CS, flagofGlobal, iter, outindex] = SloveLinearProm(currentMethod, data_Normalize, 3, solInit, epsilon, timeLimit, gap);           

            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%  RESULT =  [i, method, N, dim, noise, outlierRatio, runtime, flagofGlobal, iter, CS, solution]  %%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
            temp = temp + 1;
            RESULT(temp).repeats = i;
            RESULT(temp).currentMethod = currentMethod;
            RESULT(temp).viewIDL = data_.viewIDL;
            RESULT(temp).viewIDR = data_.viewIDR;
            RESULT(temp).epsilon = epsilon;
            RESULT(temp).N = size(data_Normalize, 2);
            RESULT(temp).runtime = runtime;
            RESULT(temp).CS = CS;
            RESULT(temp).iter = iter;
            RESULT(temp).flagofGlobal = flagofGlobal;
            RESULT(temp).solution = solution;                                 
            disp([currentMethod, ' ', num2str(i), '-scene finished!'])
            
%             figure
%             imagesc(cat(2, data_.imLrgb, data_.imRrgb));
%             hold on
%             plot(data_.originaldata(1,:), data_.originaldata(2,:), 'r+', 'MarkerSize', 10);
%             hold on
%             plot(data_.originaldata(4,:)+size(data_.imLrgb, 2), data_.originaldata(5,:), 'b+','MarkerSize', 10);
%             
%             flag_in = 1:size(data_.originaldata, 2);
%             flag_out = outindex;
%             flag_in(flag_out)=[];
%             xa = data_.originaldata(1,:);
%             ya = data_.originaldata(2,:);
%             xb = data_.originaldata(4,:)+size(data_.imLrgb,2);
%             yb = data_.originaldata(5,:);
%             
%             h = line([xa(flag_in); xb(flag_in)], [ya(flag_in); yb(flag_in)]);
%             set(h, 'linewidth', 1, 'color','g');
%             ho = line([xa(flag_out); xb(flag_out)], [ya(flag_out); yb(flag_out)]);
%             set(ho,'linewidth',1,'color','r');
         end
                 
   
    end

end
