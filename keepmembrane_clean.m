%This script create a mask of the reference channel using the adaptthresh
%function and apply that mask to both the reference channel and the channel
%of interest. In summary we get rid of the unwanted signal.
%Input : ori = the original stack. 
%Output :  normclean = Channel used to normalize after removing the
%          unwanted pixels.
%          oriclean = Channel of interest after removing the unwanted
%          pixels
function [normclean,oriclean]=keepmembrane_clean(ori,ctonormalize,ctoassess)

n=size(ori,4);
cecad=squeeze(ori(:,:,ctonormalize,:));
cjub=squeeze(ori(:,:,ctoassess,:));

maxcad=max(cecad,[],3);
T=adaptthresh(maxcad,0.5);

for i=1:n
    threshslice=imbinarize(cecad(:,:,i),T);
    threshcad(:,:,i)=threshslice;
end

normclean=threshcad.*cecad;
oriclean=threshcad.*cjub;

end