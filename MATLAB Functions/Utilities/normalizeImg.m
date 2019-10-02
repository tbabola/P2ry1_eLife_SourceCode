function [dFoF, Fo, img] = normalizeImg(img, percentile, bleachCorrectFlag)
%normalizeImg Normalizes image based on percentile chosen after bleach correction. 
%   On a pixel by pixel basis, Fo is created by taking the pixel value at
%   the xth percentile. This is subtracted off of the original image; the
%   resulting image is then divided by Fo. 

    sampRate = 10; %sampling rate in Hz
    [m,n,T] = size(img);
    
    if bleachCorrectFlag
     img = bleachCorrect(img,sampRate);
     disp('Bleach correction finished. Subtracting baseline...');
    end
    
    %Normalize by taking Xth percentile
    Xreshape = reshape(img,m*n,T)';
    Fo = prctile(Xreshape,percentile,1);
    Fo = reshape(Fo',m,n);
    

    dFoF = (single(img) - single(Fo)) ./ single(Fo);
    %dFoF = double(img - Fo) ./ double(Fo);
end

function [imgBC] = bleachCorrect(img, sampRate)
    %%This function is based off of the bleach correction algorithm in 
    %%ImageJ. Bleach Correction by Fitting Exponential Decay function.
    %%Kota Miura (miura@embl.de)
    
    [m,n,T] =size(img);
    meanIntensity = squeeze(mean(mean(img,1),2));
    time = ([1:1:T]./sampRate)';

    B = fitExponentialWithOffset(time,meanIntensity);
    imgBC = zeros(size(img),'int16');
    for i=1:T
        ratio = calcExponentialOffset(B, 0.0) / calcExponentialOffset(B, i/sampRate);
        ratioplot(i) = ratio;
        imgBC(:,:,i) = img(:,:,i)*ratio;
    end
end

function [eo] = calcExponentialOffset(B, x)
 		eo = B(1) * exp(B(2)*x) + B(3);
end

function [B] = fitExponentialWithOffset(x, y)
    f = @(b,x) b(1).*exp(b(2).*x) + b(3);
    nrmrsd = @(b) norm(y - f(b,x));
    B0 = [100;.005;3000];
    
    [B,rnrm] = fminsearch(nrmrsd, B0);
end
