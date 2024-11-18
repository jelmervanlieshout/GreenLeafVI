//Dialog selection menu
Dialog.create("Add HSB values to segmentate image");
Dialog.addMessage("Image information", 15, "black");
Dialog.addDirectory("Input files directory", "");
Dialog.addDirectory("Output files directory", "");
Dialog.addString("Input file extension", "jpg");
Dialog.addString("Output file extension", "jpg");
Dialog.addMessage("Minimum object pixel size", 15, "black");
Dialog.addNumber("Minimum object area:", 50000);
Dialog.addMessage("Choose new HSB values or import saved HSB values",15,"black");
Dialog.addChoice("HSB_values", newArray("New", "Import"));
Dialog.addMessage("Enter new HSB values (Only when not importing values)", 15, "black");
Dialog.addNumber("Hue minimum:", 0);
Dialog.addToSameRow();
Dialog.addNumber("Hue maximum:", 103);
Dialog.addNumber("Saturation minimum:", 40);
Dialog.addToSameRow();
Dialog.addNumber("Saturation maximum:", 255);
Dialog.addNumber("Brightness minimum:", 107);
Dialog.addToSameRow();
Dialog.addNumber("Brightness maximum:", 255);
Dialog.addMessage("Save new HSB values to input directory", 15, "black");
Dialog.addChoice("Save", newArray("No", "Yes"));
Dialog.show();

inputPath = Dialog.getString(); //User defined input directory
outputPath = Dialog.getString(); //User defined output directory
In_ext = Dialog.getString(); //User defined input file extension
Out_ext = Dialog.getString(); //User defined output file extension
area = Dialog.getNumber(); //User defined minimal object area
Mode = Dialog.getChoice(); //Import previous HSB values or define new ones
Hue_min = Dialog.getNumber();
Hue_max = Dialog.getNumber();
Sat_min = Dialog.getNumber();
Sat_max = Dialog.getNumber();
Bri_min = Dialog.getNumber();
Bri_max = Dialog.getNumber();
Optional_save = Dialog.getChoice(); //Option to save HSB values to a csv file in input directory

filename = getFileList(inputPath);

//Option if user imports a .csv file with HSB input values
if (Mode == "Import") {
	waitForUser("Open HSB table");
	open("");
	Hue_min = Table.get("Hue", 0);
	Hue_max = Table.get("Hue", 1);
	Sat_min = Table.get("Saturation", 0);
	Sat_max = Table.get("Saturation", 1);
	Bri_min = Table.get("Brightness", 0);
	Bri_max = Table.get("Brightness", 1);
	selectWindow("HSB_parameters.csv");
	run("Close");
//Open image, duplicate image and perform thresholding on duplicate	
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
		
		//Save image files to output directory
		name = File.nameWithoutExtension;
		new_name = replace(name, "_whitebalance", "");
		saveAs(Out_ext, outputPath+new_name+"_segmented");
		close("*");
		}
	}

}

//Option if the user defines new HSB values
else {  
//Open image, duplicate image and perform thresholding on duplicate		
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
		
		//Save segmented images to the output directory
		name = File.nameWithoutExtension;
		new_name = replace(name, "_whitebalance", "");
		saveAs(Out_ext, outputPath+new_name+"_segmented");
		close("*");
		}
	}
	//Option if the user wants to save the used HSB values to a csv file
	if (Optional_save == "Yes") {
		Hue_values = newArray(Hue_min, Hue_max);
		Sat_values = newArray(Sat_min, Sat_max);
		Bri_values = newArray(Bri_min, Bri_max);
		
		//Create new table using the min and max HSB values and save to csv
		table1 = "HSB_values";
		Table.create(table1);
		Table.setColumn("Hue", Hue_values);
		Table.setColumn("Saturation", Sat_values);
		Table.setColumn("Brightness", Bri_values);
		Table.save(inputPath + "HSB_parameters.csv");
		selectWindow(table1);
		run("Close");
	}
}

setBatchMode(true); 
list = getFileList(inputPath);
for (i = 0; i < list.length; i++)
        action(inputPath, outputPath, list[i]);
setBatchMode(false);
