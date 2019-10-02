function [LICmask, RICmask, ctxmask] = getROImasks(X)
    Xmean = mean(X,3);
    [m,n] = size(Xmean);
    
    h = figure('Position',[250 250 800 250]);
    %h.Position([50 50 800 600]);
    h_im = imagesc(Xmean);
     
    LIC = imellipse(gca,[60,35,150,85]);
    setResizable(LIC,0);
    wait(LIC);
    LICmask = createMask(LIC, h_im);
    
    RIC = imellipse(gca,[300,35,150,85]);
    setResizable(RIC,0);
    wait(RIC);
    RICmask = createMask(RIC, h_im);
    
    
    ctxmask = zeros(m,n);
    ctxmask(1:20,2:end-1) = 1;
end