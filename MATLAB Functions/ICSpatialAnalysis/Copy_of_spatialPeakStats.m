function [peakStat, eventStat] = spatialPeakStats(smLIC, peaksBinaryL, smRIC, peaksBinaryR)

%   simple peaks only analysis, not "events"
    LpeakAmps = [];
    LpeakLocs = [];
    [r,c] = find(peaksBinaryL);
    LpeakLocs = [r,c];
    for i=1:size(r,1)
        LpeakAmps = [LpeakAmps; smLIC(r(i),c(i))];
    end
    RpeakAmps = [];
    RpeakLocs = [];
    [r,c] = find(peaksBinaryR);
    RpeakLocs = [r,c];
    for i=1:size(r,1)
        RpeakAmps = [RpeakAmps; smRIC(r(i),c(i))];
    end
    
    peakStat = {[LpeakAmps, LpeakLocs], [RpeakAmps, RpeakLocs]};
    
    %event analysis (more complex)
    [leftEvents, biEvents, rightEvents]= eventCoordination(peaksBinaryL,peaksBinaryR);
    eventStat = eventStats(rightEvents, leftEvents, biEvents, smRIC, smLIC, peaksBinaryL, peaksBinaryR);
    
    %plotTimeSeriesL(smLIC, smRIC, peaksBinaryL, peaksBinaryR, peakStat, eventStat)
end

function [leftEvents, biEvents, rightEvents] = eventCoordination(leftBinary, rightBinary)
    %initialize variables
    leftLabel = bwlabel(convolvePeaks(leftBinary));
    leftEventNum = max(leftLabel);
    rightLabel = bwlabel(convolvePeaks(rightBinary));
    
    leftEvents = zeros(size(leftLabel));
    biEvents = zeros(size(leftLabel));
    rightEvents = zeros(size(leftLabel));
   
    for i=1:leftEventNum
        leftIndices = find(leftLabel==i);        
        rightEvent = size(find(rightLabel(leftIndices)),2) > 1; % find any events that overlap with right events
        
        if rightEvent
            rightValue = rightLabel(leftIndices);
            rightValue(rightValue == 0) = NaN;
            rightValue = mode(rightValue); %%pick the right event with the most overlap in the case of two overlapping events
            uniqVals = unique(rightValue);
            if size(uniqVals,1) > 2
                preserveVal = uniqueVals(~(uniqVals == NaN | uniqVals == rightValue));
                preserveIndices = find(rightLabel == preserveVal);
                rightLabel(preserveIndices) = 600;
            end
            rightIndices = find(rightLabel==rightValue);
            biEvents(leftIndices) = 1;
            biEvents(rightIndices) = 1;
        end
    end

    leftEvents = (leftLabel - (500*biEvents)) > 0;
    rightEvents = (rightLabel - (500*biEvents)) > 0;
       
    leftEvents = bwlabel(leftEvents);
    LE1 = max(leftEvents);
    rightEvents = bwlabel(rightEvents);
    biEvents = bwlabel(biEvents);
    leftEvents = bwlabel(filtEvents(leftEvents));
    LE2 = max(leftEvents);
    rightEvents = bwlabel(filtEvents(rightEvents));
    biEvents = bwlabel(filtEvents(biEvents));    
end

function [convPeaks] = convolvePeaks(peaksBinary) %half second time window
    oneDPeaks = sum(peaksBinary,1);
    convPeaks = oneDPeaks + conv(single(oneDPeaks > 0),ones(1,6),'same');
    convPeaks = convPeaks > 0;
end

function [windowStart, windowEnd] = getWindow(index, windowSize, size)
        if index - windowSize < 1
            windowStart = 1;
            windowEnd = index + windowSize;
        elseif index + windowSize > size
            windowStart = index - windowSize;
            windowEnd = size;
        else
            windowStart = index - windowSize;
            windowEnd = index + windowSize;
        end
end

