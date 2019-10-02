function [peaksBinary] = getSpatialPeaks(smIC, cutoff)
    time = [1:1:size(smIC,2)];

    %find peaks in signal
    peaks = imregionalmax(smIC);
    peaks = smIC.*peaks;
    peakFilter = 0.02;
    peaks(peaks < peakFilter) = 0; %filter out any events less than x
    
    %test for prominence of peak
    prominenceCutoff = cutoff;
    peaks = clearNonprominentEvents(peaks, smIC, prominenceCutoff);
    
    %binarize peaks
    peaksBinary = peaks > 0; %create binary version of peaks
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
        [pks, locs] = findpeaks(signal(:,indices(i)),'MinPeakProminence',prominenceCutoff-.015);
         spaceEvents(locs,indices(i))=1;
    end
    
    peaks_space = peaks .* spaceEvents;
    peaks = peaks.* timeEvents .*spaceEvents;
end