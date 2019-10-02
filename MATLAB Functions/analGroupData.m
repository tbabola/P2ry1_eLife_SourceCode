function [groupHistoL,groupHistoR,totalEvents,individualStats] = analGroupData(paths,plotFlag)
    groupHistoL = [];
    groupHistoR = [];
    totalEvents = [];
    individualStats = [];

    for i=1:size(paths)
        load(paths{i},'-regexp','^(?!LICmov|RICmov)...');
%         load(paths{i});
%         [smLIC, peaksBinaryL] = getPeaks(LICmov,0,0.25);
%         [smRIC, peaksBinaryR] = getPeaks(RICmov,1,0.25);
%         savefile = '\ICmovs_peaks.mat';
%         [path, fn, ext ] = fileparts(paths{i});
%         save([path savefile],'LICmov','RICmov','smLIC','smRIC','peaksBinaryR','peaksBinaryL');
        %size(peaksBinaryR)
        %size(peaksBinaryL)
        
        [peakStat, eventStats] = peakStats_dFoF(smLIC, peaksBinaryL, smRIC, peaksBinaryR);
       
        %eventStat = table(eventLabel, eventClassification, leftOrRightDom, numPeaks, domAmp, maxLAmp, maxRAmp,xloc, tloc, hwt, hwx);
        peaksL = peakStat{1};
        peaksR = peakStat{2};
        groupHistoL = [groupHistoL; peaksL(:,2)];
        groupHistoR = [groupHistoR; peaksR(:,2)];
        histoLat = [peaksL(:,2); abs(peaksR(:,2)-125)]
        histoLat = histoLat(histoLat > 50);
        histoLat = histoLat(histoLat < 100);
        totalEvents = [totalEvents; eventStats];
        individualStats(i,:) = [max(eventStats.eventLabel) median(eventStats.domAmp) median(eventStats.hwt) nanmedian(eventStats.hwx) size((find(eventStats.numPeaks > 1)),1)/max(eventStats.eventLabel)*100 size(histoLat,1)];
        
        
        if(plotFlag)
          plotTimeSeries(smLIC, smRIC, peaksBinaryL, peaksBinaryR, peakStat);
        end
    
    end
    
end