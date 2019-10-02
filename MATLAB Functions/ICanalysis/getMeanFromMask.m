function [signal] = getMeanFromMask(img,mask)
%getMeanFromMask Returns mean signal over time across a masked area
%   img: input time series image
%   mask: binary mask of desired signal area
    [idx] = find(mask);
    signal = zeros(size(img,3),1);
    for i=1:size(img,3)
        temp = img(:,:,i);
        signal(i) = mean(temp(idx));
    end
end

