function [h, p] = compare2C(group1, group2, conditions, ylbl, dim, markSz, color1, color2)
       
       if nargin < 7
           color1 = 'k';
           color2 = 'r';
       end
       if nargin < 6
           meanMarkSize = 15;
           markSize = 10;
       else
           markSize = markSz(1);
           meanMarkSize = markSz(2);
       end

       m = size(group1,1);
       m2 = size(group2,1);
       l_grey = [0.7 0.7 0.7];
       
       mean1 = nanmean(group1,1);
       std1 = sterr(group1,1);
       mean2 = nanmean(group2,1);
       std2 = sterr(group2,1);
       
       h = figure;
       scatter(1*ones(m,1), group1,markSize,l_grey,'filled');
       hold on;
       scatter(2*ones(m2,1), group2,markSize,l_grey,'filled')';
       errorbar([1], mean1, std1,'LineStyle', 'none','LineWidth',1,'Color',color1,'CapSize',0,'Marker','.','MarkerSize',meanMarkSize);
       errorbar([2], mean2, std2,'LineStyle', 'none','LineWidth',1,'Color',color2,'CapSize',0,'Marker','.','MarkerSize',meanMarkSize);
       xlim([0.25 2.75]);
       ylim([0 inf])
       xticks([1 2]);
       xticklabels(conditions);
       ylabel(ylbl,'FontSize',8);
       [~,p] = ttest2(group1,group2);
       pt(5) = p;
       disp(p);

       figQuality(gcf,gca,dim);
end

