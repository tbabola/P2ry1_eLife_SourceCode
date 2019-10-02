function plotTimeSeries(smLIC, smRIC, peaksBinaryL, peaksBinaryR, peakStat)
    Llocs = find(peaksBinaryL);
    [Lr, Lc] = ind2sub(size(peaksBinaryL),Llocs);
    Rlocs = find(peaksBinaryR);
    [Rr, Rc] = ind2sub(size(peaksBinaryL),Rlocs);
    
    statsL = peakStat{1};
    statsR = peakStat{2};
    histoL = statsL(:,2);
    histoR = statsR(:,2);
    
    
    %single figure for movie
    p = figure('Position',[100 0 300 600]);
    set(p,'Color','black');
    colormap jet;
    pv = [.15 .3 .4 .65];
    subplot('Position',pv);
    imagesc(smLIC');
    caxis([0 0.8]);
    xlim([0 125]);
    ylim([000 3000]);
    hold on; 
    scatter(Lr, Lc,'MarkerEdgeColor','white','LineWidth',1);
    set(gca,'XTick',[],'XColor','white','YColor','white');
    %axis off;
    
    pv = [.58 .3 .4 .65];
    subplot('Position',pv);
    imagesc(smRIC');
    caxis([0 0.8]);
    xlim([0 125]);
    ylim([0000 3000]);
    hold on; 
    scatter(Rr, Rc,'MarkerEdgeColor','white','LineWidth',1);
    set(gca,'XTick',[],'XColor','white');
    set(gca,'YTick',[],'YColor','white');
    %axis off;
    
    pv = [.15 .1 .4 .15];
    subplot('Position',pv);
    histogram(histoL,25,'FaceColor','white','EdgeColor','White','FaceAlpha',1);
    set(gca,'Color','black');
    xlim([0 125]);
    ylim([0 30]);
    ylabel('# of Events');
    set(gca,'XColor','white','YColor','white');
    pv = [.58 .1 .4 .15];
    
     subplot('Position',pv,'Color','black');
     histogram(histoR,25,'FaceColor','white','EdgeColor','White','FaceAlpha',1);
     set(gca,'Color','black');
     xlim([0 125]);
     ylim([0 30]);
     set(gca,'XColor','white');
     set(gca,'YTick',[],'YColor','white');
    
     
%      C = imfuse(smLIC',fliplr(smRIC'),'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
%      left = zeros(size(C));
%      left(:,:,1) = C(:,:,1);
%      mid = zeros(size(C));
%      mid(:,:,2) = C(:,:,2);
%      
%      %figure; imagesc([C(:,:,1) C(:,:,2) C]);
%      figure; imagesc([left mid C],[254 255]);
%      
%      thr = 0.05;
%      [m,n] = size(smLIC);
%      LICbin = smLIC > thr;
%      
%      RICbin = smRIC> thr;
%      C = imfuse(LICbin',fliplr(RICbin)','falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
%      left = zeros(size(C));
%      left(:,:,1) = C(:,:,1);
%      mid = zeros(size(C));
%      mid(:,:,2) = C(:,:,2);
%      figure; imagesc([left mid C]);
%     
    %figure;
    
end
