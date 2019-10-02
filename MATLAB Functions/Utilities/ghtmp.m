function R = ghtmp
 R = zeros(256,3);
 R(1:256,:) = repmat([0:1:255]/255,3,1)';
end