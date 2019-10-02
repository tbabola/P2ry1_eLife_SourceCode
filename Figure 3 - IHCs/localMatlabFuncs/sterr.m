function stErr = sterr(data, dim)
    m = size(data,dim);
    stErr = nanstd(data,[],dim)/sqrt(m);
end