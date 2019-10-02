function [cth] = colorTicks(locs,totalTime)
%colorTicks Generates color ticks that correspond to times of crenations
%   locs: time of peak
%   totalTime: length of recording
    
    cth = figure;
    cm = hsv;
    for i = 1:size(locs,1)
        line([locs(i) locs(i)],[-1 1],'Color',cm(round(locs(i)/totalTime*64),:)); hold on;
    end
    xlim([0 totalTime]);
    set(gca,'xtick',[0 totalTime]);
    set(gca,'ytick',[]); 

end

