function [peaksBinary] = getPeaks_dFoF(smIC, leftOrRight, cutoff)
    time = [1:1:size(smIC,2)];
    leftOrRight; %0 is left, 1 is right

    %find peaks in signal
    peaks = imregionalmax(smIC);
    peaks = smIC.*peaks;
    peakFilter = 0.03;
    peaks(peaks < peakFilter) = 0; %filter out any events less than x
    
    %blank out whole IC events, (events that are far left or far right)
    %[peaks, smIC] = clearCorticalEvents(smIC, peaks, leftOrRight, max(time));
    
    %test for prominence of peak
    prominenceCutoff = cutoff;
    peaks = clearNonprominentEvents(peaks, smIC, prominenceCutoff);
    
    %binarize peaks
    peaksBinary = peaks > 0; %create binary version of peaks
    peaksBinary(1:15,:) = 0;
    peaksBinary(110:125,:) = 0;
    
end

function [peaks, smIC] = clearCorticalEvents(smIC, peaks, leftOrRight,endTime)
    peak_locs = find(peaks);
    size(smIC)
    [r,c] = ind2sub(size(peaks),peak_locs);
    if leftOrRight %picks out far left or far right [r,c] = ind2sub(size(peaks),peak_locs);events
        ctodel = c(r <= 15);
        r_ctx = r(r<=15);
        r_check = 60;
        ctx_start = 1;
        ctx_end = 15;
    else
        ctodel = c(r >= 110);
        r_ctx = r(r >=110);
        r_check = 50;
        ctx_start = 110;
        ctx_end = 125;
    end
    
    blank_area = 10;
    for i=1:size(ctodel,1)
        if smIC(r_ctx(i),ctodel(i)) > smIC(r_check,ctodel(i))
            if ctodel(i) < blank_area
                delLeft = 1;
                delRight = ctodel(i) + blank_area;
            elseif ctodel(i) + blank_area > endTime
                delLeft = ctodel(i) - blank_area;
                delRight = endTime;
            else
                delLeft = ctodel(i) - blank_area;
                delRight = ctodel(i) + blank_area;
            end
            peaks(:,delLeft:delRight)= zeros(size(peaks(:,delLeft:delRight)));
            %clear regions of this from actual signal for visualization
            %smIC(:,delLeft:delRight) = 0;
            %size(smIC,1)
        else
            peaks(ctx_start:ctx_end,delLeft:delRight)= zeros(size(peaks(:,delLeft:delRight)));
        end
        
    end
end

function peaks = clearNonprominentEvents(peaks, signal, prominenceCutoff)
    %We want to clear out events that are not coming out of the signal a
    %significant amount, i.e. prominence of prominenceCutoff or less
    peak_locs = find(peaks);
    [r,c] = ind2sub(size(peaks),peak_locs);
    endIndex = size(signal,2);
    
    %check every peak for prominence in time AND space
    %time
    timeEvents = zeros(size(signal));
    for i = 1:size(signal,1)
        [pks, locs] = findpeaks(signal(i,:),'MinPeakProminence',prominenceCutoff);
         timeEvents(i,locs)=1;
    end
    peaks_time = peaks .* timeEvents;
    
    indices = find(sum(peaks_time,1))';
    
    %space
    spaceEvents = zeros(size(signal));
    for i = 1:size(indices,1)
        %[pks, locs] = findpeaks(signal(:,indices(i)),'MinPeakProminence',prominenceCutoff);
        [pks, locs] = findpeaks(signal(:,indices(i)),'MinPeakProminence',prominenceCutoff-.01);
         spaceEvents(locs,indices(i))=1;
    end
    
    peaks_space = peaks .* spaceEvents;
    peaks = peaks.* timeEvents .*spaceEvents;
end