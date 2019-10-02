% load file
%% 
[fn dname] = uigetfile('M:\Bergles Lab Data\Projects\In vivo imaging\*.tif');
warning('off', 'MATLAB:imagesci:tiffmexutils:libtiffErrorAsWarning')
X = loadTif([dname fn],16);
[m,n,t] = size(X);
[dFoF, Fo] = normalizeImg(X, 10, 0);
frameToSelect = 2249;
%% 
 [LICmov, RICmov] = selectROI(dFoF,frameToSelect);
 meanLIC = squeeze(mean(LICmov,1));
 percentLIC = prctile(meanLIC,30,2);
 meanRIC = squeeze(mean(RICmov,1));
 percentRIC = prctile(meanRIC,30,2);

% %%remove background transients from signal
top = dFoF(5:20,10:500,:); %picks area at top of image, middle to account for registration
top = squeeze(mean(mean(top),2));
mid = dFoF(60:80,10:500,:);
mid = squeeze(mean(mean(mid),2));
diff = top - mid;
diff(diff < -0) = 0;
[pks,locs,w]=findpeaks(double(diff),'MinPeakHeight',0.02,'WidthReference','halfprom','MinPeakWidth',7,'Annotate','extents');
figure;
findpeaks(double(diff),'MinPeakHeight',0.02,'WidthReference','halfprom','MinPeakWidth',7,'Annotate','extents');



flash = zeros(size(top));
for i=1:size(w,1)
    ww = floor(w(i));
    wloc = locs(i);
    left = wloc-ww-2;
    right = wloc+ww+2;
    if left < 1
        left = 1;
    end
    if right > t
        right = t;
    end
    flash(left:right) = 1;
end

[m,n] = size(meanLIC(:,find(flash)));
percentLIC = repmat(percentLIC,1,n);
percentLIC = imnoise(percentLIC,'gaussian',0,.0001);
percentLIC = imgaussfilt(percentLIC);
meanLIC(:,find(flash)) = percentLIC;
[m,n] = size(meanRIC(:,find(flash)));
percentRIC = repmat(percentRIC,1,n);
percentRIC = imnoise(percentRIC,'gaussian',0,.0001);
percentRIC = imgaussfilt(percentRIC);
meanRIC(:,find(flash)) = percentRIC;
% 
smLIC = double(imgaussfilt(meanLIC,3));
smRIC = double(imgaussfilt(meanRIC,3));

%%
%LIC & RIC
[peaksBinaryL] = getSpatialPeaks(smLIC,0.02);
[peaksBinaryR] = getSpatialPeaks(smRIC,0.02);

[peakStat, eventStats] = spatialPeakStats(smLIC, peaksBinaryL, smRIC, peaksBinaryR);
plotTimeSeries_dFoF(smLIC, smRIC, peaksBinaryL, peaksBinaryR, peakStat);
figure;  histogram([eventStats.rxloc]-[eventStats.lxloc],20)

genos = {eventStats.eventClassification};
biidx = find(contains(genos,'Bi'))
%figure;plot([eventStats.lxloc],[eventStats.delta],'o');
figure; plot([eventStats(biidx).delta],[eventStats(biidx).domAmp],'o');
%% save
[sdn, sfn, sext] = fileparts([dname fn]);
[tokens,matches] = regexp(sfn,'(Experiment-\d\d\d)','tokens','match');

savefile = [tokens{1}{1} '_spatialAnalysis.mat'];
save([dname savefile],eventStats,smLIC,smRIC); 
%%

