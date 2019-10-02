function [figh] = handleTheSubplot(handles,dim)
%UNTITLED This function takes individual plots and copies them into a new
% figure as subplots. This is primarily to overcome the minimum window
% width imposed by windows and is best suited for making 'skinny' graphs.
%   %handles: cell array of figure handles
    %dim: dimensions of subplots
    %yticks: cell array of yticks 
    if size(handles,2) ~= dim(1) * dim(2)
        disp('Dimension does not equal the number of handles.');
        return
    end
    
    figh = figure;
    axhandles = {};
    for i = 1:size(handles,2)
        axhandles{i} = copyobj(handles{i}.Children,figh);
        subplot(dim(1),dim(2),i,axhandles{i});
    end
    
end

