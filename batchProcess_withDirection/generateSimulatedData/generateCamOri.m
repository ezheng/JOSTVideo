function oriPerCam = generateCamOri( centersPerCam, points3DPerCam )

oriPerCam = points3DPerCam - centersPerCam;
oriPerCam = oriPerCam ./ repmat( sqrt(sum(oriPerCam.^2, 1) ),  3, 1);


