function [runtime, sol, CS, flagofGlobal, iter, outindex] = SloveLinearProm(method, data, dim, solInit, epsilon, timeLimit, gap)

    if nargin < 7
        gap = -1;
    end
    if nargin < 6
        timeLimit = -1;
    end
    if dim+1 ~= size(data, 1) && dim ~= size(data, 1)
        error('The input data shoule be dim*N !');
    end
    
    tic;
    if strcmp(method, 'GoCR')     
        [sol, CS, iter, flagofGlobal, outindex] = GoCR(data, solInit, epsilon, gap, timeLimit); 
    end
    runtime = toc;
 
end