inputPath = getDirectory("Choose input folder");

filename = getFileList(inputPath);

outputPath = getDirectory("Choose output folder");


for (i=0; i<filename.length; i++) {
	if(endsWith(filename[i], ".JPG")) {
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

	saveAs(".jpeg", outputPath+filename[i]);
	close("*");
		setBatchMode(false);
	}
}