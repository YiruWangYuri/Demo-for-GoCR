function [new_branch] = selectBranch(new_branch, dim)
    left = new_branch(1:dim,:);
    right = left+new_branch(dim+1:end,:);
    
    flag = (left.*right<0);
    branch_r_min = min(abs(left),abs(right));
    branch_r_min(flag) = 0;
    r_min = sqrt(sum(branch_r_min.*branch_r_min,1));
    
    new_branch(:,r_min>pi/2)=[];

end