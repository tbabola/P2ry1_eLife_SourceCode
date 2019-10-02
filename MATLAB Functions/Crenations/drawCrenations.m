function [h, h2] = drawCrenations(events,locs,totalTime,baseImg)

    h = figure;
    imshow(baseImg); hold on;
    %colormap ghtmp;
    cm = hsv; 

    for i = 1:size(locs,1)
       b = bwboundaries(events(:,:,i));
       for j = 1:size(b,1)
           temp = b{j};
           patch(smooth(temp(:,2)),smooth(temp(:,1)),cm(round(locs(i)/totalTime*64),:),'FaceAlpha',0.4,'LineStyle','none');
       end
    end
    
    h2 = colorTicks(locs,totalTime);
end

