inputPath = getDirectory("Choose input folder");

filename = getFileList(inputPath);

outputPath = getDirectory("Choose output folder");


function action(input, output, filename) {
	open(input+filename);
	original = getImageID();
	run("Duplicate...", " ");
	duplicate = getImageID();
	selectImage(duplicate);
	
// Color Thresholder 2.9.0/1.53t
// Standard macro using the Colour threshold option in FIJI
// Can be personalized using the Colour threshold option --> Select optimized settings --> Click macro --> Copy + paste macro below
min=newArray(3);
max=newArray(3);
filter=newArray(3);
run("HSB Stack");
run("Convert Stack to Images");
selectWindow("Hue");
rename("0");
selectWindow("Saturation");
rename("1");
selectWindow("Brightness");
rename("2");
min[0]=0;
max[0]=103;
filter[0]="pass";
min[1]=40;
max[1]=255;
filter[1]="pass";
min[2]=107;
max[2]=255;
filter[2]="pass";
for (i=0;i<3;i++){
  selectWindow(""+i);
  setThreshold(min[i], max[i]);
  run("Convert to Mask");
  if (filter[i]=="stop")  run("Invert");
}
imageCalculator("AND create", "0","1");
imageCalculator("AND create", "Result of 0","2");
for (i=0;i<3;i++){
  selectWindow(""+i);
  close();
}
selectWindow("Result of 0");
close();
selectWindow("Result of Result of 0");
// Colour Thresholding-------------


setOption("BlackBackground", true);
run("Convert to Mask");
run("Fill Holes");
run("Analyze Particles...", "size=50000-Infinity show=Masks"); // To remove small background objects
setOption("BlackBackground", false);
run("Create Selection");
selectImage(original);
run("Restore Selection");
setBackgroundColor(0, 0, 0);
run("Clear Outside");

	saveAs(".jpeg", outputPath+filename);
	close("*");
	}
	
setBatchMode(true); 
list = getFileList(inputPath);
for (i = 0; i < list.length; i++)
        action(inputPath, outputPath, list[i]);
setBatchMode(false);