function [result, REConsensusSet, iter, flagofGlobal, outindex] = GoCR(data, solInit, epsilon, gap, timeLimit)
        
        if gap == -1
            error('gap cannot be negtive!');
        end
        d = size(data,1)-1;
        cd(['src\utlis\GoCR\','D+1'])
        compact_dim = d;
        bits_per_dim = 2;
        [h_L,h_U,result_compact,iter,flagofGlobal] = Search(data, solInit, epsilon, compact_dim, bits_per_dim,gap,timeLimit);
        result = compact2sphere(result_compact);
        REConsensusSet = sum(abs(data'*result)<(epsilon)+eps,1);
        outindex = abs(data'*result)>=(epsilon)+eps;

        cd('../../../..')
end