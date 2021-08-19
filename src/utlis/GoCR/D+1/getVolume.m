function [V] = getVolume(B,dim)
%GETVOLUME 此处显示有关此函数的摘要
%   此处显示详细说明
K=B(dim+1:end-2,:);

temp = K(1,:);
for i = 2:dim
    temp = temp.*K(i,:);
end
V=sum(temp,2)/(pi^dim);

end

