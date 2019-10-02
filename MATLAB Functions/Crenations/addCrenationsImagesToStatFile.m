%%batch processing of events already chosen

list = loadFileList('.\Data\Crenations\P7_8\*Baseline.tif');
imgList = list(~contains(list,'Washout'));
list = loadFileList('.\Data\Crenations\P7_8\*Baseline.mat');
statList = list(~contains(list,'Washout'));

for i=1:size(statList,1)
    img = loadTif(imgList{i},8);
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
    
    load(statList{i});
    events = getCrenationAreas(imgThr,Crens.locs);
    Crens.crenationImg = events;
    
    save(statList{i},'Crens');
end
