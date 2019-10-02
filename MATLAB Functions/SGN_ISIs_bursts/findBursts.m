function bursts = findBursts(ISIs, burst_thr, locs, streakForBurst)
%SGNbursts Finds bursts in ISI data
%   This function finds bursts by using the bursts and miniburst threshold.
    %ISIs: ISIs from findSpikes, use spikes.ISI
    %burst_thr: time in ms that defines if spike is within a burst (Tritsch
    %    used ~1.5s in in vivo paper
    %locs: time of spikes
    %number of spikes needed to be considered a burst

    ISI_burstdata = zeros(size(ISIs,1),4); %structure to hold the data
    miniburst_thr = 30;
    
    %classify ISIs as nothing (=0), bursts (=1), or minibursts (=2)
    ISI_burstdata(:,1) = ISIs(:,1);
    for i=1:size(ISIs,1)
        if ISIs(i) <= miniburst_thr
            ISI_burstdata(i,2) = 2;
        elseif ISIs(i) <= burst_thr
            ISI_burstdata(i,2) = 1;
        else
            ISI_burstdata(i,2) = 0;
        end 
    end
    
    %define bursts
    streak = 0; %keeps count of burst spikes
    burst_index_front = 1;
    burst_index_back = 2;
    burst_num = 1;
    burst_locs = zeros(0,2);
    
    for i=1:size(ISIs,1) 
        if (ISI_burstdata(i,2) == 1 | ISI_burstdata(i,2) == 2) & streak == 0
            burst_index_front = i;
        end
        
        if ISI_burstdata(i,2) == 1 | (ISI_burstdata(i,2) == 2 & streak == 0)
            streak = streak + 1;
            burst_index_back = i;
        end
        
        if ISI_burstdata(i,2) == 0
            if streak >= streakForBurst
                ISI_burstdata(burst_index_front:burst_index_back,3) = burst_num;
                burst_locs(burst_num,:) = [locs(burst_index_front) locs(burst_index_back)];
                burst_num = burst_num + 1;
            end
            streak = 0;
        end
    end

    burst_num = max(ISI_burstdata(:,3)); %number of bursts
    
    %find average numspikes/burst and average burst duration
    a = unique(ISI_burstdata(:,3));
    out = [a,histc(ISI_burstdata(:,3),a)];
    out(1,:) = [];
    
    %fill burst data structure
    bursts.streakForBurst = streakForBurst; 
    bursts.numBursts = burst_num;
    bursts.burstsLocs = burst_locs;
    bursts.spikePerBurst = out(:,2);
    bursts.durations = burst_locs(:,2)-burst_locs(:,1);
    bursts.burstThr = burst_thr;
    
end