## Project: Search and Sample Return
#### Submitted by Laura Eberhard
---


**The goals / steps of this project are the following:**  

**Training / Calibration**  

* Download the simulator and take data in "Training Mode"
* Test out the functions in the Jupyter Notebook provided
* Add functions to detect obstacles and samples of interest (golden rocks)
* Fill in the `process_image()` function with the appropriate image processing steps (perspective transform, color threshold etc.) to get from raw images to a map.  The `output_image` you create in this step should demonstrate that your mapping pipeline works.
* Use `moviepy` to process the images in your saved dataset with the `process_image()` function.  Include the video you produce as part of your submission.

**Autonomous Navigation / Mapping**

* Fill in the `perception_step()` function within the `perception.py` script with the appropriate image processing functions to create a map and update `Rover()` data (similar to what you did with `process_image()` in the notebook). 
* Fill in the `decision_step()` function within the `decision.py` script with conditional statements that take into consideration the outputs of the `perception_step()` in deciding how to issue throttle, brake and steering commands. 
* Iterate on your perception and decision function until your rover does a reasonable (need to define metric) job of navigating and mapping.  


## [Rubric](https://review.udacity.com/#!/rubrics/916/view) Points

---
### Writeup / README

#### 1. Provide a Writeup / README that includes all the rubric points and how you addressed each one.  You can submit your writeup as markdown or pdf.  

This file will cover the ruberic criteria and how item was addressed. 

---
### Notebook Analysis
#### 1. Run the functions provided in the notebook on test images (first with the test data provided, next on data you have recorded). Add/modify functions to allow for color selection of obstacles and rock samples.

Initially the functions were researched in a class notes Jupyter notebook on my local machine (while working through the lessons). Halfway through the project timeframe, the Rover_Project_Test_Notebook code was migrated to this forked project in github. At the time of the file migration, the notebook was adding terrain, obstacles and rock sample colors. The colors were stuck at the starting coordinates of the video. The following notes cover the work now recorded in the forked project commits.

Keeping the default sample code from the test notebook and lesson examples produced a video where the terrain would be updated in the starting point of the rover.

##### 1.1 Color Threshold Obstacle and Rock Sample Detection
At the start, the function color_thresh() only masked pixels above a specified threshold. This worked for collecting navigable terrain, but not for obstacle or rock sample detection. The following changes were made to the default cell in the Rover_Project_Test_Notebook file:

The color_thresh function was updated to support an RGB range instead of checking above a given threshold. The function was verified with the original warped test image and then the thresholds were tested with unwarped images.
![rock_image]: (../calibration_images/example_rock1.jpg)
![terrain_thresh_image]: (./output/terrain_threshed.jpg)
![obstacle_thresh_image]: (./output/obstacle_threshed.jpg)
![rock_thresh_image]: (./output/rock_sample_threshed.jpg)

The default range for the lower colors was missing sections of the images, so the threshold check was updated to include the specified values in the mask. This significantly improved the obstacle and sample rock detection, and slightly improved the terrain. The function was modified instead of the threshold values in order to avoid changing parameters throughout the project.
![terrain_thresh_image1]: (./output/terrain_threshed1.jpg)
![obstacle_thresh_image1]: (./output/obstacle_threshed1.jpg)
![rock_thresh_image1]: (./output/rock_sample_threshed1.jpg)

#### 2. Populate the `process_image()` function with the appropriate analysis steps to map pixels identifying navigable terrain, obstacles and rock samples into a worldmap.  Run `process_image()` on your test data using the `moviepy` functions provided to create video output of your result. 

##### 2.1 Define source and destination points for perspective transform
Working with the default values given in the Map to World Coordinates lesson. 
```python
bottom_offset = 6
source = np.float32([[14, 140], [301 ,140],[200, 96], [118, 96]])
destination = np.float32([[image.shape[1]/2 - dst_size, image.shape[0] - bottom_offset],
                  [image.shape[1]/2 + dst_size, image.shape[0] - bottom_offset],
                  [image.shape[1]/2 + dst_size, image.shape[0] - 2*dst_size - bottom_offset], 
                  [image.shape[1]/2 - dst_size, image.shape[0] - 2*dst_size - bottom_offset],
                  ])
```

##### 2.2 Apply perspective transform
Used the function calls provided in the Coordinate Transformations cell.
```python
    warped = perspect_transform(image, source, destination)   
```

##### 2.3 Apply color threshold to identify navigable terrain/obstacles/rock samples
Started out with the function call provided in the Coordinate Transformations cell to track the terrain.
```python
    threshed = color_thresh(warped)
```

##### 2.4 Convert thresholded image pixel values to rover-centric coords
Started out with the function call provided in the Coordinate Transformations cell to track the terrain.
```python
    xpix, ypix = rover_coords(threshed)
```

##### 2.5 Convert rover-centric pixel values to world coords
Started out with the function call provided in the Map to World Coordinates lesson to track the terrain.
```python
    scale = 10
    navigable_x_world, navigable_y_world = pix_to_world(xpix, ypix, 
        data.xpos[data.count], data.ypos[data.count],
        data.yaw[data.count], data.worldmap.shape[0], scale)

```

##### 2.6 Update worldmap (to be displayed on right side of screen)
Uncommented the line that updates the navigable terrain.
```python
    data.worldmap[navigable_y_world, navigable_x_world, 2] += 1
```

---
### Autonomous Navigation and Mapping

#### 1. Fill in the `perception_step()` (at the bottom of the `perception.py` script) and `decision_step()` (in `decision.py`) functions in the autonomous mapping scripts and an explanation is provided in the writeup of how and why these functions were modified as they were.


#### 2. Launching in autonomous mode your rover can navigate and map autonomously.  Explain your results and how you might improve them in your writeup.  

**Note: running the simulator with different choices of resolution and graphics quality may produce different results, particularly on different machines!  Make a note of your simulator settings (resolution and graphics quality set on launch) and frames per second (FPS output to terminal by `drive_rover.py`) in your writeup when you submit the project so your reviewer can reproduce your results.**

Here I'll talk about the approach I took, what techniques I used, what worked and why, where the pipeline might fail and how I might improve it if I were going to pursue this project further.  



![alt text][image3]


