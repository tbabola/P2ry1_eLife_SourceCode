function h = plotTimeSeries(smLIC, smRIC, peaksBinaryL, peaksBinaryR, peakStat,ylimits,histoFlag)
    if nargin < 6
        ylimits = 'auto';
        histoFlag = 0;
    end
    %colors
    lt_org = [255, 166 , 38]/255;
    dk_org = [255, 120, 0]/255;
    lt_blue = [50, 175, 242]/255;
    dk_blue = [0, 13, 242]/255;
    
    Llocs = find(peaksBinaryL);
    [Lr, Lc] = ind2sub(size(peaksBinaryL),Llocs);
    Rlocs = find(peaksBinaryR);
    [Rr, Rc] = ind2sub(size(peaksBinaryL),Rlocs);
    
    statsL = peakStat{1};
    statsR = peakStat{2};
    if ~histoFlag
         histoL = statsL(:,2);
         histoR = statsR(:,2);
    else
        histoL = statsL([statsL(:,3) > ylimits(1) & statsL(:,3) < ylimits(2)],2);
        histoR = statsR([statsR(:,3) > ylimits(1) & statsR(:,3) < ylimits(2)],2);
    end
    
    cmaplim = [0 0.4];
    %single figure for movie
    h = figure('Position',[100 0 300 600]);
    colormap hot;
    pv = [.15 .3 .4 .65];
    subplot('Position',pv);
    imagesc(smLIC');
    caxis(cmaplim);
    xlim([0 125]);
    ylim(ylimits);
    hold on; 
    scatter(Lr, Lc,12,'MarkerEdgeColor','white','LineWidth',1);
    set(gca,'XTick',[]);
    %axis off;
    
    pv = [.58 .3 .4 .65];
    subplot('Position',pv);
    imagesc(smRIC');
    caxis(cmaplim);
    xlim([0 125]);
    ylim(ylimits);
    hold on; 
    scatter(Rr, Rc,12,'MarkerEdgeColor','white','LineWidth',1);
    set(gca,'XTick',[],'XColor','white');
    set(gca,'YTick',[],'YColor','white');
    %axis off;
    
    pv = [.15 .1 .4 .15];
    subplot('Position',pv);
    histogram(histoL,[0:5:125],'FaceColor',lt_org,'EdgeColor',lt_org,'FaceAlpha',1);
    box off;
    xlim([0 125]);
    ylim([0 15]);
    ylabel('# of Events');
    pv = [.58 .1 .4 .15];
    axh = gca;
    axh.TickDir = 'out';
    
    pv = [.58 .1 .4 .15];
     subplot('Position',pv);
     histogram(histoR,[0:5:125],'FaceColor',lt_blue,'EdgeColor',lt_blue,'FaceAlpha',1);
     xlim([0 125]);
     ylim([0 15]);
     set(gca,'XColor');
     set(gca,'YTick',[]);
     box off;
     axh = gca;
     axh.TickDir = 'out';
end
