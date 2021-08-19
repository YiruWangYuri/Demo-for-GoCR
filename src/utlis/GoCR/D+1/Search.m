function [h_L,h_U,T_best,iter,flagofGlobal] = Search(data, solInit, epsilon, dim, bits_per_dim,gap,timeLimit)
%    Search 此处显示有关此函数的摘要
%   此处显示详细说明

% initialization，用branch左下角点+branch宽度来表示一个branch
WidthofParameter = pi; %每一维参数的宽度
best_branch_ = -pi/2 * ones(dim, 1);
best_branch = [best_branch_; WidthofParameter * ones(dim,1)];

branch=[];
branchnum = 0;
branchU_pq = PriorityQueue();

best_lower = sum(abs(data'*solInit)<epsilon,1)/size(data, 2);
iter=1;
num_thread = bits_per_dim^dim;

dataNorm = sqrt(sum(data.*data));
epsilon_i = asin(epsilon./dataNorm);

%%% display the process of BnB
% figure
% 
% h1=animatedline;
% h2=animatedline;


while true
    
    [new_branch]=getChild(best_branch, bits_per_dim, dim, num_thread);
    new_branch = reshape(new_branch, dim*2, num_thread);    
    new_branch=selectBranch(new_branch, dim);
    if (size(new_branch, 2) ~= 0)
        [new_upper,new_lower] = getBound(data, new_branch, epsilon, dim, dataNorm, epsilon_i);
        [new_best_lower,ind_lower_]=max(new_lower);

        %算法的解，由下界的真实值来提供
        if(best_lower<=new_best_lower)
            best_lower=new_best_lower;
            T_branch=new_branch(:,ind_lower_);
            T_best=T_branch(1:dim)+0.5*T_branch(dim+1:end);
        end


        in_flag = new_upper >= best_lower;
        temp = [new_branch(:, in_flag); new_upper(in_flag); new_lower(in_flag)];
        branch=[branch,temp(:, :)];
        for nk = branchnum + 1 : branchnum + size(temp, 2)
            branchU_pq.push(nk, branch( end-1, nk));
        end
         branchnum = branchnum + size(temp, 2);
       

    else
        disp('pass');
    end

    
%     [best_upper1,ind_upper1]=max(branch(end-1,:));   
    best_upper = branchU_pq.top_value(); % Take a peek at the top of the queue. This should be 200
%     size_actual = branchU_pq.size();
    ind_upper = branchU_pq.top(); % Get the ID of the top value. This should be 3
    branchU_pq.pop(); % Pop (remove) the top

    h_L(iter)=best_lower;
    h_U(iter)=best_upper;     
    best_branch(:, 1)=branch(1:2*dim,ind_upper);        
    branch(end-1,ind_upper)=-1e10;
    branch(end,ind_upper)=1e10;
    

%     addpoints(h1,iter,h_U(iter));
%     addpoints(h2,iter,h_L(iter));
%     drawnow

%    best_upper-best_lower
    if(best_upper-best_lower<=gap)
        flagofGlobal = true;        
        break;  
    end
    
    ttt = toc;
    if ttt >= timeLimit
        flagofGlobal = false;
        break;
    end   

    iter=iter+1;

end
%     figure
%     hold on
%     plot(1:iter, h_L);
%     plot(1:iter, h_U);    
end


