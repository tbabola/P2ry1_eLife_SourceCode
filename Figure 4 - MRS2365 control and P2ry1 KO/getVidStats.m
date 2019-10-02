function [crens] = getVidStats(dname, analyze)
   interval = 120; %time in seconds between puffs
   
    temp = dir(dname);
    folderList = struct([]);
    for i = 1:size(temp,1)
        tempfolds = dir([temp(i).folder '\' temp(i).name]);
        folderList = [folderList; tempfolds(3:end)];
    end

    if exist('crens')
        clear 'crens'
    end
    
    for i = 1:size(folderList,1)
            
        if analyze(1)
            fileList = loadFileList([folderList(i).folder '\' folderList(i).name '\*MRS2365.tif']);
            saveList = fileList;
            if ~isempty(fileList)
                img = loadTif(fileList{1},8);
                [~,~,img] = normalizeImg(img,10,1);
                imgs = int8(img) - int8(mean(img(:,:,1:3),3));
                crens(i).OC = squeeze(mean(mean(imgs)));
                
                %%%more complex analysis, take first five frames of each
                %%%puff trial as baseline
                for j = 1:5
                    puffsimg(:,:,:,j) = img(:,:,1+(120*(j-1)):120+(120*(j-1)));
                    blpuff = mean(puffsimg(:,:,1:5,j),3);
                    puffsimg(:,:,:,j) = int8(puffsimg(:,:,:,j)) - int8(blpuff);
                    puffsOC(j,:) = squeeze(mean(mean(puffsimg(:,:,:,j))));
                end
                crens(i).puffsOC = puffsOC;
            else
                crens(i).OC = NaN;
            end
            
        end

        if ~isempty(saveList)
            tempCell = crens(i);
            [sdir,f,ext] = fileparts(saveList{1});
            save([sdir '\' f '_crenstats.mat'],'tempCell');
        end
    end
end