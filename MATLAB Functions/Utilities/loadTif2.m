function img = loadTif2(fname,bits)

    switch bits
            case 8
                bitstr = 'uint8';
            case 16
                bitstr = 'uint16';
            case 32
                bitstr = 'single';
            otherwise
                bitstr = 'uint8';
                disp('May not be loading tiff properly');
    end
    
    infoImage=imfinfo(fname);
    numImages = numel(infoImage);
    mImage=infoImage(1).Width;
    nImage=infoImage(1).Height;
    img=zeros(nImage,mImage,numImages,bitstr);
    
    for i=1:numImages
         img(:,:,i) = imread(fname,i);
    end
end
