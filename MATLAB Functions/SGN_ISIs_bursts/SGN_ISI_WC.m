function [b_sp, b_ISIs, b_locs] = SGN_ISI(file, x)
    %load file
    [d,time]=loadPclampData(file); %load pClamp data
    time = time*1000; %convert seconds to milliseconds

%   Detailed explanation goes here
    baselineStart = x(1)*1000;
    baselineEnd = x(2)*1000;
    d = d(find(time==baselineStart,1):find(time==baselineEnd,1));
    time = time(find(time==baselineStart,1):find(time==baselineEnd,1));
    time = time - time(1);
    
    
    %baseline correction for thresholding
    d_blsubtract = msbackadj(time,-d,'WindowSize',10000,'StepSize',10000);
    prominenceThr = 500; %mV
    [pks,locs]=findpeaks(d_blsubtract,time,'MinPeakProminence',prominenceThr,'MinPeakHeight',500);
    
    %ISI measurements
    ISIs = zeros(size(locs,1)-1,1);
    for i=1:size(locs)-1
        ISIs(i)=locs(i+1)-locs(i);
    end
    
    b_ISIs = ISIs;
    b_sp = size(b_ISIs,1);
    b_locs = locs;
    baselineFreqHz = b_sp/(baselineEnd-baselineStart);
    
    fprintf('Baseline Spikes (Freq):%f (%f)\n',size(b_ISIs,1),baselineFreqHz);
    
end
