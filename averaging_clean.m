%This script find the results located in the "Results" folder and average
%the individual heatmaps. As they're not necessarily of the same size, a
%bigger matrix is created than each individual heatmap. The heatmaps are
%recentered and all stacked together, creating a xyz matrix. As some
%heatmaps may be bigger than other, for a given xy position the number of
%non zero values in the z dimension may be different. So you choose the
%minimal number of non zero values you want to average. Obviously you don't
%want to include the zeros in the average, so they're replaced by NaN.
function [finalgrid,sdgrid,refim]=averaging_clean(gridtype,sizesquare,meanthresh)

files = dir('Results');
filesname={files.name};
pattern=[gridtype,'-',num2str(sizesquare)];
fileIndex=find(contains(filesname,pattern));

for i = 1:length(fileIndex)
    fileName = files(fileIndex(i)).name;
    loadname=['Results/',fileName];
    S(i)=load(loadname);
    sizegrid(i,:)=size(S(i).(gridtype));
end

dimgrid=max(sizegrid);
refim=zeros(dimgrid(1),dimgrid(2),length(fileIndex));
center=dimgrid/2;
for i = 1:length(fileIndex)
    first=S(i).(gridtype);
    first(isnan(first)) = 0 ;
    first(isinf(first)) = 0 ;
    centerfirst=size(first)/2;
    trans=round(center-centerfirst);
    centfirst=imtranslate(first,fliplr(trans),'FillValues',0,'OutputView','full');
    [m,n,d]=size(refim);
    centfirst(m,n)=0;
    refim(:,:,i)=refim(:,:,i)+centfirst;
end

refim(refim==0)=NaN;
%create a SDgrid and remove the average of less than a certain number of
%value...
for e=1:size(refim,1)
    for ee=1:size(refim,2)
        nbvalue(e,ee)=sum(~isnan(refim(e,ee,:)));
    end
end
finalgrid=nanmean(refim,3);
sdgrid=nanstd(refim,[],3);
finalgrid(nbvalue<meanthresh)=NaN;
sdgrid(nbvalue<meanthresh)=NaN;
    
end