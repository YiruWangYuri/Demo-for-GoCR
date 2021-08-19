function [U,L] = getBound(data, branch, epsilon, dim, dataNorm, epsilon_i)

branch_0 = branch(1:dim,:) + 0.5*branch(dim+1:end,:);
theta_0 = compact2sphere(branch_0);
radius_cube = 0.5*sqrt(sum((branch(dim+1:end,1).^2)));

N = size(data,2);
U_f = (epsilon_i+radius_cube >= pi/2).*dataNorm + (epsilon_i+radius_cube < pi/2).*sin(epsilon_i+radius_cube).*dataNorm;
% angle = acos(data'*theta_0);
    aaa = abs(data'*theta_0);
U = sum(aaa<U_f',1)/N;
L = sum(abs(data'*theta_0)<epsilon,1)/N;

end