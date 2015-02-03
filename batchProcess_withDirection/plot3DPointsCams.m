function plot3DPointsCams(points3D, camera)


% show 3 points and camera centers
figure(2); clf;    

hold on;
plot3( points3D(1,:), points3D(2,:), points3D(3,:) ,'k*'); axis equal;

if(nargin == 2)
    for i = 1:numel(camera)
        hold on
        plot3( camera(i).centers(1,1), camera(i).centers(2,1), camera(i).centers(3,1), 'ro');
        hold off
    end
end

hold off;
