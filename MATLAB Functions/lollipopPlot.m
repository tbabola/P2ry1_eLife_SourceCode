function [figh1, figh2] = lollipopPlot(pkData)
    LIC_big = pkData(pkData(:,7)==1,:);
    RIC_big = pkData(pkData(:,7)==2,:);
    
    %colors for plot
    lt_org = [255, 166 , 38]/255;
    dk_org = [255, 120, 0]/255;
    lt_blue = [50, 175, 242]/255;
    dk_blue = [0, 13, 242]/255;

    figh1 = figure;
    line([(-pkData(:,2))'; zeros(size(pkData,1),1)'],[-pkData(:,1)'; -pkData(:,1)'],'Color',lt_org,'LineWidth', 0.25);
    hold on;
    line([zeros(size(pkData,1),1)'; (pkData(:,4))'; ],[-pkData(:,3)'; -pkData(:,3)'],'Color',lt_blue,'LineWidth', 0.25);
    line([0 0]',[-6050 50]','Color',[0.6 0.6 0.6],'LineWidth', 0.75);
    scatter(pkData((pkData(:,7)==2),4),-pkData((pkData(:,7)==2),3),pkData(pkData(:,7)==2,5)*40,dk_blue,'MarkerFaceColor', dk_blue);
    scatter(-pkData((pkData(:,7)==1),2),-pkData((pkData(:,7)==1),1),pkData(pkData(:,7)==1,5)*40,dk_org,'MarkerFaceColor', dk_org);
    set(figh1,'Position',[200,0,350,500]);
    xlim([-0.4 0.4]);
    ylim([-6050 50]);
    set(gca,'LooseInset',get(gca,'TightInset')) 
    figQuality(figh1,gca,[1.6 2.3]);

    Rpks = pkData((pkData(:,7)==2),4);
    Lpks = pkData((pkData(:,7)==1),2);
    hold off;
    binLim = [0 0.02:.05:.35 100];
    Rcounts= histcounts(Rpks,binLim);
    Lcounts =histcounts(Lpks,binLim);
    binY = [0 .0450:.05:.35];
    
        
    figh2 = figure;
    h = barh(binY(2:end),Rcounts(2:end),.9,'FaceColor',lt_blue,'EdgeColor','white');
     hold on;
     barh(binY(2:end),-Lcounts(2:end),.9,'FaceColor',lt_org,'EdgeColor','white');
    line([0 0],[0 0.4],'LineWidth',0.75,'Color',[0.6 0.6 0.6]);


   xax_lim = [-60 60];
    xtick = [-60 -30 0 30 60];
    xticklabel = {'60' '30' '0' '30' '60'};
    xlim(xax_lim);
    xticks(xtick);
    xticklabels(xticklabel);
    ylim([0 .40]);
    yticks([0 .2 .4]);
    yticklabels({'0' '20' '40'});
    box off;
    xlabel('# of Dominant Events','FontSize',8);
    ylabel('\DeltaF/F (%)','FontSize',8);
    set(gca,'LooseInset',get(gca,'TightInset')) 
    figQuality(figh2,gca,[1.7 1.2]);
end

