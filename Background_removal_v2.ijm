//Dialog selection menu
  Dialog.create("Add HSB values to segmentate image");
  Dialog.addMessage("Image information", 15, "black");
  Dialog.addDirectory("Input files directory", "");
  Dialog.addDirectory("Output files directory", "");
  Dialog.addChoice("input file extension", newArray("JPG", "jpg", "jpeg", "png", "tif", "tiff", "Gif"));
  Dialog.addChoice("Output file extension", newArray("JPG", "jpg", "jpeg", "png", "tif", "tiff", "Gif"));
  Dialog.addMessage("Minimum object pixel size", 15, "black");
  Dialog.addNumber("Minimum object area:", 50000);
  Dialog.addMessage("HSB thresholding; Check image > adjust > colour threshold for optimal settings", 15, "black");
  Dialog.addNumber("Hue minimum:", 0);
  Dialog.addToSameRow();
  Dialog.addNumber("Hue maximum:", 103);
  Dialog.addNumber("Saturation minimum:", 40);
  Dialog.addToSameRow();
  Dialog.addNumber("Saturation maximum:", 255);
  Dialog.addNumber("Brightness minimum:", 107);
  Dialog.addToSameRow();
  Dialog.addNumber("Brightness maximum:", 255);
  Dialog.show();
  inputPath = Dialog.getString()
  outputPath = Dialog.getString()
  In_ext = Dialog.getChoice();
  Out_ext = Dialog.getChoice();
  area = Dialog.getNumber();
  Hue_min = Dialog.getNumber();
  Hue_max = Dialog.getNumber();
  Sat_min = Dialog.getNumber();
  Sat_max = Dialog.getNumber();
  Bri_min = Dialog.getNumber();
  Bri_max = Dialog.getNumber();

filename = getFileList(inputPath);

function action(input, output, filename) {
	if(endsWith(filename, In_ext)) {
	open(input+filename);
	original = getImageID();
	run("Duplicate...", " ");
	duplicate = getImageID();
	selectImage(duplicate);
	
// Color Thresholder macro code
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
min[0]=Hue_min;
max[0]=Hue_max;
filter[0]="pass";
min[1]=Sat_min;
max[1]=Sat_max;
filter[1]="pass";
min[2]=Bri_min;
max[2]=Bri_max;
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

//Selection of objects and removal of background
setOption("BlackBackground", true);
run("Convert to Mask");
run("Fill Holes");
run("Analyze Particles...", "size=area-Infinity show=Masks"); // To remove small background objects
setOption("BlackBackground", false);
run("Create Selection");
selectImage(original);
run("Restore Selection");
setBackgroundColor(0, 0, 0);
run("Clear Outside");

	name = File.nameWithoutExtension;
	new_name = replace(name, "_whitebalance", "");
	saveAs(Out_ext, outputPath+new_name+"_segmented");
	close("*");
	}
}
	
setBatchMode(true); 
list = getFileList(inputPath);
for (i = 0; i < list.length; i++)
        action(inputPath, outputPath, list[i]);
setBatchMode(false);
