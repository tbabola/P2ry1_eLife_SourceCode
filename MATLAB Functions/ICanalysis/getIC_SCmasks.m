function [LICmask, RICmask, LSCmask, RSCmask] = getIC_SCmasks(X)
    Xmean = mean(X(:,:,100),3);
    [m,n] = size(Xmean);
    
    h = figure;
    
    %h.Position([50 50 800 600]);
    h_im = imagesc(Xmean);
    colormap gray;
    truesize;
    
    LSC = imrect(gca,[110,125,200,150]);
    setResizable(LSC,0);
    wait(LSC);
    LSCmask = createMask(LSC, h_im);
    
    RSC = imrect(gca,[270,125,200,150]);
    setResizable(RSC,0);
    wait(RSC);
    RSCmask = createMask(RSC, h_im);

    LIC = imellipse(gca,[60,260,150,85]);
    setResizable(LIC,0);
    wait(LIC);
    LICmask = createMask(LIC, h_im);
    
    RIC = imellipse(gca,[300,260,150,85]);
    setResizable(RIC,0);
    wait(RIC);
    RICmask = createMask(RIC, h_im);
    
end