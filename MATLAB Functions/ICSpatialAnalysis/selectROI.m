function [LICmov, RICmov] = selectROI(movie,frame)
    width = round(size(movie,2)/2);
    %rotate images
    rotateRIC = imrotate(movie(:,width:end,:),55);
    rotateLIC = imrotate(movie(:,1:width,:),-55);
    
    CCW = figure;
    imagesc(rotateRIC(:,:,frame));
    colormap gfb;
    caxis([0 0.3]);
    RIC = imrect(gca,[0,0,100,50]);
    setResizable(RIC,0);
    wait(RIC);
    pos = getPosition(RIC);
    pos = int16(round(pos));
    RICmov = rotateRIC(pos(2):pos(2)+pos(4)-1,pos(1):pos(1)+pos(3)-1,:);

    %LIC
    CW = figure;
    imagesc(rotateLIC(:,:,frame));
    colormap gfb;
    caxis([0 0.3]);
    LIC = imrect(gca,[0,0,100,50]);
    setResizable(LIC,0);
    wait(LIC);
    pos = getPosition(LIC);
    pos = int16(round(pos));
    LICmov = rotateLIC(pos(2):pos(2)+pos(4)-1,pos(1):pos(1)+pos(3)-1,:);
end