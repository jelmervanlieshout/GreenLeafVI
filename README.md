# Green-red-ratio
Repository for the FIJI GreenLeafVI plugin which aims to extract RGB data from imaged plant tissue to estimate the chlorophyll content using different vegetation indices.

## Installation of GreenLeafVI
1. Before the installation of GreenLeafVI, the installation of FIJI is required. FIJI can be downloaded from https://fiji.sc/.
2. To install GreenLeafVI, open FIJI, navigate to **Help --> Update** and select **Manage Update Sites**. From here, navigate to GreenLeafVI and set as **Active**. Click **Apply and Close** and close the ImageJ Updater. Restart FIJI and you can find the plugin under **Plugins --> GreenLeafVI**.

If GreenLeafVI cannot be found in the **Manage Update Sites** menu, click **Add Unlisted Site**, type GreenLeafVI under **Name** and type **https://sites.imagej.net/GreenLeafVI/**. Click **Apply and Close** and restart FIJI. The plugin should be under **Plugins --> GreenLeafVI**.

## Usage
RGB vegetation indices have been used in many species. Our plugin has been tested in leaf tissue of *Arabidopsis thaliana* (Arabidopsis), *Nicothiana benthamiana* (Tobacco), *Solanum lycopersicum* (Tomato) and *Lactuca sativa* (Lettuce). Normalized red was the best predictor of chlorophyll content in all species, apart from lettuce, where Green:Red ratio performed the best. For other species, we recommend to test the available vegetation indices with classical chlorophyll extraction methods to identify the best method.

### Whitebalancing
Images may suffer from inconsistent lighting, especially when taken at different points of time. Whitebalancing is an image transformation method that can help make different images more comparable to each other. We provide a script in which the user selects a white reference surface and its RGB value is compared to perfect RGB white (#255,#255,#255). The ratio of the selected surface RGB and perfect white RGB values is used to transform the red, green and blue channel separately, followed by merging of each channel to end with a more balanced image. Currently the script provides two whitebalancing options;

1. **Per image:** This option requires users to select white reference surface for each image individually.
2. **Batch:** This asks the user to open a reference image and select the area to use as white balancing reference. The same area will be considered the reference area in each image. Make sure that this area is the same in each image.

### Segmentation

### Vegetation index extraction

## Citation
