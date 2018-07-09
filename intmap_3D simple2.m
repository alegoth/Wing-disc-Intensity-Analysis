%% Name of the file and parameters
path = dir('*.tif');  %Find the .tif in the current folder
namefile = '180312_rescue_1F1-RokCAT-JubGFP-V5-Ecad-25 - Series002.tif';
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Enter the parameters here                                              %
numchannel=4; %Number of channel in the image                            %
ctonormalize=2; %Channel used to normalize                               %
ctoassess=3;% Channel that you want to calculate the intensity of        %
shift=-1; %If you need to detect the surface you may want to shift it down or up to better adjust to your signal                                                                %
stack=2;  %Number of slices that are kept abve the detected (and shifted) surface. Must be at least 1.                                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load the image

[ori,name,sizepixel]=readfilessimple_clean(namefile,numchannel);

%% Clean the image to keep only the pixels of interest. For example: the membrane
% 2 versions of this script are available. Comment the one you don't need.
% The first one uses the whole image. The second one uses the surface
% generated by "createsurface" to get rid of most of the peripodial cell.

%     [normclean,oriclean]=keepmembrane_clean(ori,ctonormalize,ctoassess);
[normclean,oriclean,maskpost]=keepsurface_clean(ori,ctonormalize,ctoassess,chanpost,finalsurf,shift,stack);
%% recenter the image
maxproj=cat(3,max(normclean,[],3),max(squeeze(ori(:,:,chanpost,:)),[],3),max(oriclean,[],3));
[normcent,oricent,trans,maskpostcent]=recenterimage(maxproj,normclean,oriclean,maskpost);
%% Coarse grain
sizequare=5; %size given in micrometer
gridsize=round(sizequare/sizepixel);
[overmean,gridsum,overnorm,generalnorm,projori,projnorm]=coarsegrainintensity_v3Dsimple_clean(gridsize,oricent,normcent);
[ratiohalf,ratiocontr,rationorm]=ratiohalfdisc_clean(oricent,normcent);
%% Visualization
figure('Name',name,'NumberTitle','off')
imshow(generalnorm,[],'Colormap',jet,'InitialMagnification','fit'); %You can change the style of the colorbar here (current "jet")
title('Normalized intensity')
colorbar
caxis([0 2.5]); % You can change the values here to adjust the colorbar

%% Save the results
%The results are saved in a folder named "Results". "overmean" is a
%heatmap of the reference channel normalized over its mean intensity.
%"generalnorm" is a heatmap of the reference channel divided by the
%normalize channel.
%"ratiohalf" is the ratio beween the intensity of the right side of
%your image, divided by the left side (posterior to anterior ratio).
%"rationorm" is the same as before divided by the ratio of the
%reference channel.
if ~exist('Results','dir')
    mkdir('Results');
end
if ~exist('Resulttable','var')
    Resulttable=table(cellstr(name),ratiohalf,rationorm,'VariableNames',{'Name','RatioPA','RatioNormalized'});
else
    Resulttable2=table(cellstr(name),ratiohalf,rationorm,'VariableNames',{'Name','RatioPA','RatioNormalized'});
    Resulttable(end+1,:)=Resulttable2;
end
savedirmeangrid=['Results\',name,'-','overmean','-',num2str(sizequare)];
save(savedirmeangrid,'overmean');
savediraveragegrid=['Results\',name,'-','generalnorm','-',num2str(sizequare)];
save(savediraveragegrid,'generalnorm');
savedirratio=['Results\',name,'-','ratiohalf'];
save(savedirratio,'ratiohalf');
savedirratio=['Results\',name,'-','rationorm'];
save(savedirratio,'rationorm');
disp('saved')

%% Save the table
writetable(Resulttable,'Result-wo-peri.xlsx') %Save the table of the "ratiohalf" and "rationorm"
%% Average all the maps in the folder
meanthresh=5; %Minimum number of values present in a square to average.
[finalgrid,sdgrid,refim]=averaging_clean('generalnorm',5,meanthresh);
figure('Name','general averaging','NumberTitle','off')
imshow(finalgrid,[],'Colormap',jet,'InitialMagnification','fit');
colorbar
caxis([0.6 1.6]);
