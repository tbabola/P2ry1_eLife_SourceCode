%function [SCactivity, bin, bin2] = getSCactivity(dFoF,mask)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    [r,c] = find(mask); %%assume rectangle ROI
    width = max(c) - min(c) + 1;
    height = max(r) - min(r) + 1;
    [idx] = find(mask);
    
    SCimage = zeros(height,width, size(dFoF,3));
    SCimageres = zeros(height/5,width/5, size(dFoF,3));
    
    %%downsample mask by a factor of 5
    parfor i = 1:size(dFoF,3)
        temp = dFoF(:,:,i);
        temp = temp(idx);
        SCimage(:,:,i) = reshape(temp,height, width);
        SCimageres(:,:,i) = imresize(SCimage(:,:,i),[height/5 width/5]);
    end
    
    [m,n,t] = size(SCimageres);
    SCimageres = reshape(SCimageres,m*n,t);
    SCimageres = SCimageres';
%     subtMean = mean(SCimageres,2);
%     signalCorrected = SCimageres-subtMean;
%     mSC = signalCorrected;
%     resThr = mean(mSC,1)+3*std(mSC,[],1);
%     bin = mSC > resThr;
%     SCactivity = mSC;
    
%     %% old function
%     [m,n,t] = size(SCimage);
%     subtMean = mean(reshape(SCimage,m*n,t),1);
%     signalCorrected = reshape(smooth(reshape(SCimage,m*n,t)-subtMean),m,n,t);
%     mSC = squeeze(mean(signalCorrected,1));
%     
%     resThr = mean(mSC,2)+3*std(mSC,[],2);
%     bin2 = [];
%     for i = 1:size(resThr,1)
%         bin2(:,i) = mSC(i,:) > resThr(i);
%     end
%     bin2 = imgaussfilt(bin2,5);
%     SCactivity = mSC;

%end

