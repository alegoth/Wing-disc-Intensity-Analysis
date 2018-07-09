# Wing-disc-Intensity-Analysis
This script measures the intensity of two channels of a confocal microscope image. All the value are relative. The aim is to be able to average several disc based on the position of the AP and DV compartment boundary. Each image is 'coarse grain' and the signal intensity is average in each cuboid. A reference channel is used to keep only the pixels of interest (e.g the membrane). The intensity is measured for both channel, each pixel is normalized to the mean intensity of that channel. The channel of interest is then normalized to the channel of interest.
The code runs on Matlab, it has been last edited on Matlab R2017b.
To start using it, open intmap_3D simple2.m in Matlab. Be sure to add the other scripts to the path.
