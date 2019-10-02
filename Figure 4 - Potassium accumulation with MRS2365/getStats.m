function [cellS] = getStats(dname, analyze,plotFlag)
    pulse = -5; %test pulse in pA for resistance measurement
    pulseTime = [0 0.01 0.2 0.26]; %periods to measure resistance [baseline_start baseline_end ss_start ss_end]
    IVstep_baseline = [0 .09];
    IVstep_measure = [.170 .19];
    IVsteps = [-110:10:0];
    K_baseline = [0 .09]; %baseline times for potassium accumulation steps
    K_out = [.22 .24];
    K_tail = [.242 .243];
    
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
            for j = 1:3
                fileList = loadFileList([folderList(i).folder '\' folderList(i).name '\*k' num2str(j) '.abf']);
                saveList = fileList;
                [d,time,fs] = loadPclampData(fileList{1});
                bl = mean(d(time > K_baseline(1) & time < K_baseline(2),:),1);
                ow = mean(d(time > K_out(1) & time < K_out(2),:),1);
                tk = mean(d(time > K_tail(1) & time < K_tail(2),:),1);
                
                numpts = size(bl,2);
                if numpts >= 150
                    baselines(j,:) = bl(1:150);
                    outwardK(j,:) = ow(1:150);
                    tailK(j,:) = tk(1:150);
                elseif numpts < 150
                    baselines(j,1:numpts) = bl;
                    outwardK(j,1:numpts) = ow;
                    tailK(j,1:numpts) = tk;
                end
                
                dc = d;
                dc(time > 0.08 & time < 0.6,:) = NaN;
                dc = fillmissing(dc,'linear');
                
                totpnts = size(dc(:),1);
                if totpnts ~= 6000000
                    temp = NaN(1,6000000);
                    if totpnts < 6000000
                        temp(1:size(dc(:),1)) = dc(:);
                    else
                        temp = dc(1:6000000);
                    end
                    drepeat(j,:) = temp(:);
                else
                    drepeat(j,:) = dc(:);
                end
                
            end
            
            dc = nanmean(drepeat,1);

                
            if ~isempty(fileList)
                cellS(i).outK = outwardK;
                cellS(i).tailK = tailK;
                cellS(i).baselineK = baselines;
                cellS(i).dc = dc;
            else
                cellS(i).outK = NaN;
                cellS(i).tailK = NaN;
                cellS(i).baselineK = NaN;
                cellS(i).dc = NaN;
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