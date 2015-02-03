function points3D = generate3DPoints(numOfCameras, noiseLevel, visualize)

if(nargin < 2)
    noiseLevel = 1;
end
if(nargin < 3)
    visualize = false;
end

L1 = rand(3,1);
L1 = L1/ norm(L1); L1(3) = 0;

theta = linspace(0,1,numOfCameras);

points3D = L1 * theta;

points3D = points3D - repmat(mean(points3D,2), 1, size(points3D,2));
scale = sqrt( sum(points3D(:).^2));
points3D = points3D./scale;

if(visualize)
    figure(1);
    plot3(points3D(1,:), points3D(2,:), points3D(3,:), '*');    
end
