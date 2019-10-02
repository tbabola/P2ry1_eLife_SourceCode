/*for (i = 0; i < 10; i++){
start = 1540+ (i)*10;
end = start + 200;
selectWindow("Result of Experiment-403_Snap25GC6s_Catheter_sham-1.czi");
run("Temporal-Color Code", "lut=Spectrum start="+start+" end="+end + " create");
}

/*
run("Duplicate...", "duplicate");
//setTool("freehand");
run("8-bit");
run("Temporal-Color Code", "lut=Spectrum start=850 end=1100 create");
selectWindow("MAX_colored-12");
selectWindow("Result of Experiment-369_Snap25GC6s_Catheter_sham-1.czi");
selectWindow("MAX_colored-12");
selectWindow("Result of Experiment-369_Snap25GC6s_Catheter_sham-1.czi");
