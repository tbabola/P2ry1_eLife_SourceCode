dname = 'M:\Projects and Analysis\Papers\P2ry1\Figure 2 - ISCs\Data\Crenations';
[fn dname] = uigetfile([dname '\*.tif']);

img = loadTif([dname fn],8);
[m,n,t] = size(img);
offset = 5;
%% 
img1 = double(img(:,:,1:end-offset));
img2 = double(img(:,:,1+offset:end));

imgSubt = img2-img1;
imgMean = mean(imgSubt,3);
imgSTD = std(imgSubt,[],3);
imgThrP = imgMean + 3*imgSTD;
imgThrN = imgMean - 3*imgSTD;
imgThr = imgSubt > imgThrP | imgSubt < imgThrN;
imgThr = bwareaopen(imgThr,10);
meanPlot = squeeze(mean(mean(imgThr,2),1));
%implay(imgThr);

%%
% dirN = ['M:\Bergles Lab Data\Papers\P2ry1\Figure 1 - ISCs\Crenations\' 'VG3 KO\'];
 dirN = dname;
 [pathstr, name, ext] = fileparts([dname fn]);
% writeTif(single(imgThr),[dirN 'thr_' fn],32);
%% find peaks and area
figure; plot(meanPlot);

if ~contains(fn,'MRS2') %%use same STD for both videos
    startPt = input('Where would you like to start measurement for std?');
    endPt = input('Where would you like to end measurement for std?');
    stdMP = 4 * std(meanPlot(startPt:endPt),1,1);
end
figure; findpeaks(meanPlot,'MinPeakProminence',stdMP)
[pks, locs] = findpeaks(meanPlot,'MinPeakProminence',stdMP);
m = size(locs,1);
areas = [];
%%

figure;

scalingFactor = 5.8^2; % 1 um = 5.8 pixels/micron on Travis rig, 3.6 pixels/micron on HC rig
[x,y,t] = size(imgThr);
indexToKill = []; crenImage = zeros(x,y,'logical');
for i=1:m
    tempImg = imgThr(:,:,locs(i));
    tempImg = bwareaopen(tempImg,12);
    tempImg = imgaussfilt(double(tempImg),12);
    vals = tempImg(tempImg > 0.01);
    thr = prctile(vals,20);
    tempImg = tempImg > thr;
    tempImg = bwareaopen(tempImg,2500);
    imagesc([tempImg imgThr(:,:,locs(i))]);
    keep = input(['Keep Event ' num2str(locs(i)) ' ?']);
    if keep
        areas = [areas; bwarea(tempImg)/(scalingFactor)];
        crenImage(:,:,end+1) = tempImg;
    else
        indexToKill = [indexToKill; i];
    end
end

locs(indexToKill) = [];
pks(indexToKill) = [];

Crens.name = name;
Crens.locs = locs;
Crens.pks = pks;
Crens.stdStart = startPt;
Crens.stdEnd = endPt;
Crens.areas = areas;
Crens.meanPlot = meanPlot;
Crens.imgSTD = imgSTD;
Crens.stdMP = stdMP;
Crens.scalingFactor = scalingFactor;
Crens.crenationImg = crenImage;
save([dirN 'CrenationData_' name '.mat'],'Crens');

[name]