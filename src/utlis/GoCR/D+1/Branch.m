function [new_branch] = Branch(best_branch, bits_per_dim, dim)
%BRANCH 此处显示有关此函数的摘要
%   此处显示详细说明
NumofBranch = bits_per_dim^dim;
flag_ZYX = [];
for i = 0:NumofBranch-1
   [flag_ZYX] = [flag_ZYX; dec2bin(i, dim)];
end

flag_XYZ = zeros(dim, NumofBranch);
for i = 1:dim
    for j = 1:NumofBranch
        if (flag_ZYX(j,i)=='1')
            flag_XYZ(end+1-i, j)=1;
        else
            flag_XYZ(end+1-i, j)=0;
        end
    end
end
new_branch = repmat(best_branch, 1, NumofBranch);
new_branch(1:dim, :) = new_branch(1:dim, :)+new_branch(dim+1 : end, :)/bits_per_dim.*flag_XYZ;
new_branch(dim+1:end, :) = new_branch(dim+1:end, :)/bits_per_dim;

end
