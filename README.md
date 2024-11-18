# Green-red-ratio
Repository for the FIJI GreenLeafVI plugin which aims to extract RGB data from imaged plant tissue to estimate the chlorophyll content using different vegetation indices.

## Installation of GreenLeafVI
1. Before the installation of GreenLeafVI, the installation of FIJI is required. FIJI can be downloaded from https://fiji.sc/.
2. To install GreenLeafVI, open FIJI, navigate to **Help --> Update** and select **Manage Update Sites**. From here, navigate to GreenLeafVI and set as **Active**. Click **Apply and Close** and close the ImageJ Updater. Restart FIJI and you can find the plugin under **Plugins --> GreenLeafVI**.

If GreenLeafVI cannot be found in the **Manage Update Sites** menu, click **Add Unlisted Site**, type GreenLeafVI under **Name** and type **https://sites.imagej.net/GreenLeafVI/**. Click **Apply and Close** and restart FIJI. The plugin should be under **Plugins --> GreenLeafVI**.

## Usage
RGB vegetation indices have been used in many species. Our plugin has been tested in leaf tissue of *Arabidopsis thaliana* (Arabidopsis), *Nicothiana benthamiana* (Tobacco), *Solanum lycopersicum* (Tomato) and *Lactuca sativa* (Lettuce). Normalized red was the best predictor of chlorophyll content in all species, apart from lettuce, where Green:Red ratio performed the best. For other species, we recommend to test the available vegetation indices with classical chlorophyll extraction methods to identify the best method.

### Image acquisition

### Whitebalancing
Images may suffer from inconsistent lighting, especially when taken at different points of time. Whitebalancing is an image transformation method that can help make different images more comparable to each other. We provide a script in which the user selects a white reference surface and its RGB value is compared to perfect RGB white (#255,#255,#255). The ratio of the selected surface RGB and perfect white RGB values is used to transform the red, green and blue channel separately, followed by merging of each channel to end with a more balanced image.

#### Step-by-step whitebalancing
1. **Input files directory**: Select the directory with images you want to whitebalance.
2. **Output files directory**: Select the directory you want to save your images in.
3. **Input file extension**: Select the file extension of your input images (This is case-sensitive).
4. **Output file extension**: Select the file extension of your output images (This is case-sensitive).
5. **Mode**: Either; **Single** for per image whitebalancing, or **Batch** for whitebalancing of the whole input directory.

**Single:** The script will open each image individually and requires users to **select** a white reference area using the rectangle tool and **click** *ok*. Repeat this for each subsequent image.

**Batch:** The script will ask to open a reference image. **Select** a white reference area using the rectangle tool and **click** *ok*. The same area location will be used as reference for each image in the input directory.

### Segmentation
To accurately measure the mean RGB values for the desired objects, it is recommended to remove the background of each image. The segmentation script creates a duplicate image and uses the FIJI **Image --> Adjust --> Color threshold** function to select desired objects based on minimum and maximum HSB (Hue, saturation and brightness) values. A mask is created and the selection is overlayed on the original image, followed by background removal.

####Step-by-step segmentation
1. **Input files directory**: Select the directory with images you want to whitebalance.
2. **Output files directory**: Select the directory you want to save your images in.
3. **Input file extension**: Select the file extension of your input images (This is case-sensitive).
4. **Output file extension**: Select the file extension of your output images (This is case-sensitive).
5. **Minimum object area**: Define the minimum size of your object in pixels.
6. **HSB values**: Provides two options; **New** requires users to fill in their own HSB values (Hue minimum, Hue maximum, Saturation minimum, Saturation maximum, Brightness minimum, Brightness maximum) *or* **Import** which asks users to import a *.csv* table with pre-defined HSB minima and maxima.
7. **Save**: Saves the used HSB values as a table in *.csv* format in the input directory (only when the option **New** was used).

### Vegetation index extraction

## Citation
