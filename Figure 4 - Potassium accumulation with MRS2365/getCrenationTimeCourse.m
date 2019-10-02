function [cellS] = getCrenationTimeCourse(dname, analyze, plotFlag)

    temp = dir(dname);
    folderList = struct([]);
    folderList = temp(3:end);
    
    if exist('cell') | exist('cellS') 
        clear 'cell' 'cellS'; 
    end
    cellS = struct([]);
    for i = 1:size(folderList,1)
            
        if analyze(1) %% input resistance
            fileList = loadFileList([folderList(i).folder '\' folderList(i).name '\*vid*.tif']);
            cellS(i).timecourse = nan(3,300);

            for j = 1:size(fileList,1)
               img = loadTif(fileList{j},8);
               img = uint8(bleachCorrect(img,1));
               baselineimg = uint8(mean(img(:,:,15:30),3));
               blsubt = img - baselineimg;
               temp = squeeze(mean(mean(blsubt,2),1));
               baselineimg2 = uint8(mean(img(:,:,15:end),3));
               blsubt2 = img - baselineimg2;
               temp2 = squeeze(mean(mean(blsubt2,2),1));
               
               
               if size(temp,1) >= 300
                 cellS(i).timecourse(j,:) = temp(1:300);
                 cellS(i).timecourse2(j,:) = temp2(1:300);
               else
                 cellS(i).timecourse(j,1:size(temp,1)) = temp;
                 cellS(i).timecourse2(j,1:size(temp2,1)) = temp2;
               end
            end
        end
        
        if plotFlag
            figure;
            plot(cellS(i).timecourse','Color',[0.7 0.7 0.7]); hold;
            plot(mean(cellS(i).timecourse,1),'Color','k');
        end 
        
        tempCell = cellS(i);
        [sdir,f,ext] = fileparts(fileList{1});           
        save([sdir '\' 'crenation_tc.mat'],'tempCell');
    end
        
end

function [imgBC] = bleachCorrect(img, sampRate)
    %%This function is based off of the bleach correction algorithm in 
    %%ImageJ. Bleach Correction by Fitting Exponential Decay function.
    %%Kota Miura (miura@embl.de)
    
    [m,n,T] =size(img);
    meanIntensity = squeeze(mean(mean(img,1),2));
    time = ([1:1:T]./sampRate)';

    B = fitExponentialWithOffset(time,meanIntensity);
    imgBC = zeros(size(img),'int16');
    for i=1:T
        ratio = calcExponentialOffset(B, 0.0) / calcExponentialOffset(B, i/sampRate);
        ratioplot(i) = ratio;
        imgBC(:,:,i) = img(:,:,i)*ratio;
    end
end

function [eo] = calcExponentialOffset(B, x)
 		eo = B(1) * exp(B(2)*x) + B(3);
end

function [B] = fitExponentialWithOffset(x, y)
    f = @(b,x) b(1).*exp(b(2).*x) + b(3);
    nrmrsd = @(b) norm(y - f(b,x));
    B0 = [100;.005;3000];
    
    [B,rnrm] = fminsearch(nrmrsd, B0);
end
