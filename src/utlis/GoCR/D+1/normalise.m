% NORMALISE2DPTS - normalises 2D homogeneous points
%
% Function translates and normalises a set of 2D homogeneous points 
% so that their centroid is at the origin and their mean distance from 
% the origin is sqrt(2).  This process typically improves the
% conditioning of any equations used to solve homographies, fundamental
% matrices etc.
%
% Usage:   [newpts, T] = normalise2dpts(pts)
%
% Argument:
%   pts -  3xN array of 2D homogeneous coordinates
%
% Returns:
%   newpts -  3xN array of transformed 2D homogeneous coordinates.  The
%             scaling parameter is normalised to 1 unless the point is at
%             infinity. 
%   T      -  The 3x3 transformation matrix, newpts = T*pts
%           
% If there are some points at infinity the normalisation transform
% is calculated using just the finite points.  Being a scaling and
% translating transform this will not affect the points at infinity.

% Peter Kovesi
% School of Computer Science & Software Engineering
% The University of Western Australia
% pk at csse uwa edu au
% http://www.csse.uwa.edu.au/~pk
%
% May 2003      - Original version
% February 2004 - Modified to deal with points at infinity.


function [newpts, T, scale] = normalise(pts)

    dim = size(pts,2);
    num = size(pts,1);
        
    % Find the indices of the points that are not at infinity
    finiteind = find(abs(pts(:,end)) > eps);
    
    if length(finiteind) ~= size(pts,1)
        warning('Some points are at infinity');
    end
    
    % For the finite points ensure homogeneous coords have scale of 1
    for i = 1:dim-1
        pts(finiteind,i) = pts(finiteind,i)./pts(finiteind,end);
    end
    pts(finiteind,end) = 1;
    
    
    c = mean(pts(finiteind,1:dim-1))';            % Centroid of finite points
    for i = 1:dim-1
        newp(finiteind,i) = pts(finiteind,i)-c(i);    % Shift origin to centroid.
    end
    
    meandist = mean(sqrt(sum(newp(finiteind,:).^2,2)));
    scale = sqrt(dim-1)/meandist;
    %disp(scale);
    %c(1) = 0; c(2) = 0;
    %scale = 1;
    T = zeros(dim, dim);
    T(dim, dim)=1;
    
    for i = 1:dim-1
        T(i,i)=scale;
        T(end,i)=-scale*c(i);
    end
%     [scale       0           0
%       0          scale       0
%     -scale*c(2)  -scale*c(1) 1];
    
    newpts = pts*T;
    
    