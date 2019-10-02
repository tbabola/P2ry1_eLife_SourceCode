function [cellS] = getKpuffStats(dname, analyze,plotFlag)
    pulse = -5; %test pulse in pA for resistance measurement
    pulseTime = [0 0.01 0.2 0.26]; %periods to measure resistance [baseline_start baseline_end ss_start ss_end]
    IVstep_baseline = [0 .09];
    IVstep_measure = [.170 .19];
    IVsteps = [-110:10:0];
    
    temp = dir(dname);
    folderList = struct([]);
    folderList = temp(3:end);

    if exist('cell') | exist('cellS') 
        clear 'cell' 'cellS'; 
    end
    
    for i = 1:size(folderList,1)
            
        if analyze(1) %% input resistance
            fileList = loadFileList([folderList(i).folder '\' folderList(i).name '\*_pp.abf']);
            if ~isempty(fileList)
                [d,time] = loadPclampData(fileList{1});
                cellS(i).pulseR = calcRm(d,time,pulse,pulseTime);
            else
                cellS(i).pulseR = NaN;
            end
            
            fileList = loadFileList([folderList(i).folder '\' folderList(i).name '\*_steps1.abf']);
            if ~isempty(fileList)
                [d,time] = loadPclampData(fileList{1});
                baselines = mean(d(time > IVstep_baseline(1) & time < IVstep_baseline(2),:),1);
                i_response = mean(d(time > IVstep_measure(1) & time < IVstep_measure(2),:),1);
                delta = i_response - baselines;
                [slope] = polyfit(IVsteps(1:5)*10^-3,delta(1:5)*10^-12,1);
                beginR = 1/slope(1) * 10^-6; %%resistance in megaohms
                if plotFlag
                    figure;
                    plot(IVsteps, delta,'o','Color','k'); hold on;
                    plot(IVsteps(1:5), slope(1)*10^12/10^3*IVsteps(1:5)+slope(2)*10^12,'Color','k'); % best fit line
                end
                
                cellS(i).beginR = beginR;
            else
                cellS(i).beginR = NaN;
            end
            
            fileList = loadFileList([folderList(i).folder '\' folderList(i).name '\*_steps2.abf']);
            if ~isempty(fileList)
                [d,time] = loadPclampData(fileList{1});
                baselines = mean(d(time > IVstep_baseline(1) & time < IVstep_baseline(2),:),1);
                i_response = mean(d(time > IVstep_measure(1) & time < IVstep_measure(2),:),1);
                delta = i_response - baselines;
                [slope] = polyfit(IVsteps(1:5)*10^-3,delta(1:5)*10^-12,1);
                endR = 1/slope(1) * 10^-6; %%resistance in megaohms
                if plotFlag
                    plot(IVsteps, delta,'o','Color','r'); hold on;
                    plot(IVsteps(1:5), slope(1)*10^12/10^3*IVsteps(1:5)+slope(2)*10^12,'Color','r'); % best fit line
                end
                
                cellS(i).midR = endR;
            else
                cellS(i).midR = NaN;
            end
            
            fileList = loadFileList([folderList(i).folder '\' folderList(i).name '\*_steps3.abf']);
            if ~isempty(fileList)
                [d,time] = loadPclampData(fileList{1});
                baselines = mean(d(time > IVstep_baseline(1) & time < IVstep_baseline(2),:),1);
                i_response = mean(d(time > IVstep_measure(1) & time < IVstep_measure(2),:),1);
                delta = i_response - baselines;
                [slope] = polyfit(IVsteps(1:5)*10^-3,delta(1:5)*10^-12,1);
                endR = 1/slope(1) * 10^-6; %%resistance in megaohms
                if plotFlag
                    plot(IVsteps, delta,'o','Color','r'); hold on;
                    plot(IVsteps(1:5), slope(1)*10^12/10^3*IVsteps(1:5)+slope(2)*10^12,'Color','r'); % best fit line
                end
                
                cellS(i).endR = endR;
            else
                cellS(i).endR = NaN;
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
            baselines = nan(3,150); outwardK = baselines; tailK = baselines;
                fileList = loadFileList([folderList(i).folder '\' folderList(i).name '\*k1.abf']);
                saveList = fileList;
                [d,time] = loadPclampData(fileList{1});
                
                cellS(i).baselineKresponse = mean(d(:,1:10),2);
                cellS(i).MRSKresponse = mean(d(:,17:25),2);
                [d,time] = loadPclampData(fileList{2});
                cellS(i).washoutKresponse = mean(d(:,21:30),2);
                cellS(i).time = time;
                cellS(i).d = d;
            
            if ~isempty(fileList)
                cellS(i).outK = outwardK;
                cellS(i).tailK = tailK;
                cellS(i).baselineK = baselines;
            else
                cellS(i).outK = NaN;
                cellS(i).tailK = NaN;
                cellS(i).baselineK = NaN;
            end
        end
        
        if plotFlag
            figure;
            plot([0:2:298],tailK'-mean(tailK(:,1:15)'),'o','Color',[0.7 0.7 0.7]);
            hold on;
            plot([0:2:298],mean(tailK'-mean(tailK(:,1:15)'),2),'LineWidth',2,'Color','k');
            figure;
            plot([0:2:298],outwardK','o');
            hold on;
            plot([0:2:298],mean(outwardK',2),'LineWidth',2,'Color','k');
            
        end 
        
        if ~isempty(saveList)
            tempCell = cellS(i);
            [sdir,f,ext] = fileparts(saveList{1});
            save([sdir '\' f '_stats.mat'],'tempCell');
        end
    end
end