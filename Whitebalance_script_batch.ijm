//Dialog box
  Dialog.create("Run whitebalance macro in single or batch mode");
  Dialog.addMessage("Image information", 15, "black");
  Dialog.addDirectory("Input files directory", "");
  Dialog.addDirectory("Output files directory", "");
  Dialog.addChoice("input file extension", newArray("JPG", "jpg", "jpeg", "png", "tif", "tiff", "Gif"));
  Dialog.addChoice("Output file extension", newArray("JPG", "jpg", "jpeg", "png", "tif", "tiff", "Gif"));
  Dialog.addMessage("Per image or batch whitebalancing mode", 15, "black");
  Dialog.addChoice("Mode", newArray("Single", "Batch"));
  Dialog.show();
  inputPath = Dialog.getString()
  outputPath = Dialog.getString()
  In_ext = Dialog.getChoice();
  Out_ext = Dialog.getChoice();
  Mode = Dialog.getChoice();

filename = getFileList(inputPath);

//Run single mode
if (Mode == "Single") {

for (i=0; i<filename.length; i++) {
	if(endsWith(filename[i], In_ext)) {
	open(inputPath+filename[i]);
	red = filename[i]+" (red)";
	blue = filename[i]+" (blue)";
	green = filename[i]+" (green)";

	setTool("rectangle"); //Set the rectangle selection tool
	waitForUser("Select white reference surface. Click OK when done"); //Asks user to select area (white reference)
	getSelectionBounds(x,y,width,height); //Sets x,y,width and height coordinates for selection
	    x_selection = x;
   	 	y_selection = y;
   	 	width_selection = width;
   	 	height_selection = height;

	run("Split Channels");
	selectWindow(red);
		makeRectangle(x_selection, y_selection, width_selection, height_selection); //Select region of white paper
		getStatistics(area, mean);
		mean_factor_red = 255/mean; //Calculate the factor of the white area to "perfect" white of an 8-bit image
		run("Select None");
		run("Multiply...", "value=mean_factor_red"); //Multiply the channel image by the factor calculated before

		selectWindow(green);
		makeRectangle(x_selection, y_selection, width_selection, height_selection);
		getStatistics(area, mean);
		mean_factor_green = 255/mean; 
		run("Select None");
		run("Multiply...", "value=mean_factor_green");

		selectWindow(blue);
		makeRectangle(x_selection, y_selection, width_selection, height_selection); 
		getStatistics(area, mean);
		mean_factor_blue = 255/mean;
		run("Select None");
		run("Multiply...", "value=mean_factor_blue");

	run("Merge Channels...", "red=["+red+"] green=["+green+"] blue=["+blue+"]"); //Merge separate RGB channels into one image
	name = File.nameWithoutExtension;
	saveAs(Out_ext, outputPath+name+"_whitebalance");
	close("*");
		setBatchMode(false);
	}
}

} 
//Runs batch mode
else {
//Open random reference image
open("");
setTool("rectangle"); //Set the rectangle selection tool
waitForUser("Select white reference surface. Click OK when done"); //Asks user to select area (white reference)
getSelectionBounds(x,y,width,height); //Sets x,y,width and height coordinates for selection
	 x_selection = x;
   	 y_selection = y;
   	 width_selection = width;
   	 height_selection = height;
close("*");

//Runs parameters on whole input folder
for (i=0; i<filename.length; i++) {
	if(endsWith(filename[i], In_ext)) {
	open(inputPath+filename[i]);
	red = filename[i]+" (red)";
	blue = filename[i]+" (blue)";
	green = filename[i]+" (green)";

	run("Split Channels");
	selectWindow(red);
		makeRectangle(x_selection, y_selection, width_selection, height_selection); //Select region of white paper
		getStatistics(area, mean);
		mean_factor_red = 255/mean; //Calculate the factor of the white area to "perfect" white of an 8-bit image
		run("Select None");
		run("Multiply...", "value=mean_factor_red"); //Multiply the channel image by the factor calculated before

		selectWindow(green);
		makeRectangle(x_selection, y_selection, width_selection, height_selection);
		getStatistics(area, mean);
		mean_factor_green = 255/mean; 
		run("Select None");
		run("Multiply...", "value=mean_factor_green");

		selectWindow(blue);
		makeRectangle(x_selection, y_selection, width_selection, height_selection); 
		getStatistics(area, mean);
		mean_factor_blue = 255/mean;
		run("Select None");
		run("Multiply...", "value=mean_factor_blue");

	run("Merge Channels...", "red=["+red+"] green=["+green+"] blue=["+blue+"]"); //Merge separate RGB channels into one image
	
	name = File.nameWithoutExtension;
	saveAs(Out_ext, outputPath+name+"_whitebalance");
	close("*");
		setBatchMode(false);
	}
}
}
