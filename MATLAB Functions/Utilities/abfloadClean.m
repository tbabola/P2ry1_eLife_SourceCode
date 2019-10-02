function [d, time] = abfloadClean(fn)
%abfloadClean loads abf and cleans up file
    [d,si] = abfload(fn,'doDispInfo',0);
    d = squeeze(d);
    
    %remove clampex "holding period" that is 1/64th of trace
    pntsToRemove = round(size(d,1)/64);
    d = d(pntsToRemove:end,:);
    
    time = (0:size(d,1)-1)*(si*10^-6);

end