function [eventStat] = eventStats(rightEvents, leftEvents, biEvents, smRIC, smLIC, leftBinary, rightBinary)
    
    eventStat = struct('eventClassification',{},'leftOrRightDom', {}, 'numPeaks', [], 'domAmp', [], 'maxLamp', [], 'maxRAmp', [],...
        'xloc', [], 'tloc', [],'hwx', [], 'hwt', [], 'integral', [],'lxloc',[],'rxloc',[],'delta',[]);
    index = 1;
    
    leftBinaryVal = smLIC .* leftBinary; %gives actual value for peaks
    rightBinaryVal = smRIC .* rightBinary;
    windowSize = 350;
    
    %for left events
    for i=1:max(leftEvents)
        indices = find(leftEvents == i);
        leftAmp = max(max(leftBinaryVal(:,indices)));
        [r,c] = find(leftBinaryVal == leftAmp);
        
        if size(r) == 1
            eventStat(index).numPeaks = size(find(leftBinaryVal(:,indices)),1); 
            eventStat(index).eventClassification = 'Left';
            eventStat(index).leftOrRightDom = 'Left';
            eventStat(index).maxLamp = leftAmp;
            eventStat(index).maxRAmp = 0;
            eventStat(index).domAmp = leftAmp;
            eventStat(index).xloc = r;
            eventStat(index).tloc = c;
            eventStat(index).integral = trapz(smLIC(:,c));
            
            %half-width measurements
%             [windowStart, windowEnd] = getWindow(indices(1), windowSize, size(smLIC,2));
%             [pks,locs,w] = findpeaks(smLIC(r,windowStart:windowEnd),'WidthReference','halfprom');
%             [pk2,locs2,w2] = findpeaks(smLIC(r,windowStart:windowEnd),'WidthReference','halfheight');
%             if size(w,2) > size(w2,2)
%                 [m,n] = size(w2);
%                 zw2 = zeros(size(w));
%                 zw2(1:n) = w2;
%                 w2 = zw2;
%             end
%             w(w > w2) = w2(w > w2);
%             index = find(pks == leftAmp);
%             eventStat(index).hwt = w(index);
%             
%             if eventStat(end).numPeaks == 1 & (eventStat(end).xloc > 60 & eventStat(end).xloc < 100);
%                 [pks,locs,w] = findpeaks(smLIC(:,c),'WidthReference','halfheight');
%                 index = find(pks == leftAmp);
%                 eventStat(index).hwx = w(index);
%             else
%                 eventStat(index).hwx = NaN;
%             end   
        else
            leftEvents(leftEvents == i) = 0;
            disp('Left event rejected');
        end
        index = index + 1;
    end
    leftEvents = bwlabel(leftEvents > 0);
    
     %for right events
    for i=1:max(rightEvents)
        indices = find(rightEvents == i);
        rightAmp = max(max(rightBinaryVal(:,indices)));
        peakLoc = find(rightBinaryVal == rightAmp);
        [r,c] = ind2sub(size(smRIC),peakLoc);
        
        if size(r) == 1
            eventStat(index).numPeaks = size(find(rightBinaryVal(:,indices)),1); 
            eventStat(index).eventClassification = 'Right';
            eventStat(index).leftOrRightDom = 'Right';
            eventStat(index).maxLamp = 0;
            eventStat(index).maxRAmp = rightAmp;
            eventStat(index).domAmp = rightAmp;
            eventStat(index).xloc = r;
            eventStat(index).tloc = c;
            eventStat(index).integral = trapz(smRIC(:,c));

