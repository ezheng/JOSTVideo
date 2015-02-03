function [camera,t] = computeT_direction(camera, pred, table,ptsDirection )
% update t and pts3D for each camera

addpath 'C:\Enliang\library\cvx';

numOfCams = numel(camera);


numOfAllImages = size(table,2);


% based on the Id, I need to find the points

cvx_begin
    variable t(numOfAllImages);    
    allSum = cvx(0);
    
    for i = 1:numOfCams
        chainPoints = camera(i).centers + ...
            camera(i).ori.* repmat(t(camera(i).startId+1: (camera(i).startId + camera(i).numOfImgs))',3,1 );
        %   compute sum of the square for each of the chain    
        allSum = allSum + computeSumOfChain( chainPoints );
        %   compute the orientation cost
        for j = 1:size(chainPoints, 2)-1
             allSum = allSum + 100* computeChainDirectionError( chainPoints(:,j), chainPoints(:,j+1), ptsDirection(:,1) );
        end
    end
    
%   compute the pairwise sum. sum based on the tree. i is the index of one
%   camera, j is the index of another camera
    for i = 1:numel(pred)    
        if(pred(i) ~=0)
            j = pred(i);
            p1 = camera( table(1,i) ).ori(:, table(2,i)) * t(i) + camera(table(1,i)).centers(:,table(2,i));
            p2 = camera( table(1,j) ).ori(:, table(2,j)) * t(j) + camera(table(1,j)).centers(:,table(2,j)); 
            allSum = allSum + computeDist( p1, p2 );
                
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

function d = computeChainDirectionError(p1, p2, dir)
    d = sum( cross(p1-p2, dir).^2 );

end

function d = computeSumOfChain(pts3D)
    d = sum(sum(  (pts3D(:,2:end) - pts3D(:, 1:end-1)).^2 ));    
end

function d= computeDist(p1,p2)
    d = 0.1* sum((p1 - p2).^2,1);
end





