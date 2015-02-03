function [camera,t] = computeT_noPairwise(camera, pred, table)
% update t and pts3D for each camera

addpath 'C:\Enliang\library_32\cvx';

numOfCams = numel(camera);


numOfAllImages = size(table,2);


% based on the Id, I need to find the points

cvx_begin
    variable t(numOfAllImages);    
    allSum = cvx(0);
    
    for i = 1:numOfCams
        allSum = allSum + computeSumOfChain(camera(i).centers + ...
            camera(i).ori.* repmat(t(camera(i).startId+1: (camera(i).startId + camera(i).numOfImgs))',3,1 ) );
    end        
    

%   compute the pairwise sum. sum based on the tree.
    for i = 1:numel(pred)    
        if(pred(i) ~=0)
            j = pred(i);
            allSum = allSum + computeDist( ...
                camera( table(1,i) ).ori(:, table(2,i)) * t(i) + camera(table(1,i)).centers(:,table(2,i)) ,...
                camera( table(1,j) ).ori(:, table(2,j)) * t(j) + camera(table(1,j)).centers(:,table(2,j)) );
        end
    end

    minimize allSum;
    subject to 
        t>=0; 
    
cvx_end
% yy=0;
% for i = 1:2
%         yy = yy + computeSumOfChain(camera(i).centers + ...
%             camera(i).ori.* repmat(t(camera(i).startId+1: (camera(i).startId + camera(i).numOfImgs))',3,1 ) );
% end   
% for i = 1:numel(pred)
%     if(pred(i) ~=0)
%         j = pred(i);
%         yy = yy + computeDist( ...
%             camera( table(1,i) ).ori(:, table(2,i)) * t(i) + camera(table(1,i)).centers(:,table(2,i)) ,...
%             camera( table(1,j) ).ori(:, table(2,j)) * t(j) + camera(table(1,j)).centers(:,table(2,j)) );
%     end
% end

% update t and pts3D of each camera
for i = 1:numOfCams
    camera(i).t = t(camera(i).startId+1: (camera(i).startId + camera(i).numOfImgs));
    camera(i).pts3D = camera(i).ori .* repmat(camera(i).t,1,3)' + camera(i).centers;
end


end

function d = computeSumOfChain(pts3D)
    d = sum(sum(  (pts3D(:,2:end) - pts3D(:, 1:end-1)).^2 ));    
end

function d= computeDist(p1,p2)
    d = sum((p1 - p2).^2,1);
%        d = 100*norm(p1-p2);
end





