function table = buildTable(camera,totalNumOfImgs)

if(nargin == 1)
    for i = 1:numel(camera)
        totalNumOfImgs = totalNumOfImgs + numel(camera(i).IdSequence);
    end
end

table = zeros(2, totalNumOfImgs);

id = 0;
for i = 1:numel(camera)
    startId = id+1;
    endId = startId + numel(camera(i).IdSequence) - 1;    
    id = endId;
    
    table(1, startId:endId) = i;
    table(2, startId:endId) = [1:camera(i).numOfImgs];    
end





