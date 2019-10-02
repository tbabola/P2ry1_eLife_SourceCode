function [SCactivity, bin, events] = getSCactivity_new(dFoF,mask)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    [r,c] = find(mask); %%assume rectangle ROI
    width = max(c) - min(c) + 1;
    height = max(r) - min(r) + 1;
    [idx] = find(mask);
    
    SCimage = zeros(height,width, size(dFoF,3));
    SCimageres = zeros(round(height/5),round(width/5), size(dFoF,3));
    
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
    %cutoff to be considered an active point, i.e. remove inactive areas
    %from mean
    thr = 0.3;
    index = find(std(SCimageres,[],1)<0.02);
    size(index)
    SCimageres(:,index) = NaN(size(SCimageres,1),size(index,2));
    
    subtMean = nanmean(SCimageres,2);
     signalCorrected = SCimageres-subtMean*1.4;
     mSC = signalCorrected;
     resThr = mean(mSC,1)+3*std(mSC,[],1);
     bin = mSC > resThr;
     SCactivity = mSC;
    
     
     %%quantify number of events and durations
     labels = bwlabel(smooth(sum(bin,2),10));
     n_labels = zeros(size(labels));
     for i = 1:max(labels)
         lbl_idx = find(labels == i);
         if size(lbl_idx,1) > 50
             n_labels(lbl_idx) = 1;
         else
             
         end
     end
     n_labels = bwlabel(n_labels);
     m_bin = mean(bin,2);
     events = struct([]);
     for i=1:max(n_labels)
         events(i).locs = find(n_labels == i);
         events(i).startFrame = events(i).locs(1);
         events(i).dur = size(events(i).locs,1)/10;
         events(i).maxNumROIs = max(m_bin(events(i).locs));
     end
     %figure; plot(labels); hold on; plot(n_labels)

end

