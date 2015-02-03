function test()

close all; clear; clc;

numOfCameras = 2;
totalNumOf3DPoints = 500;
numOfImagesPerCam = ones(1,numOfCameras) * totalNumOf3DPoints;  %number of images is the same for each camera
noiseLevel = 0; visualize = false;

rng('default');

[camera, points3D] = generateData(visualize, totalNumOf3DPoints, noiseLevel, numOfCameras,numOfImagesPerCam);

%%
% compute (1) given random t, compute connection. This is done through MST

% build index table. 1st row: camera id, 2nd row: image id in that camera
totalNumOfImgs = sum(numOfImagesPerCam);
table = buildTable(camera,totalNumOfImgs);

plot3DPointsCams(points3D, camera);

tic
pred = zeros(1, totalNumOfImgs);
ii = 0;

while (true)
    ii = ii +1;
    
%     % construct a graph, and then compute the mst     
%     UG = sparse(totalNumOfImgs, totalNumOfImgs);    
%     for i = 1:numOfCameras 
%         xPos = camera(i).startId + [1:camera(i).numOfImgs]; %note here the id is global id, since startId of each cam was used
%         for j = i+1 : numOfCameras
%             distMatrix =  pdist2(camera(i).pts3D', camera(j).pts3D');
%             distMatrix = distMatrix .^2; distMatrix = distMatrix';
%             yPos = camera(j).startId + [1:camera(j).numOfImgs];
%             
%             [meshX, meshY] = meshgrid( xPos,yPos  );
%             
%             UG( sub2ind(size(UG), meshX(:),meshY(:))) = distMatrix(:);
%         end
%     end   
%     UG = UG';   %use the lower parts of the matrix    
%     % view(biograph(UG,[],'ShowArrows','off','ShowWeights','on'));
%     [~,pred] = graphminspantree(UG);
%     % view(biograph(ST,[],'ShowArrows','off','ShowWeights','on'))
    for i = 1:numOfCameras
        %          xPos = camera(i).startId + [1:camera(i).numOfImgs];
        for j = i+1 : numOfCameras
            distMatrix =  pdist2(camera(i).pts3D', camera(j).pts3D');
            [~, idx] = min(distMatrix,[],2 );
            pred( (camera(i).startId+1) : (camera(i).startId + camera(i).numOfImgs) ) = idx + camera(j).startId;
            [~, idx] = min(distMatrix,[],1 );
            pred( (camera(j).startId+1) : (camera(j).startId + camera(j).numOfImgs) ) = idx + camera(i).startId;
        end
    end
    
    
    %%    
    % (2) given connection, compute t. This is done through a convex program  
    %     update T and pts3d
%     pred = [0 10 9 8 7 5 4 3 2 1];
%     pred = [10 9 8 7 6]
    [camera, newT] = computeT(camera, pred, table);
      
    cost = computeCost(camera, pred, table)
    
    if(ii == 1)
        oldT = newT;
        continue;
    end
    diff = newT - oldT;
    fprintf(1, 'diff is: %.10f, iter: %d\n',  norm(diff), ii );
    oldT = newT;
    if( norm(diff) == 0)
        break;
    end
    
end
toc
% [camera, ~] = computeT_noPairwise(camera, pred, table);

save xxx.mat

h = figure(2); clf;    hold on;
    plot3( points3D(1,:), points3D(2,:), points3D(3,:) ,'k*'); axis equal;
    for i = 1:numel(camera)
        hold on
        if(i == 1)
             plot3( camera(i).pts3D(1,:), camera(i).pts3D(2,:), camera(i).pts3D(3,:) ,'r*');
        else
            plot3( camera(i).pts3D(1,:), camera(i).pts3D(2,:), camera(i).pts3D(3,:) ,'b*');
        end        
        plot3( camera(i).centers(1,1), camera(i).centers(2,1), camera(i).centers(3,1), 'ro');
        hold off
    end    
%     plot connection
    plotConnection(camera, pred, table, h);

    hold off;

% save yyy.mat;
% figure(4); clf;    hold on;
% plot3( pts1(1,:), pts1(2,:), pts1(3,:) ,'k*');
% plot3( pts2(1,:), pts2(2,:), pts2(3,:) ,'k*');
% % plot3( allCamCenters(1,:), allCamCenters(2,:), allCamCenters(3,:) ,'r*');
% plot3( points3D(1,:), points3D(2,:), points3D(3,:) ,'b*');
% hold off;
% 
% 
% newT = computeT_noPairwise(camera, ST);
% t1 = newT(1:numOfNodes1); t1 = t1';
% t2 = newT(numOfNodes1+1: numOfNodes1 + numOfNodes2); t2 = t2';
% t = [t1;t2];
% 
% 
% 
% for i = 1:2
%     
% %     pts = camera(i).ori .* repmat(t(i,:) , 3, 1) + repmat(camera(i).center, 1, numOfNodes1) ;
%     figure(2); hold on; 
%     plot3( pts2(1,:), pts2(2,:), pts2(3,:) ,'y*');
%     hold off;
% 
% end

































