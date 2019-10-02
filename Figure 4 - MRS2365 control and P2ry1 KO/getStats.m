function [cellS] = getStats(dname, analyze)
    pulse = -100; %test pulse in pA for resistance measurement
    pulseTime = [0 0.01 0.2 0.26]; %periods to measure resistance [baseline_start baseline_end ss_start ss_end]
    
    temp = dir(dname);
    folderList = struct([]);
    for i = 1:size(temp,1)
        tempfolds = dir([temp(i).folder '\' temp(i).name]);
        folderList = [folderList; tempfolds(3:end)];
    end

    if exist('cell') | exist('cellS') 
        clear 'cell' 'cellS'; 
    end
    
    for i = 1:size(folderList,1)
            
        if analyze(1)
            fileList = loadFileList([folderList(i).folder '\' folderList(i).name '\*_p.abf']);
            if ~isempty(fileList)
                [d,time] = loadPclampData(fileList{1});
                cellS(i).preR = calcRm(d,time,pulse,pulseTime);
            else
                cellS(i).preR = NaN;
            end
            
            fileList = loadFileList([folderList(i).folder '\' folderList(i).name '\*_pp.abf']);
            if ~isempty(fileList)
                [d,time] = loadPclampData(fileList{1});
                cellS(i).postR = calcRm(d,time,pulse,pulseTime);
            else
                cellS(i).postR = NaN;
            end
        end
        
        if analyze(2)
            fileList = loadFileList([folderList(i).folder '\' folderList(i).name '\*_gfi.abf']);
            if ~isempty(fileList)
                [d,time,SR] = loadPclampData(fileList{1});
                out = msbackadj(time, d, 'WindowSize', 60,'StepSize',60);
                cellS(i).Vm = mean(d - out);
            else
                cellS(i).Vm = NaN;
            end
        end
        
        if analyze(3) %change in inward current
            fileList = loadFileList([folderList(i).folder '\' folderList(i).name '\*_MRS2365.abf']);
            saveList = fileList;
            if ~isempty(fileList)
                [d,time] = loadPclampData(fileList{1});
                blsubtd = d - mean(d(time > 0 & time <= 4,:),1);
                blsubtd = reshape(smooth(blsubtd,100),size(blsubtd));
                cellS(i).rawD = d;
                cellS(i).time = time;
                cellS(i).meanD = mean(blsubtd,2);
                cellS(i).blsubtd = blsubtd;
                cellS(i).peaks = NaN(1,5)
                cellS(i).peaks(1:size(blsubtd,2)) = min(blsubtd(time> 5 & time <= 30,:))
                cellS(i).peaks(cellS(i).peaks > 0) = NaN;
            else
                cellS(i).rawD = NaN;
                cellS(i).time = NaN;
                cellS(i).meanD = NaN;
                cellS(i).peaks = NaN;
            end
    
        end
        
        if ~isempty(saveList)
            tempCell = cellS(i);
            [sdir,f,ext] = fileparts(saveList{1});
            save([sdir '\' f '_WTstats.mat'],'tempCell');
        end
    end
end