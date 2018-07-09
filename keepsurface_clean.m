%This script create a mask of the reference channel using the adaptthresh
%function and apply that mask to both the reference channel and the channel
%of interest. In summary we get rid of the unwanted signal. This version
%also tries to recognize a surface of interest. Initially it was created to
%get rid of the peripodial membrane of drosophila wing imaginal disc.
%The principle is to "cut" the stack into cuboid and measure the intensity
%of each slice and keep the slice of the highest intensity. A median filter
%is finally applied.

function [normclean,oriclean,maskpost]=keepsurface_clean(ori,ctonormalize,ctoassess,shift,stack)

cecad=squeeze(ori(:,:,channel,:));
s=size(cecad);
stepy=round(s(1)/128); %You can change the size of the square here (y dimension)
stepx=round(s(2)/128); %and here (x dimension)
new=zeros(s(1:2));
new2=zeros(s(1:2));
for i=1:stepx:s(2)
    xmin=i;
    xmax=stepx+1+i;
    if xmax>s(2)
        xmax=s(2);
    end
    for ii=1:stepy:s(1)
        ymin=ii;
        ymax=stepy+1+ii;
        if ymax>s(1)
            ymax=s(1);
        end
        part=cecad(ymin:ymax,xmin:xmax,:);
        [~,pos]=max(sum(sum(part,2),1),[],3);
        new(ymin:ymax,xmin:xmax)=pos;
    end
end
%create a second grid shifted by -1/2 the size of the previous square size
for i=1:stepx:(s(2)+ceil(stepx/2))
    xmin=round(i-stepx/2);
    xmax=round((stepx+1+i)-stepx/2);
    if xmax>s(2)
        xmax=s(2);
    end
    if xmin<1
        xmin=1;
    end
    for ii=1:stepy:(s(1)+ceil(stepx/2))
        ymin=round(ii-stepy/2);
        ymax=round((stepy+1+ii)-stepy/2);
        if ymax>s(1)
            ymax=s(1);
        end
        if ymin<1
            ymin=1;
        end
        part=cecad(ymin:ymax,xmin:xmax,:);
        [~,pos]=max(sum(sum(part,2),1),[],3);
        new2(ymin:ymax,xmin:xmax)=pos;
    end
end
%create a third grid shifted by -1/4 the size of the previous square size
for i=1:stepx:(s(2)+ceil(stepx/4))
    xmin=round(i-stepx/4);
    xmax=round((stepx+1+i)-stepx/4);
    if xmax>s(2)
        xmax=s(2);
    end
    if xmin<1
        xmin=1;
    end
    for ii=1:stepy:(s(1)+ceil(stepx/4))
        ymin=round(ii-stepy/4);
        ymax=round((stepy+1+ii)-stepy/4);
        if ymax>s(1)
            ymax=s(1);
        end
        if ymin<1
            ymin=1;
        end
        part=cecad(ymin:ymax,xmin:xmax,:);
        [~,pos]=max(sum(sum(part,2),1),[],3);
        new3(ymin:ymax,xmin:xmax)=pos;
    end
end
%create a third grid shifted by -3/4 the size of the previous square size
for i=1:stepx:(s(2)+ceil(3*stepx/4))
    xmin=round(i-3*stepx/4);
    xmax=round((stepx+1+i)-3*stepx/4);
    if xmax>s(2)
        xmax=s(2);
    end
    if xmin<1
        xmin=1;
    end
    for ii=1:stepy:(s(1)+ceil(3*stepx/4))
        ymin=round(ii-3*stepy/4);
        ymax=round((stepy+1+ii)-3*stepy/4);
        if ymax>s(1)
            ymax=s(1);
        end
        if ymin<1
            ymin=1;
        end
        part=cecad(ymin:ymax,xmin:xmax,:);
        [~,pos]=max(sum(sum(part,2),1),[],3);
        new4(ymin:ymax,xmin:xmax)=pos;
    end
end

newnew=cat(3,new,new2,new3,new4);
finalsurf=max(newnew,[],3);
resized=imresize(finalsurf,0.1); %Reduced the image 10 times to make next step faster
res=medfilt2(resized,[3 3]); %Apply a median filter on the surface
finalsurf=round(imresize(res,size(finalsurf))); %Resize to original

n=size(ori,4);
shmaxmap=finalsurf+shift;
shmaxmap(shmaxmap>size(ori,4))=size(ori,4);
shmaxmap(shmaxmap<1)=1;
maxmap3=repmat(shmaxmap,1,1,size(ori,4));
maxmap3=round(maxmap3);
mask=zeros(size(maxmap3,1),size(maxmap3,2),n);
for i=1:n
    z=maxmap3(:,:,i);
    mask(:,:,i)= z>=i-(stack-1) & z<=i;
end

cecad=squeeze(ori(:,:,ctonormalize,:)).*mask;
cjub=squeeze(ori(:,:,ctoassess,:)).*mask;
maxcad=max(cecad,[],3);

T=adaptthresh(maxcad,0.5);
for i=1:n
    threshslice=imbinarize(cecad(:,:,i),T);
    threshcad(:,:,i)=threshslice;
end
normclean=threshcad.*cecad;
oriclean=threshcad.*cjub;



end