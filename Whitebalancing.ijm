//Dialog box for user settings
Dialog.create("Run whitebalance macro in single or batch mode");
Dialog.addMessage("Image information", 15, "black");
Dialog.addDirectory("Input files directory", "");
Dialog.addDirectory("Output files directory", "");
Dialog.addString("Input file extension", "jpg");
Dialog.addString("Input file extension", "jpg");
Dialog.addMessage("Per image or batch whitebalancing mode", 15, "black");
Dialog.addChoice("Mode", newArray("Single", "Batch"));
Dialog.show();
inputPath = Dialog.getString() //User defined input directory
outputPath = Dialog.getString() //User defined output directory
In_ext = Dialog.getString(); //User defined input image file extension
Out_ext = Dialog.getString(); //User defined output image file extension
Mode = Dialog.getChoice(); //Mode of whitebalancing (single or batch mode)

filename = getFileList(inputPath);

//Run single mode where you define the reference surface per image to whitebalance to
if (Mode == "Single") {
	for (i=0; i<filename.length; i++) {
		if(endsWith(filename[i], In_ext)) {
			open(inputPath+filename[i]);
			red = filename[i]+" (red)";
			blue = filename[i]+" (blue)";
			green = filename[i]+" (green)";
		
			setTool("rectangle"); //Set the rectangle selection tool
			waitForUser("Select white reference surface. Click OK when done"); //Asks user to select reference region
			getSelectionBounds(x,y,width,height); //Sets x,y,width and height coordinates for selection
		    x_selection = x;
	   	 	y_selection = y;
	   	 	width_selection = width;
	   	 	height_selection = height;
			
			setBatchMode(true);
			run("Split Channels"); //Split the image in the separate RGB channels
			
			selectWindow(red); //Select red channel
			makeRectangle(x_selection, y_selection, width_selection, height_selection); //Select reference region
			getStatistics(area, mean);
			mean_factor_red = 255/mean; //Calculate the factor of the white area to "perfect" white of an 8-bit image
			run("Select None");
			run("Multiply...", "value=mean_factor_red"); //Multiply the channel image by the factor calculated before
	
			selectWindow(green); //Select green channel
			makeRectangle(x_selection, y_selection, width_selection, height_selection);
			getStatistics(area, mean);
			mean_factor_green = 255/mean; 
			run("Select None");
			run("Multiply...", "value=mean_factor_green");
	
			selectWindow(blue); //Select blue channel
			makeRectangle(x_selection, y_selection, width_selection, height_selection); 
			getStatistics(area, mean);
			mean_factor_blue = 255/mean;
			run("Select None");
			run("Multiply...", "value=mean_factor_blue");
		
			run("Merge Channels...", "red=["+red+"] green=["+green+"] blue=["+blue+"]"); //Merge the separate balanced RGB channels into one image
			name = File.nameWithoutExtension;
			saveAs(Out_ext, outputPath+name+"_whitebalance");
			close("*");
			setBatchMode(false);
		}
	}
} 

//Runs batch mode (Possible if the reference area is in the same location for all images)
else {
//Ask user to open an image to select a reference area to
	waitForUser("Open a reference image");
	open("");
	setTool("rectangle"); //Set the rectangle selection tool
	waitForUser("Select white reference surface. Click OK when done"); //Asks user to select reference region
	getSelectionBounds(x,y,width,height); //Sets x,y,width and height coordinates for selection
	 x_selection = x;
   	 y_selection = y;
   	 width_selection = width;
   	 height_selection = height;
	close("*");

	//Runs parameters on whole input folder
	for (i=0; i<filename.length; i++) {
		setBatchMode(true);
		if(endsWith(filename[i], In_ext)) {
			open(inputPath+filename[i]);
			red = filename[i]+" (red)";
			blue = filename[i]+" (blue)";
			green = filename[i]+" (green)";
		
			run("Split Channels"); //Split the image in the separate RGB channels
			
			selectWindow(red);
			makeRectangle(x_selection, y_selection, width_selection, height_selection); //Select reference region
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
			
			run("Merge Channels...", "red=["+red+"] green=["+green+"] blue=["+blue+"]"); //Merge the separate balanced RGB channels into one image
			name = File.nameWithoutExtension;
			saveAs(Out_ext, outputPath+name+"_whitebalance");
			close("*");
		}
	setBatchMode(false);
	}
}
