function h = plotSCactivity(bin, Rbin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    time = [1:1:size(bin,1)]/10;
    h = figure; %plot(sum(-bin,2),-time); hold on; plot(sum(Rbin,2),-time);
    l = getRealEvents(bin);
    r = getRealEvents(Rbin);
    area(-time,-l,'FaceColor','k'); hold on;
    area(-time,r,'FaceColor','k');
    xlim([-600 0]);
    ylim([-200 200])
    set(gca,'view',[90 -90])
    figQuality(gcf,gca,[4 6]/2)
end

function [realEvents] = getRealEvents(bin)
     labels = bwlabel(smooth(sum(bin,2),10));
     n_labels = zeros(size(labels));
     for i = 1:max(labels)
         lbl_idx = find(labels == i);
         if size(lbl_idx,1) > 50
             n_labels(lbl_idx) = 1;
         else
             
         end
     end
     realEvents = sum(bin,2).*n_labels;
end