%             [windowStart, windowEnd] = getWindow(indices(1), windowSize, size(smRIC,2));
%             [pks,locs,w] = findpeaks(smRIC(r,windowStart:windowEnd),'WidthReference','halfprom');
%             [pk2,locs2,w2] = findpeaks(smRIC(eventStat(end).xloc,windowStart:windowEnd),'WidthReference','halfheight');
%             if size(w,2) > size(w2,2)
%                 [m,n] = size(w2);
%                 zw2 = zeros(size(w));
%                 zw2(1:n) = w2;
%                 w2 = zw2;
%             end
%             w(w > w2) = w2(w > w2);
%             index = find(pks == rightAmp);
%             eventStat(index).hwt = w(index);
% 
%             if eventStat(end).numPeaks == 1 & (eventStat(end).xloc > 25 & eventStat(end).xloc < 65)
%                 [pks,locs,w] = findpeaks(smRIC(:,c),'WidthReference','halfheight');
%                 index = find(pks == rightAmp);
%                 eventStat(index).hwx = w(index);
%             else
%                 eventStat(index).hwx = NaN;
%             end   
        else
            rightEvents(rightEvents == i) = 0;
            disp('Right event rejected');
        end
        
        index = index + 1;
    end
    rightEvents = bwlabel(rightEvents > 0);
    
    %for bi events
    for i=1:max(biEvents)
        indices = find(biEvents == i);
        rightAmp = max(max(rightBinaryVal(:,indices)));
        [rr, rc] = find(rightBinaryVal == rightAmp);
        leftAmp = max(max(leftBinaryVal(:,indices)));
        [lr, lc]  = find(leftBinaryVal == leftAmp);
        
        [rrt, rct] = find(rightBinaryVal(:,indices));
        [lrt, lct] = find(leftBinaryVal(:,indices));
        if size(rrt,1) > 1 | size(lrt,1) > 1
            if size(rrt,1) == 1
               [y,idx] = min(abs(lrt - (100-rrt)));
               eventStat(index).lxloc = lrt(idx);
               eventStat(index).rxloc = rrt;
            elseif size(lrt,1) == 1
               [y,idx] = min(abs((100-rrt) - lrt));
               eventStat(index).lxloc = lrt;
               eventStat(index).rxloc = rrt(idx);
            else
               eventStat(index).lxloc = lrt(1);
               eventStat(index).rxloc = rrt(1);   
            end
            
        elseif size(rrt,1) == 1 & size(lrt,1) == 1
            eventStat(index).lxloc = lr;
            eventStat(index).rxloc = rr;
        end
        
        
        eventStat(index).eventClassification = 'Bi';
        eventStat(index).maxLAmp = leftAmp;
        eventStat(index).maxRAmp = rightAmp;
        
        
        
        
        if leftAmp > rightAmp
          eventStat(index).leftOrRightDom = 'Left';
          eventStat(index).numPeaks = size(find(leftBinaryVal(:,indices)),1);
          eventStat(index).xloc = lr;
          eventStat(index).tloc = lc;
          eventStat(index).integral = trapz(smLIC(:,lc));
          eventStat(index).delta = rightAmp/leftAmp;
          smIC = smLIC;
          eventStat(index).domAmp = leftAmp;
          leftInd = 60;
          rightInd = 100;
        else
           eventStat(index).leftOrRightDom = 'Right';
           eventStat(index).numPeaks = size(find(rightBinaryVal(:,indices)),1);
           eventStat(index).xloc = rr;
           eventStat(index).tloc = rc;
           eventStat(index).integral = trapz(smRIC(:,rc));
           eventStat(index).delta = leftAmp/rightAmp;
           smIC = smRIC;
           eventStat(index).domAmp = rightAmp;
           leftInd = 25;
           rightInd = 65;
        end
 
%         [windowStart, windowEnd] = getWindow(indices(1), windowSize, size(smIC,2));
%         [pks,locs,w] = findpeaks(smIC(eventStat(end).xloc,windowStart:windowEnd),'WidthReference','halfprom');
%         [pk2,locs2,w2] = findpeaks(smIC(eventStat(end).xloc,windowStart:windowEnd),'WidthReference','halfheight');
%         if size(w,2) > size(w2,2)
%                 [m,n] = size(w2);
%                 zw2 = zeros(size(w));
%                 zw2(1:n) = w2;
%                 w2 = zw2;
%         end
%         w(w > w2) = w2(w > w2);
%         index = find(pks == eventStat(end).domAmp);
%         eventStat(index).hwt = w(index);
%         
%         if eventStat(end).numPeaks == 1 && (eventStat(end).xloc > leftInd && eventStat(end).xloc < rightInd)
%             [pks,locs,w] = findpeaks(smIC(:,eventStat(end).tloc),'WidthReference','halfheight');
%             index = find(pks == eventStat(end).domAmp);
%             eventStat(index).hwx = w(index);
%         else
%             eventStat(index).hwx = NaN;
%         end  
        
        index = index+1;
    end
    
    totalEvents = max(rightEvents) + max(leftEvents) + max(biEvents);
    eventLabel = [1:1:totalEvents]';
    %eventStat = table(eventLabel, eventClassification, leftOrRightDom, numPeaks, domAmp, maxLAmp, maxRAmp,xloc, tloc, hwt, hwx, integral);
