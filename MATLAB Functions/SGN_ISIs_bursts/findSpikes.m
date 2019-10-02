function spikes = findSpikes(d, time, times, prominenceThr, plotFlag)
%This function finds action potentials given a signal and returns spike
%timing information. Parameters chosen reflect optimization for 50kHz
%sampling.
    %d: digitized signal
    %time: time vector in milliseconds
    %times: two-element array indicating time period to be analyzed in
    %   seconds
    %prominenceThr: threshold for spike detection (mV)
    %plotFlag: binary for whether or not to plot data
    if nargin < 3
        times = [0 600];
        prominenceThr = 0.30; %mV
    elseif nargin == 3
        prominenceThr = 0.30; %mV   
    elseif nargin < 5
        plotFlag = 1;
    end
    
    %convert time to milliseconds
    baselineStart = times(1)*1000;
    baselineEnd = times(2)*1000;
    d = d(time > baselineStart & time < baselineEnd);
    time = time(time > baselineStart & time < baselineEnd);
    time = time - time(1);
    
    %baseline correction for thresholding
    d_c = msbackadj(time,d,'WindowSize',5000,'StepSize',5000);
    
    [~,locs]=findpeaks(d_c,'MinPeakProminence',prominenceThr,'MinPeakHeight',0.15);
    if plotFlag
        figure; findpeaks(d_c,'MinPeakProminence',prominenceThr,'MinPeakHeight',0.15)
    end
    spikes.timeIdx = locs;
    spikes.times = time(locs);
 
    %ISI measurements
    ISIs = zeros(size(locs,1)-1,1);
    for i=1:size(locs)-1
        ISIs(i)=spikes.times(i+1)-spikes.times(i);
    end
    
    spikes.ISI = ISIs;
    spikes.numSpikes = size(locs,1);
    spikes.avgHz = spikes.numSpikes/(baselineEnd-baselineStart);
    spikes.string = sprintf('Baseline Spikes (Freq):%f (%f)', spikes.numSpikes ,spikes.avgHz);
    
end
