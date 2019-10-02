function writeTif(img, fname, bits)

    if ~exist('bits','var')
        bits = 8;
        tagstruct.SampleFormat = Tiff.SampleFormat.Int;
    elseif bits == 16 && isa(img,'int16');
        tagstruct.SampleFormat = Tiff.SampleFormat.Int;
    elseif bits == 16 && isa(img,'uint16');
        tagstruct.SampleFormat = Tiff.SampleFormat.UInt;
    elseif bits == 32
        tagstruct.SampleFormat = Tiff.SampleFormat.IEEEFP;
    end
    
    t = Tiff(fname,'w');
    numImages = size(img,3);
    
    %intial directory
    tagstruct.ImageLength = size(img,1);
    tagstruct.ImageWidth = size(img,2);
    tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
    tagstruct.BitsPerSample = bits;
    tagstruct.SamplesPerPixel = 1;
    tagstruct.RowsPerStrip = size(img,1);
    tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
    tagstruct.Software = 'MATLAB';
    tagstruct.Compression = 1;
    t.setTag(tagstruct)
    
    for i = 1:numImages
        t.setTag(tagstruct);
        t.write(img(:,:,i));
        t.writeDirectory();
    end
    
    t.close();
end
