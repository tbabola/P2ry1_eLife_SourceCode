function [p, c] = compare3(group1, group2, group3, conditions, ylbl, dim, markSz, color1, color2, color3)

       if nargin < 8
           color1 = 'k';
           color2 = 'r';
           color3 = 'r';
       end
       if nargin < 7
           meanMarkSize = 30;
           markSize = 27;
       else
           markSize = markSz(1);
           meanMarkSize = markSz(2);
       end

       m = size(group1',1);
       m2 = size(group2',1);
       m3 = size(group3',1);
       l_grey = [0.7 0.7 0.7];
       
       mean1 = nanmean(group1',1);
       std1 = sterr(group1',1);
       mean2 = nanmean(group2',1);
       std2 = sterr(group2',1);
       mean3 = nanmean(group3',1);
       std3 = sterr(group3',1);
       
       h = figure;
       scatter(1*ones(m,1), group1',markSize,l_grey,'filled');
       hold on;
       %plot([1*ones(m,1) 2*ones(m,1) 3*ones(m,1)]',[group1' group2' group3']','Color',l_grey);
       scatter(2*ones(m2,1), group2',markSize,l_grey,'filled');
       scatter(3*ones(m3,1), group3',markSize,l_grey,'filled');
       errorbar([1], mean1, std1,'LineWidth',1,'Color',color1,'CapSize',0,'Marker','.','MarkerSize',meanMarkSize);
       errorbar([2], mean2, std2,'LineWidth',1,'Color',color2,'CapSize',0,'Marker','.','MarkerSize',meanMarkSize);
       errorbar([3], mean3, std3,'LineWidth',1,'Color',color3,'CapSize',0,'Marker','.','MarkerSize',meanMarkSize);
       xlim([0.25 3.75]);
       ylim([0 inf])
       xticks([1 2 3]);
        xtickangle(45);
       xticklabels(conditions);
       ylabel(ylbl);
       
       figQuality(gcf,gca,dim);
%        [h1,p1] = ttest2(group1,group2);
%        pt(5) = p1;
%        disp(p1);
%        [h2,p2] = ttest2(group2,group3);
%        pt(5) = p2;
%        disp(p2);
       
       group1 = [group1 NaN];
       [p,~,stats] = anova1([group1' group2' group3'],{'ACSF','MRS','MRScs'},'off')
       [c,~,~,gnames] = multcompare(stats,'display','off')
       
end

