%Analysis of SGN activity script

%%load image
[fname, dname] = uigetfile('M:\Projects and Analysis\Papers\P2ry1\Figure 3 - Calcium Imaging\Data\*','Multiselect','on');

[~,name,ext] = fileparts([dname, fname]);

%%tif performance 
if strcmp(ext,'.tif') 
    tic;
    X = loadTif([dname fname],16);
    toc;
elseif strcmp(ext,'.czi')
    tic;
    X = bfLoadTif([dname fname]);
    X = imrotate(X,180);
    toc;
elseif strcmp(ext,'.lsm')
    tic;
    X = bfLoadTif([dname fname]);
    toc;
else
    disp('Invalid image format.')
end

%% get 10th percentiles
%%

tic;
[dFoF, Fo] = normalizeImg(X, 10, 1); toc;
dFoF = Kalman_Stack_Filter(double(dFoF));
%%
imgMean = mean(dFoF,3);
imgSTD = std(dFoF,1,3);
imgThrP = imgMean + 4*imgSTD;
imgThr = dFoF > imgThrP;
meanPlot = squeeze(mean(mean(imgThr,2),1));
figure; plot(meanPlot); drawnow;
%%
for i = 1:size(imgThr,3)
    temp(:,:,i) = imgaussfilt(double(bwareaopen(imgThr(:,:,i),10)),5);
    imgThrSum(i) = sum(sum(temp(:,:,i)));
end
%% find peaks and area
figure; findpeaks(smooth(imgThrSum),'MinPeakProminence',10)
[pks, locs] = findpeaks(smooth(imgThrSum),'MinPeakProminence',10);
m = size(locs,1);
areas = [];

%%
scalingFactor = 1^2; % 1 pixel/micron on 710
[x,y,t] = size(imgThr);
indexToKill = []; crenImage = zeros(x,y,'logical');
figure;
for i=1:m
    tempImg = temp(:,:,locs(i));
    vals = tempImg(tempImg > 0);
    thr = prctile(vals,20);
    tempImg = tempImg > thr;
    %tempImg = bwareaopen(tempImg,200);
    imagesc([tempImg imgThr(:,:,locs(i))]);
    keep = input(['Keep Event ' num2str(locs(i)) ' ?']);
    if keep
        areas = [areas; bwarea(tempImg)];
        crenImage(:,:,end+1) = tempImg;
    else
        indexToKill = [indexToKill; i];
    end
end

locs(indexToKill) = [];
pks(indexToKill) = [];
%%
Crens.name = fname;
Crens.locs = locs;
Crens.pks = pks;
Crens.areas = areas;
Crens.meanPlot = meanPlot;
Crens.imgSTD = imgSTD;
Crens.scalingFactor = scalingFactor;
Crens.crenationImg = crenImage;
Crens.baseImg = mean(X,3);
save([dname 'CaEventData_' name '.mat'],'Crens');

[h, h2] = drawCaEvents(Crens.crenationImg,Crens.locs,600,Crens.baseImg)


