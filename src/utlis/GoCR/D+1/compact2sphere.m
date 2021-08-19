function [theta_0] = compact2sphere(branch_0)

temp_cos = cos(sqrt(sum(branch_0.^2)));
temp = sin(sqrt(sum(branch_0.^2)));
temp_sin = repmat(temp, size(branch_0,1) , 1);
temp = sqrt(sum(branch_0.^2)); temp(temp == 0) = eps;
temp_branch_0 = branch_0./temp;
theta_0 = [temp_cos; temp_branch_0.*temp_sin];

end