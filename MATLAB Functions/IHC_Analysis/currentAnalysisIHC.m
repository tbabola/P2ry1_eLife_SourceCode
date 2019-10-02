function [curChange,baselineMax,endMax] = currentAnalysisIHC(datafile,time,drugTime,washIn)
% measure baseline and baseline + 10 minute resting current
dFilt = medfilt1(datafile,250);

baselineMax = max(dFilt(drugTime*3E5-1.5E5:drugTime*3E5));
endMax = max(dFilt((drugTime+washIn)*3E5-1.5E5:(drugTime+washIn)*3E5));
figure
hold on
plot(time/60,dFilt,'k')
plot(drugTime,baselineMax, 'b*')
plot(drugTime+washIn, endMax, 'b*')

curChange = endMax - baselineMax;
end

