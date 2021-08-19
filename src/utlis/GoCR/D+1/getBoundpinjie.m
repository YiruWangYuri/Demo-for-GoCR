function [U,L] = getBoundpinjie(data, branch, epsilon, dim,bits_per_dim)
    branchNode = [branch(1:dim, :);
                        branch(1:dim, :) + branch(dim+1:end, :)];
    numofthread = size(branch, 2);
    numofnode = 2^dim;
    N = size(data,2);
   for n = 1:numofthread
           [temp_branch]=getChild(branch(:, n), 2, dim, numofnode);
           temp_branch = reshape(temp_branch, dim*2, numofnode);
          Node(dim*(n-1)+1:dim*n, :) = temp_branch(1:dim, :) + 0.5* temp_branch(dim+1:end, :);%(numofthread*dim) * numofnode
    end
    Node = reshape(Node, dim, []); 

    %
    branch_0 = branch(1:dim,:) + 0.5*branch(dim+1:end,:);
    theta_0 = compact2sphere(branch_0); %numthread个branch中心
    radius_cube = 0.5*branch(dim+1,1);
    U_f0 = (epsilon+radius_cube >= pi/2)*1 + (epsilon+radius_cube < pi/2)*sin(epsilon+radius_cube);
    
    theta_Node = compact2sphere(Node); %numofnode*numthread个顶点
    side_cube = 0.25*sqrt(sum((branch(dim+1:end,1).^2)));
    U_fNode = (epsilon+side_cube >= pi/2)*1 + (epsilon+side_cube < pi/2).*sin(epsilon+side_cube);
% angle = acos(data'*theta_0);
    
    U_0 = sum(abs(data'*theta_0)<U_f0,1)/N;
%     U_Node = sum(abs(data'*theta_Node)<U_fNode,1)/N;
    aaa = abs(data'*theta_Node);
    U_Node = sum(aaa<U_fNode,1)/N;

    U_Node = reshape(U_Node, numofthread,[])';
    %
    U = [U_0; U_Node];
    U = max(U);
    L = sum(abs(data'*theta_0)<sin(epsilon),1)/N;

end


% function [U,L] = getBound(data, branch, epsilon, dim,bits_per_dim)
%     branchNode = [branch(1:dim, :);
%                         branch(1:dim, :) + branch(dim+1:end, :)];
%     numofthread = size(branch, 2);
%     numofnode = 2^dim;
%     N = size(data,2);
%    for d = 1:dim
%         temp = [repmat(branchNode(d,:), 1, 2^(dim-d)), repmat(branchNode(d+dim,:), 1, 2^(dim-d))];
%         Node(d,:) = repmat(temp, 1, numofnode*numofthread/numel(temp)); 
%     end
% %     Node = reshape(Node, [], numofnode); %(numofthread*dim) * numofnode
% 
%     %
%     branch_0 = branch(1:dim,:) + 0.5*branch(dim+1:end,:);
%     theta_0 = compact2sphere(branch_0); %numthread个branch中心
%     radius_cube = 0.5*branch(dim+1,1);
%     U_f0 = (epsilon+radius_cube >= pi/2)*1 + (epsilon+radius_cube < pi/2)*sin(epsilon+radius_cube);
%     
%     theta_Node = compact2sphere(Node); %numofnode*numthread个顶点
%     side_cube = repmat(0.5*branch(dim+1,1), 1, numofthread*numofnode);
%     U_fNode = (epsilon+side_cube >= pi/2)*1 + (epsilon+side_cube < pi/2).*sin(epsilon+side_cube);
% % angle = acos(data'*theta_0);
%     
%     U_0 = sum(abs(data'*theta_0)<U_f0,1)/N;
%     U_Node = sum(abs(data'*theta_Node)<U_fNode,1)/N;
%     U_Node = reshape(U_Node, numofthread,[])';
%     %
%     U = [U_0; U_Node];
%     U = max(U);
%     L = sum(abs(data'*theta_0)<sin(epsilon),1)/N;
% 
% end