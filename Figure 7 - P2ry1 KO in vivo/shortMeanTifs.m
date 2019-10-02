%%example images
list = loadFileList('.\Data\*\*.tif');
for i=1:size(list,1)
    img = loadTif(list{i},16);
    meanImg = uint16(mean(img(:,:,1000:4000),3));
    meanSubt = mean(img(:,:,1000:4000)-meanImg,3);
    [dname, fname, ext] = fileparts(list{i});
    foldername = regexp(fname,'Experiment-\d*','match');
    foldername = foldername{1};
    writeTif(uint16(meanSubt), [dname '\' foldername '\meantif_short.tif'],16);
end

