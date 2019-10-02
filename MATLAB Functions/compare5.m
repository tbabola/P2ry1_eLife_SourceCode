function [h, p] = compare4P(group1, group2, group3, group4, group5, conditions, ylbl, dim, markSz, color1, color2)
       
       if nargin < 10
           color1 = 'k';
           color2 = 'r';
       end
       if nargin < 9
           meanMarkSize = 15;
           markSize = 10;
       else
           markSize = markSz(1);
           meanMarkSize = markSz(2);
       end
       if size(group1,2) > size(group1,1)
           group1 = group1';
           group2 = group2';
           group3 = group3';
           group4 = group4';
           group5 = group5';
       end
       
       m = size(group1,1);
       m2 = size(group2,1);
       m3 = size(group3,1);
       m4 = size(group4,1);
       m5 = size(group5,1);
       
       l_grey = [0.7 0.7 0.7];
       
       mean1 = nanmean(group1,1);
       std1 = sterr(group1,1);
       mean2 = nanmean(group2,1);
       std2 = sterr(group2,1);
       mean3 = nanmean(group3,1);
       std3 = sterr(group3,1);
       mean4 = nanmean(group4,1);
       std4 = sterr(group4,1);
       mean5 = nanmean(group5,1);
       std5 = sterr(group5,1);
       
       
       h = figure;
       %plot([1*ones(m,1) 2*ones(m2,1) 3*ones(m3,1) 4*ones(m4,1)]', [group1 group2 group3 group4]','.','Color',l_grey);
       scatter([1*ones(m,1); 2*ones(m2,1); 3*ones(m3,1); 4*ones(m4,1); 5*ones(m5,1)], [group1; group2; group3; group4; group5], markSize,l_grey, 'o', 'filled');

       hold on;
       errorbar([1], mean1, std1,'LineStyle', 'none','LineWidth',1,'Color',color1,'CapSize',0,'Marker','.','MarkerSize',meanMarkSize);
       errorbar([2], mean2, std2,'LineStyle', 'none','LineWidth',1,'Color',color1,'CapSize',0,'Marker','.','MarkerSize',meanMarkSize);
       errorbar([3], mean3, std3,'LineStyle', 'none','LineWidth',1,'Color',color1,'CapSize',0,'Marker','.','MarkerSize',meanMarkSize);
       errorbar([4], mean4, std4,'LineStyle', 'none','LineWidth',1,'Color',color1,'CapSize',0,'Marker','.','MarkerSize',meanMarkSize);
       errorbar([5], mean5, std5,'LineStyle', 'none','LineWidth',1,'Color',color1,'CapSize',0,'Marker','.','MarkerSize',meanMarkSize);
       xlim([0.25 5.75]);
       ylim([0 inf])
       xticks([1 2 3 4 5]);
       xticklabels(conditions);
       ylabel(ylbl);

       

       handle = gcf;
       figQuality(gcf,gca,dim);
       
       figure;
       [p,~,stats] = anova1([group1; group2; group3; group4; group5], [1*ones(m,1); 2*ones(m2,1); 3*ones(m3,1); 4*ones(m4,1); 5*ones(m5,1)],'off');
       [c,~,~,~] = multcompare(stats,'Display','off');
end

