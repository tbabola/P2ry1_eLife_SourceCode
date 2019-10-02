function [events] = getCrenationAreas(imgThr, locs)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    [m,n,T] = size(imgThr);
    events = zeros(m,n,size(locs,1),'logical');
    for i = 1:size(locs,1)
        tempImg = imgThr(:,:,locs(i));
        tempImg = bwareaopen(tempImg,12);
        tempImg = imgaussfilt(double(tempImg),12);
        vals = tempImg(tempImg > 0);
        thr = prctile(vals,20);
        tempImg = tempImg > thr;
        tempImg = bwareaopen(tempImg,2500);
        events(:,:,i) = tempImg;
    end

end

