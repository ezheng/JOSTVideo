function  cameras = generateCamCenters_Inplane(cameras, points3D )

numOfCameras = numel(cameras);

% based on the 3D points to generate an anchor 3D points
centerOfPoints = mean(points3D, 2);
radius = sum((points3D - repmat(centerOfPoints, 1, size(points3D,2))).^2, 1);
radius = sqrt(radius);
maxRadius = max(radius);

% 
cameraC = rand(3,numOfCameras);
cameraC = cameraC - 0.5;

assert( all( sum(cameraC.^2,1) ~= 0) );

cameraC = cameraC ./ repmat(sqrt(sum(cameraC .^2 ,1)), 3,1);
% center plus a random radius
cameraC = repmat(centerOfPoints, 1, size(cameraC, 2)) + cameraC .* (maxRadius * 1.1 + rand(size(cameraC)) * maxRadius); 

[u, ~, ~] = svd(points3D);    
 cameraC = cameraC - u(:,3) * (u(:,3)' * cameraC);
 
%  compute the median minimum distance between cameras
minDist = zeros(numOfCameras, 1);
for i = 1:numOfCameras
    dist = sqrt(sum ((repmat(cameraC(:,i), 1, numOfCameras-1) - cameraC(:, [1:i-1,i+1:end])).^2));
    minDist(i) = min(dist);
end
minDist = median(minDist);      
    
%%testing... 
minDist = 0;

% ---------------------
for i = 1:numOfCameras
    cameras(i).centers = repmat(cameraC(:,i), 1, numel(cameras(i).IdSequence) );
    cameras(i).centers = cameras(i).centers + (rand(size(cameras(i).centers))-0.5) * 0.05*minDist;
    
%     cameras(i).centers = cameras(i).centers - u(:,3) * (u(:,3)' * cameras(i).centers );

end








