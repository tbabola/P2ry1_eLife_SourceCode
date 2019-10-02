dname = 'M:\Projects and Analysis\Papers\P2ry1\Figure - ISC agonist\Data\';
[fn dname] = uigetfile([dname '\*.tif']);

img = loadTif([dname fn],8);
[m,n,t] = size(img);
offset = 5;

img1 = double(img(:,:,1:end-offset));
img2 = double(img(:,:,1+offset:end));

imgSubt = img2-img1;
imgMean = mean(imgSubt,3);
imgSTD = std(imgSubt,1,3);
imgThrP = imgMean + 3*imgSTD;
imgThrN = imgMean - 3*imgSTD;
imgThr = imgSubt > imgThrP | imgSubt < imgThrN;
meanPlot = squeeze(mean(mean(imgThr,2),1));
%implay(imgThr);
figure(1); plot(meanPlot)

Crens.name = name;
Crens.meanPlot = meanPlot;
Crens.scalingFactor = scalingFactor;

 dirN = dname;
 [pathstr, name, ext] = fileparts([dname fn]);
save([dirN 'CrenationData_' name '.mat'],'Crens');
