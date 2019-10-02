function tempCells = loadCellStructs(dname)

    fileList = loadFileList(dname);
    
    for i=1:size(fileList,1)
        s = load(fileList{i});
        fns = fieldnames(s);
        tempCells(i)= s.(fns{1});
    end
end
