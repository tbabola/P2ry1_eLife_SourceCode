function figQuality(figh, axh, dim)
    %figh = figure handle
    %axh = axis handle
    %dim = [w h] in inches
    figh.Units = 'inches';
    figh.Position = [0 0 dim];
    figh.Renderer = 'Painters';
    figh.Color = [1 1 1];
    figh.PaperPositionMode = 'auto'; 
    box off;
    set(axh,'LooseInset',get(axh,'TightInset')) 
    
    allAxesInFigure = findall(figh,'type','axes');
    for i=1:size(allAxesInFigure,1)
        axh = allAxesInFigure(i);
        axh.FontSize = 10;
        axh.FontName = 'Arial';
        axh.LineWidth = 1.5;
        axh.TickDir = 'out';
    end

end

