function IdSequence = generateIdSequence( numOfImages, totalNumOf3DPoints, sId, sDir)

% generate the startId from [1, totalNumOf3DPoints]
startId = randi(totalNumOf3DPoints, 1);
assert(startId >=1 & startId <= totalNumOf3DPoints);

% generate the skip step size. The step size can be 1, 2 or 3. It is
% constant across the whole sequence
skipId = randi(3, 1 );

% sequence direction
sequenceDir = round(randi(2,1)*2-1);

%% 
% This part is for testing purpose
% startId = 1;
skipId = 1;
startId = sId;
sequenceDir = sDir;
%% 

% based on the skipId, generate sequences. The sequence is at most two-direction sequence.
 
if(sequenceDir == 1)

    IdSequence = [startId:skipId:totalNumOf3DPoints]';
    
    if(numel(IdSequence) >= numOfImages)
        IdSequence = IdSequence(1:numOfImages);
    else
        remainingLength = numOfImages - numel(IdSequence);
        endId = (totalNumOf3DPoints - (remainingLength-1) * skipId  );
        endId = max(endId, 0);
        IdSequence = [IdSequence; [totalNumOf3DPoints:(-skipId): endId] ];
    end
    
else
    
    IdSequence = [startId:-skipId:1]';
    
    if(numel(IdSequence) >= numOfImages)
        IdSequence = IdSequence(1:numOfImages);
    else
        remainingLength = numOfImages - numel(IdSequence);
        endId = (1 + (remainingLength-1) * skipId  );
        endId = min(endId, totalNumOf3DPoints);
        IdSequence = [IdSequence; [1:(skipId): endId] ];
    end    
end




