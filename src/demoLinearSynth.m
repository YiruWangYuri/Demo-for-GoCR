function [RESULT] = demoLinearSynth(N, OutlierRatio, Dim, Repeats, noise_in, noise_out, timeLimit, selectedMethod, methodList)
% demo program for linear synthetic data
% N: number of data points
% Outlier: outlier ratio 
% Dim: effective dimensionality of linear model, e.g., 2D line fitting:
% ax_i + by_i + c = 0, a^2 + b^2 + c^2 = 1, Dim = 2
% Repeats: times of randomly generated data 

    rng(2); 
    seed = randi(10000,1,1000);
    disp(['****************Linear synthetic experiments *******************'])
    disp(['                Number     dim         Noise       OutlierRatio']);
    disp(['                     ', num2str(N), '           ', num2str(Dim), '            ', num2str(noise_in), '                ', num2str(OutlierRatio*100), '%']);
    disp(['----------------------------------------------------------------------------------------'])
    temp = 0;
    
    for i = 1: Repeats
        [data, para] = PrepareLinearData(N, OutlierRatio, Dim, seed(i), noise_in, noise_out);
   
        %% excute each method in each data
          data_Normalize = [data(1:end-2,:); data(end, :); data(end-1,:)]';                
          for idxMethod = selectedMethod
              currentMethod = methodList{idxMethod};
              %solInit
              if strcmp(currentMethod, 'GoCR') 
                  solInit = rand(size(data_Normalize,1),1);
              end
                    
              %prepare parameters--inlier thre
              if strcmp(currentMethod, 'GoCR')  
                  epsilon = 1.5*para.noise;
              end
                    
              %gap
              gap = 0; %the relative gap between Upper and Lower bound
              
              [runtime, solution, CS, flagofGlobal, iter, outindex] = SloveLinearProm(currentMethod, data_Normalize, Dim, solInit, epsilon, timeLimit, gap);           
 
              temp = temp + 1;
              RESULT(temp).repeats = i;
              RESULT(temp).currentMethod = currentMethod;
              RESULT(temp).N = N;
              RESULT(temp).dim = Dim;
              RESULT(temp).noise = noise_in;
              RESULT(temp).outlier = OutlierRatio;
              RESULT(temp).runtime = runtime;
              RESULT(temp).CS = CS;
              RESULT(temp).iter = iter;
              RESULT(temp).flagofGlobal = flagofGlobal;
              RESULT(temp).solution = solution;
              disp([currentMethod, 'done!'])
          end
              
    end
            

    disp('*****************************************************************');
end
