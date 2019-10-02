%%clean up file name

list = dir('.\Data\WT_MRS2500_Kpuff\');
list = list(3:end);
for i = 1:size(list,1)
    fileList = loadFileList([list(i).folder '\' list(i).name '\*.abf'])
    if size(fileList,1) == 7 & ~sum(contains(fileList,'pp'))
        disp('Success');
        for j = 1:7
            [fp,name,ext] = fileparts(fileList{j});
            switch j
                case 1 
                    name2 = [name '_pp'];
                case 2 
                    name2 = [name '_gfi'];
                case 3 
                    name2 = [name '_steps1'];
                case 4 
                    name2 = [name '_k1'];
                case 5 
                    name2 = [name '_k2'];
                case 6 
                    name2 = [name '_k3'];
                case 7 
                    name2 = [name '_steps2'];
            end
           [fp '\' name ext]
           movefile([fp '\' name ext],[fp '\' name2 ext])
        end
    else
    end
end

%%
%%clean up file name

list = dir('.\Data\WT_MRS2500_Kpuff\');
list = list(3:end);
for i = 1:size(list,1)
    fileList = loadFileList([list(i).folder '\' list(i).name '\*.abf'])
    if size(fileList,1) == 7 & ~sum(contains(fileList,'pp'))
        disp('Success');
        for j = 1:7
            [fp,name,ext] = fileparts(fileList{j});
            switch j
                case 1 
                    name2 = [name '_pp'];
                case 2 
                    name2 = [name '_gfi'];
                case 3 
                    name2 = [name '_steps1'];
                case 4 
                    name2 = [name '_k1'];
                case 5 
                    name2 = [name '_steps2'];
                case 6 
                    name2 = [name '_k2'];
                case 7 
                    name2 = [name '_steps3'];
            end
           [fp '\' name ext]
           movefile([fp '\' name ext],[fp '\' name2 ext])
        end
    else
    end
end


