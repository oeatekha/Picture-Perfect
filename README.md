# Picture-Perfect
2.086 Picture Perfect. Low-level GUI photo editing application made in MATLAB.

<img src="https://github.com/oeatekha/Picture-Perfect/blob/main/UI%20GLOW.png" width="800"/>

Picture-Perfect is a MATLAB and tool that allows you to use a GUI interface to explore different methods of image manipulation and filters.
Picture Perfect was made by Mike Burgess, Kevin Lu, Adrian Garza, and Omoruyi Atekha Spring 2020. 


## Setup

* Clone the repository

* Install
```
Install all files
```
* For MATLAB run PicturePerfectPhotoPhilter.m
```
Drop image into GUI
```

This will allow you to manipulate an image's luminocity, RGB, and various other features. 


## Future Work
Clean Up Source Code:
* Additional Features
  * Additional algorithms - Faster image sampling.
  * Add aditional Filters
  * Add Resizing abilities

 

# Image Sliders
Red, green, and blue were developed to tweak the hue of an image. 

![](https://github.com/oeatekha/Picture-Perfect/blob/main/UIMAGESLIDER%20(1).png)

## Glow
The glow filter aims to high light the edges in the image, where there is a drastic change in the color. Those regions of change are amplified while all the 
other areas are turned to black. This effect is achieved with the use of kernels, a 2 dimensional matrix. In this case the kernel is a 3x3 matrix which gets 
applied so that each pixel of the image is multiplied by the center of the kernel. The values of that center pixel and its neighbors after being multiplied by 
the kernel are summed to give the weighted value for the center pixel. For this filter, the matrix was designed to highlight edges with a slope of 1. 

![](https://github.com/oeatekha/Picture-Perfect/blob/main/UI%20GLOW.pngg)

## FRY
The fry filter is not built to be very visually appealing. Referencing a popular internet meme style, the filter takes an image and essentially ruins all quality the 
image may have, creating a hilarious result. It first sharpens the image and enhances edges by applying a kernel filter across the image matrix. After this, the image 
is oversaturated by converting the matrix to HSV storage (instead of standard RGB) and scaling up all S (saturation) values by a factor of 75%. Then, the image quality
is reduced by making it’s total size ⅔ of the original size of the user-given image. Once the quality has been factored down, the image is sharpened again the same as 
it was before. Each of these rounds works to make the image look significantly worse. At the end, the picture looks like a low-quality mosaic of saturated colors. 
The clunkiness makes the image seem as if it was placed in a fryer with hot oil for a good 10-15 minutes.

![](https://github.com/oeatekha/Picture-Perfect/blob/main/UIMAGESLIDER%20(2).png)


### Painted
The second filter is designed to convert any image into a simpler version of itself such that it looks like it may have been painted by a cartoon artist. The filter acts 
to group colors of the image. Typically, a picture has a bunch of very detailed colors. The painted filter groups patches of different colors into a single color, allowing
the image to look much less complex. This effect is made by dividing all of the image’s pixels’ integer RGB values by a constant number, which creates a small float number 
that is rounded to the closest integer. This number is then multiplied by a constant number to scale it upwards. Effectively, by dividing and rounding pixel values, the number
of colors in the picture has been greatly reduced. This creates desired patches of simple colors. 

### Other Features: Black and White, Classic, Color Inversion, Hue Inversion, Emboss, Bi-Polar etc.

<div>

<img src="https://github.com/oeatekha/Picture-Perfect/blob/main/HUEINV.png" width="460">
HUE INVERSION

<img src="https://github.com/oeatekha/Picture-Perfect/blob/main/UI.png" width="460">
CLASSIC 
</div>

# Aditional Descriptions

## Bi-Polar

The bipolar filter attempts to create a high contrast representation of the image. The filter begins with creating a black white version of the image to have a less diverse amount of color representations. After the image is put in a greyscale form a high threshold value of 200 is set. The black and white intensity is then reset. If it is higher than the threshold the pixel color is then set to white or if lower the pixel color is set to black.

## Emboss

The emboss filter makes the image look like it was pressed onto a piece of paper. It first uses the black and white filter. Then a kernel is applied to the image that defines the edges and makes everything else more monotone. This kernel weighs edges with a slope of 1 the most, undefines and slopes of 0 second, and slopes of -1 the least.

## Hue Inversion

Within color theory, it is known that every color has an opposite color, formally known as a complementary color. On the color circle, complementary hues oppositely face one another and  because of this when combined, the hues cancel out. This filter’s goal is to invert the colors of an image. This was done by taking the RGB values of an image and extracting the hue of each pixel. Following this the opposite H is calculated. When RGB values are placed on an Hue scale, we convert the RGB values to Hue Saturation Values (HSV). On the Hue scale colors are represented in a 360 degrees format so the current hue gets 180 degrees added to flip its position then modulus of 360 degrees is done to normalize the value. Altogether resulting in a color inverted image.


