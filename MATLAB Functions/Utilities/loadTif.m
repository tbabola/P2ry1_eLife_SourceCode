function img = loadTif(fname,bits)
    if ~exist('bits','var')
        bits = 8;
    end
    
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
    warning('off', 'MATLAB:imagesci:tiffmexutils:libtiffErrorAsWarning');
    %loadTif Loads a multipage tiff and returns the image
    infoImage=imfinfo(fname);
    mImage=infoImage(1).Width;
    nImage=infoImage(1).Height;
    numberImages=length(infoImage);
    img=zeros(nImage,mImage,numberImages,bitstr);
    t = Tiff(fname,'r');
    
    for i=1:numberImages
         t.setDirectory(i);
         img(:,:,i) = t.read();
    end
    t.close();
end
