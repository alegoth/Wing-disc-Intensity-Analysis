%% This script simply read a .tif file and return the file as "ori".
%the script can read 4D stacks. It also reads the pixel size of the image.
function [ori,name,sizepixel]=readfilessimple_clean(namefile,numchannel)

[~,name,~] = fileparts(namefile);

info = imfinfo(namefile);
sizepixel=1/info(1).XResolution; %Read the pixel size here.
num_images = numel(info);
ori=zeros(info(1).Height,info(1).Width,numchannel,num_images/numchannel);
n=0;
for k = 1:numchannel:num_images
    n=n+1;
    m=0;
    for l=1:numchannel
        m=k+l-1;
        ori(:,:,l,n) = imread(namefile, m, 'Info', info);
        
    end
end

ori=mat2gray(ori,[0 255]);

end