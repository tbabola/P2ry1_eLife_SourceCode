function [intervals, burst_locs, num_bursts, spikesPerBurst,burst_dur] = SGNbursts(ISIs, miniburst_thr, burst_thr, locs)
%SGNbursts Finds bursts in ISI data
%   This function finds bursts by using the bursts and miniburst threshold.

    ISI_burstdata = zeros(size(ISIs,1),4);
    
    %classify ISIs as nothing (=0), bursts (=1), or minibursts (=2)
    ISI_burstdata(:,1)=ISIs(:,1);
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
    streakforburst = 10; %consecutive number of burst [intervals needed to be considered a burst
    streak = 0; %will keep count of burst spikes
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
            if streak >= streakforburst
                ISI_burstdata(burst_index_front:burst_index_back,3) = burst_num;
                burst_locs(burst_num,:) = [locs(burst_index_front) locs(burst_index_back)];
                burst_num = burst_num + 1;
            end
            streak = 0;
        end
    end

    %extract ISIs at first and last 5 positions, see Tritsch, 2010 Figure 1e
    burst_num = max(ISI_burstdata(:,3)); %number of bursts
    intervals = NaN(burst_num,11);
    for i=1:burst_num
        burst_indices = find(ISI_burstdata(:,3) == i);
        %first five
        count = 0;
        j = 1;
        while count < 5
            if ISI_burstdata(burst_indices(j),2)==1
                count = count + 1;
                intervals(i,count) = ISI_burstdata(burst_indices(j),1);
            end
            j = j + 1;
        end
        
        %last five
        burst_indices = flipud(burst_indices);
        count = 0;
        j = 1;
        while count < 5
            if ISI_burstdata(burst_indices(j),2)==1
                intervals(i,11-count) = ISI_burstdata(burst_indices(j),1);
                count = count + 1;
            end
            j = j + 1;
        end
    end
    
    %number of bursts
    num_bursts = max(ISI_burstdata(:,3));
    
    %find average numspikes/burst and average burst duration
    a = unique(ISI_burstdata(:,3));
    out = [a,histc(ISI_burstdata(:,3),a)];
    if ~isempty(out)
        out(1,:) = [];
    end
    spikesPerBurst=mean(out(:,2));
    burst_dur = mean(burst_locs(:,2)-burst_locs(:,1));
    
end

