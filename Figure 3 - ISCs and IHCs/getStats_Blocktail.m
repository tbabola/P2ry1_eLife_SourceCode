function [cellS] = getStats_Blocktail(dname, analyze, plotFlag)
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
            fileList = loadFileList([folderList(i).folder '\' folderList(i).name '\*_bp.abf']);
            
            if ~isempty(fileList)
                [d,time] = loadPclampData(fileList{1});
                cellS(i).breakinR = calcRm(d,time,pulse,pulseTime);
            else
                cellS(i).breakinR = NaN;
            end
            
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
            fileList = loadFileList([folderList(i).folder '\' folderList(i).name '\*_gfv.abf']);
            saveList = fileList;
            if ~isempty(fileList)
                [d,time] = loadPclampData(fileList{1});
                 baseline = [7*60 10*60];
                 drug = [18*60 20*60];
                 calctps = time >= baseline(1) & time <= baseline(2);
                 sstps = time >= drug(1) & time <= drug(2);
                 maxPt = prctile(d(calctps),95);
                 minPt = prctile(d(sstps),95);
                 
                 if plotFlag
                     figure; plot(time,d,'Color','k');
                     line([baseline],[maxPt maxPt],'Color','k','LineWidth',2);
                     line([drug], [minPt minPt],'Color','r','LineWidth',2);
                 end
                 cellS(i).inwardCurrent = minPt - maxPt;
                 cellS(i).d = d;
                 cellS(i).time = time;
                 cellS(i).minPt = maxPt;
            else
                 cellS(i).inwardCurrent = NaN;
                 cellS(i).d = NaN;
                 cellS(i).time = NaN;
                 cellS(i).minPt = NaN;
            end
    
        end
        
        if ~isempty(saveList)
            tempCell = cellS(i);
            [sdir,f,ext] = fileparts(saveList{1});
            save([sdir '\' f '_stats.mat'],'tempCell');
        end
    end
end