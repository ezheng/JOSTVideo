function  plotConnection(camera, pred, table, h)


figure(h);
hold on;

for i = 1:size(pred, 2)
%     match = pred(:,i);
    
    if( pred(i) ~= 0 )
        camIdx1 = table(1, i);
        ptsIdx1 = table(2, i);
        camIdx2 = table(1, pred(i) );
        ptsIdx2 = table(2, pred(i) );
        
        X = [camera(camIdx1).pts3D(1,ptsIdx1), camera(camIdx2).pts3D(1,ptsIdx2) ];
        Y = [camera(camIdx1).pts3D(2,ptsIdx1), camera(camIdx2).pts3D(2,ptsIdx2) ];
        Z = [camera(camIdx1).pts3D(3,ptsIdx1), camera(camIdx2).pts3D(3,ptsIdx2) ];
        plot3( X,Y,Z );
        
    end
end

hold off;