end

function filt = filtEvents(events)
    for i=1:max(events)
        indices = find(events == i)';
        if(size(indices,1) < 3)
            events(indices) = 0;
            disp('event deleted');
        end
    end
    
    filt = events;
end

function corrmatrix = getCorr(smLIC, smRIC)
    corrmatrix = zeros(size(smLIC,1));
    for i=1:size(smLIC,1)
        lSignal = smLIC(i,:);
        for j=1:size(smRIC,1);
            rSignal = smRIC(j,:);
            temp = corrcoef(lSignal,rSignal);
            corrmatrix(i,j) = temp(1,2);
        end
    end
end

%problem is multiple levels of analysis, micro and macro, need to analysis
%types, one for "events", another for "peaks"
%function 
%peak based for general activity levels
%events!, halfwidth, number of peaks, frequency, amplitude
function plotTimeSeriesL(smLIC, smRIC, peaksBinaryL, peaksBinaryR, peakStat, eventStat)
    Llocs = find(peaksBinaryL);
    [Lr, Lc] = ind2sub(size(peaksBinaryL),Llocs);
    Rlocs = find(peaksBinaryR);
    [Rr, Rc] = ind2sub(size(peaksBinaryL),Rlocs);
    
    statsL = peakStat{1};
    statsR = peakStat{2};
    histoL = statsL(:,2);
    histoR = statsR(:,2);
    
    %get
    rightDomIndices = find(strcmp(eventStat.leftOrRightDom,'Right'));
    leftDomIndices = find(strcmp(eventStat.leftOrRightDom,'Left'));
    lhwx= eventStat.hwx(leftDomIndices)/2;
    lhwt= eventStat.hwt(leftDomIndices)/2;
    lx = eventStat.xloc(leftDomIndices);
    lt = eventStat.tloc(leftDomIndices);
    lhwxlinesx = [lx-lhwx lx+lhwx]';
    lhwxlinesy = [lt lt]';
    lhwtlinesx = [lx lx]';
    lhwtlinesy = [lt-lhwt lt+lhwt]';
    rhwx= eventStat.hwx(rightDomIndices)/2;
    rhwt= eventStat.hwt(rightDomIndices)/2;
    rx = eventStat.xloc(rightDomIndices);
    rt = eventStat.tloc(rightDomIndices);
    rhwxlinesx = [rx-rhwx rx+rhwx]';
    rhwxlinesy =[rt rt]';
    rhwtlinesx =[rx rx]';
    rhwtlinesy = [rt-rhwt rt+rhwt]';
    
    %single figure for movie
    p = figure('Position',[100 0 300 600]);
    set(p,'Color','black');
    colormap jet;
    pv = [.15 .3 .4 .65];
    subplot('Position',pv);
    imagesc(smLIC');
    caxis([0 0.8]);
    xlim([0 125]);
    ylim([000 6000]);
    hold on; 
    scatter(Lr, Lc,'MarkerEdgeColor','white','LineWidth',1);
    line(lhwxlinesx,lhwxlinesy,'Color','white');
    line(lhwtlinesx,lhwtlinesy,'Color','white');
    set(gca,'XTick',[],'XColor','white','YColor','white');
    %axis off;
    
    pv = [.58 .3 .4 .65];
    subplot('Position',pv);
    imagesc(smRIC');
    caxis([0 0.8]);
    xlim([0 125]);
    ylim([0000 6000]);
    hold on; 
    scatter(Rr, Rc,'MarkerEdgeColor','white','LineWidth',1);
    line(rhwxlinesx,rhwxlinesy,'Color','white');
    line(rhwtlinesx,rhwtlinesy,'Color','white');
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
end