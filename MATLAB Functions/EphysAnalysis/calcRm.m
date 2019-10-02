function Rm = calcRm(d,time, pulse, analysisTime)
    %calculates the membrane resistance given the pulse (in pA) and
    %analysisTime ([start_bl end_bl start_ss end_ss] in seconds)
    bl_v = mean(d(time > analysisTime(1) & time < analysisTime(2)));
    ss_v = mean(d(time > analysisTime(3) & time < analysisTime(4)));
    dv = (ss_v - bl_v) * 10^-3;
    di = pulse * 10^-12;
    Rm = dv/di / 10^6;
end