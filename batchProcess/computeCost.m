function allSum = computeCost(camera, pred, table )

numOfCams = numel(camera);

allSum = 0;
for i = 1:numOfCams
    %         allSum = allSum + computeSumOfChain(camera(i).centers + ...
    %             camera(i).ori .* repmat(camera(i).t,1,3)' );
    allSum = allSum + computeSumOfChain( camera(i).pts3D    );
end
    
%   compute the pairwise sum. sum based on the tree.
for i = 1:numel(pred)
    if(pred(i) ~=0)
        j = pred(i);
        allSum = allSum + computeDist( ...
            camera( table(1,i) ).pts3D(:,table(2,i)), ...
            camera( table(1,j) ).pts3D(:,table(2,j)) );
    end
end
    
end

function d = computeSumOfChain(pts3D)
    d = sum(sum(  (pts3D(:,2:end) - pts3D(:, 1:end-1)).^2 ));    
end

function d= computeDist(p1,p2)
    d = sum((p1 - p2).^2,1);
end
