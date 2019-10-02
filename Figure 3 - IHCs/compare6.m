function [h1, p1] = compare6(group1, group2, group3, group4,group5,group6, conditions, ylbl, dim, markSz, color1, color2)
       
       if nargin < 11
           color1 = 'k';
           color2 = 'r';
       end
       if nargin < 10
           meanMarkSize = 30;
           markSize = 27;
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
           group6 = group6';
       end
       
       m = size(group1,1);
       m2 = size(group2,1);
       m3 = size(group3,1);
       m4 = size(group4,1);
       m5 = size(group5,1);
       m6 = size(group6,1);
       
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
       mean6 = nanmean(group6,1);
       std6 = sterr(group6,1);
%        
       
       figure
       scatter(1*ones(m,1), group1,markSize,l_grey,'filled');
       hold on;
       scatter(2*ones(m2,1), group2,markSize,l_grey,'filled');
       scatter(3.5*ones(m3,1), group3,markSize,l_grey,'filled');
       scatter(4.5*ones(m4,1), group4,markSize,l_grey,'filled');
       scatter(6*ones(m5,1), group5,markSize,l_grey,'filled');
       scatter(7*ones(m6,1), group6,markSize,l_grey,'filled');
       plot([1*ones(m,1) 2*ones(m2,1)]',[group1 group2]','Color',l_grey); % for lines
       plot([3.5*ones(m3,1) 4.5*ones(m4,1)]',[group3 group4]','Color',l_grey); % for lines
       plot([6*ones(m5,1) 7*ones(m6,1)]',[group5 group6]','Color',l_grey); % for lines
       
       errorbar([1], mean1, std1,'LineStyle', 'none','LineWidth',2,'Color',color1,'CapSize',0,'Marker','.','MarkerSize',meanMarkSize);
       errorbar([2], mean2, std2,'LineStyle', 'none','LineWidth',2,'Color',color1,'CapSize',0,'Marker','.','MarkerSize',meanMarkSize);
       errorbar([3.5], mean3, std3,'LineStyle', 'none','LineWidth',2,'Color',color2,'CapSize',0,'Marker','.','MarkerSize',meanMarkSize);
       errorbar([4.5], mean4, std4,'LineStyle', 'none','LineWidth',2,'Color',color2,'CapSize',0,'Marker','.','MarkerSize',meanMarkSize);
       errorbar([6], mean5, std5,'LineStyle', 'none','LineWidth',2,'Color',color2,'CapSize',0,'Marker','.','MarkerSize',meanMarkSize);
       errorbar([7], mean6, std6,'LineStyle', 'none','LineWidth',2,'Color',color2,'CapSize',0,'Marker','.','MarkerSize',meanMarkSize);
       xlim([0.25 7.25]);
       ylim([0 inf])
       xticks([1 2 3.5 4.5 6 7]);
       xticklabels(conditions);
       ylabel(ylbl);
       [h1,p1] = ttest2(group1,group2);
      % pt(5) = p;
       disp(p1);
       [h2,p2] = ttest2(group3,group4);
       disp(p2)
       [h3,p3] = ttest2(group5,group6);
       disp(p3)
       handle = gcf;
       figQuality(gcf,gca,dim);
end
