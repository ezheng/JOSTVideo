function [camera, points3D] = generateData( visualize, totalNumOf3DPoints, noiseLevel,  numOfCameras,numOfImagesPerCam )

% generating 3D points
addpath 'generateSimulatedData\';

points3D = generate3DPoints(totalNumOf3DPoints, noiseLevel, visualize);
for i = 1:numOfCameras
    %     based on numOfImagesPerCam to generate Id sequence
    if(i == 1)
        sDir = 1;
        camera(i).IdSequence = generateIdSequence( numOfImagesPerCam(i), totalNumOf3DPoints, 1, sDir);
    else
        sDir = -1;
        camera(i).IdSequence = generateIdSequence( numOfImagesPerCam(i), totalNumOf3DPoints, totalNumOf3DPoints, sDir );
    end
end
camera = generateCamCenters_Inplane(camera, points3D);
for i = 1:numOfCameras
%     centers and ori is the most inportant parameters. camera orientation
%     is not important at all.
    camera(i).ori = generateCamOri( camera(i).centers , points3D(:,camera(i).IdSequence ) );
end
assert(all(all(points3D(:,camera(1).IdSequence ) == fliplr(points3D(:,camera(2).IdSequence )) )))

rmpath 'generateSimulatedData\';

% initialize t for each camera

totalNumOfImgs = 0;
for i = 1:numOfCameras
    camera(i).numOfImgs = numel(camera(i).IdSequence);
    totalNumOfImgs = totalNumOfImgs + camera(i).numOfImgs;
    camera(i).t = rand( size(camera(i).IdSequence, 1 ) ,1);
    camera(i).pts3D = camera(i).ori .* repmat( camera(i).t,1,3 )' + camera(i).centers; %generate the 3D points given t and centers
%     record the start id for each camera. Used when building the graph
    if(i == 1)
        camera(i).startId = 0;
    else
        camera(i).startId = camera(i-1).startId + camera(i-1).numOfImgs;
    end
    
end