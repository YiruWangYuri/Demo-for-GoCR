function [V] = getVolume(B,dim)
%GETVOLUME �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
K=B(dim+1:end-2,:);

temp = K(1,:);
for i = 2:dim
    temp = temp.*K(i,:);
end
V=sum(temp,2)/(pi^dim);

end

