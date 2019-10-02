function [d , time , samplingRateHz] = loadPclampData(datafile)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [d, si, h]= abfload(datafile,'doDispInfo',0);
    d = squeeze(d);
    
    samplingRateHz = 1/(si*10^-6);
    time = (0:size(d,1)-1)*(si*10^-6);
    time = time';
end

