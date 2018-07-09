function [overmean,gridsum,overnorm,generalnorm,projori,projnorm]=coarsegrainintensity_v3Dsimple_clean(gridsize,oricent,normcent)

tic
%cut the stack in 4 from the center. Each substack is divided into cuboid
%of the choosen size. The average intensity of the non zero pixels is
%measured for both channels. Each value is divided by the mean intensity of
%their respective channel (the mean intensity of the whole stack).
s=size(oricent);
s=s(1:2)/2;
a1=oricent(1:floor(s(1)),1:floor(s(2)),:);
a2=oricent(floor(s(1)+1):end,1:floor(s(2)),:);
a3=oricent(1:floor(s(1)),floor(s(2)+1):end,:);
a4=oricent(floor(s(1)+1):end,floor(s(2)+1):end,:);
b1=ceil(size(a1)/gridsize);
b2=ceil(size(a2)/gridsize);
b3=ceil(size(a3)/gridsize);
b4=ceil(size(a4)/gridsize);
gridsum=zeros(b1(1)+b2(1),b1(2)+b3(2));
gridlength=zeros(b1(1)+b2(1),b1(2)+b3(2));
overmean=zeros(b1(1)+b2(1),b1(2)+b3(2));
meanint=nanmean(oricent(:));
meannorm=nanmean(normcent(:));
projori=max(oricent,[],3);
projnorm=max(normcent,[],3);


m=0;
for i=b1(2):-1:1
    m=m+1;
    n=0;
    ymin=size(a1,2)-m*gridsize;
    ymax=size(a1,2)-m*gridsize+(gridsize);
    if ymin<1
        ymin=1;
    end
    for ii=b1(1):-1:1
        n=n+1;
        xmin=size(a1,1)-n*gridsize;
        xmax=size(a1,1)-n*gridsize+(gridsize);
        
        if xmin<1
            xmin=1;
        end        
        C=oricent(xmin:xmax,ymin:ymax,:);
        projori(xmax,:)=1;
        projori(:,ymax)=1;
        projnorm(xmax,:)=1;
        projnorm(:,ymax)=1;
        
        gridsum(ii,i)=nansum(C(:));
        G=normcent(xmin:xmax,ymin:ymax,:);
        normsum(ii,i)=nansum(G(:));
        overnorm(ii,i)=gridsum(ii,i)/normsum(ii,i);
        gridlength(ii,i)=length(C(~isnan(C)));
        overmean(ii,i)=nanmean(C(:))/meanint;
        normnorm(ii,i)=nanmean(G(:))/meannorm;
        generalnorm(ii,i)=overmean(ii,i)/normnorm(ii,i);
    end
end

m=0;
for i=b2(2):-1:1
    m=m+1;
    n=0;
    ymin=size(a2,2)-m*gridsize;
    ymax=size(a2,2)-m*gridsize+(gridsize);
    if ymin<1
        ymin=1;
    end
    for ii=(b1(1)+1):(b2(1)*2)
        n=n+1;
        xmin=size(a1,1)+n*gridsize-(gridsize-1);
        xmax=size(a1,1)+n*gridsize;
        
        if xmax>size(oricent,1)
            xmax=size(oricent,1);
        end
        
        C=oricent(xmin:xmax,ymin:ymax,:);
        projori(xmax,:)=1;
        projori(:,ymax)=1;
        projnorm(xmax,:)=1;
        projnorm(:,ymax)=1;
        
        gridsum(ii,i)=nansum(C(:));
        G=normcent(xmin:xmax,ymin:ymax,:);
        normsum(ii,i)=nansum(G(:));
        overnorm(ii,i)=gridsum(ii,i)./normsum(ii,i);
        
        gridlength(ii,i)=length(C(~isnan(C)));
        overmean(ii,i)=nanmean(C(:))/meanint;
        normnorm(ii,i)=nanmean(G(:))/meannorm;
        generalnorm(ii,i)=overmean(ii,i)/normnorm(ii,i);
    end
end


m=0;
for i=(b1(2)+1):(b3(2)*2)
    m=m+1;
    n=0;
    ymin=size(a1,2)+m*gridsize-(gridsize-1);
    ymax=size(a1,2)+m*gridsize;
    if ymax>size(oricent,2)
        ymax=size(oricent,2);
    end
    for ii=b3(1):-1:1
        n=n+1;
        xmin=size(a3,1)-n*gridsize;
        xmax=size(a3,1)-n*gridsize+(gridsize);
        
        if xmin<1
            xmin=1;
        end
        
        C=oricent(xmin:xmax,ymin:ymax,:);
        projori(xmax,:)=1;
        projori(:,ymax)=1;
        projnorm(xmax,:)=1;
        projnorm(:,ymax)=1;
   
        gridsum(ii,i)=nansum(C(:));
        G=normcent(xmin:xmax,ymin:ymax,:);
        normsum(ii,i)=nansum(G(:));
        overnorm(ii,i)=gridsum(ii,i)./normsum(ii,i);
        
        gridlength(ii,i)=length(C(~isnan(C)));
        overmean(ii,i)=nanmean(C(:))/meanint;
        normnorm(ii,i)=nanmean(G(:))/meannorm;
        generalnorm(ii,i)=overmean(ii,i)/normnorm(ii,i);
    end
end


m=0;
for i=(b2(2)+1):(b4(2)*2)
    m=m+1;
    n=0;
    ymin=size(a2,2)+m*gridsize-(gridsize-1);
    ymax=size(a2,2)+m*gridsize;
    if ymax>size(oricent,2)
        ymax=size(oricent,2);
    end
    for ii=b3(1)+1:(b4(1)*2)
        n=n+1;
        xmin=size(a2,1)+n*gridsize-(gridsize-1);
        xmax=size(a2,1)+n*gridsize;
        
        if xmax>size(oricent,1)
            xmax=size(oricent,1);
        end
        
        C=oricent(xmin:xmax,ymin:ymax,:);
        projori(xmax,:)=1;
        projori(:,ymax)=1;
        projnorm(xmax,:)=1;
        projnorm(:,ymax)=1;
        
        gridsum(ii,i)=nansum(C(:));
        G=normcent(xmin:xmax,ymin:ymax,:);
        normsum(ii,i)=nansum(G(:));
        overnorm(ii,i)=gridsum(ii,i)./normsum(ii,i);
        
        gridlength(ii,i)=length(C(~isnan(C)));
        overmean(ii,i)=nanmean(C(:))/meanint;
        normnorm(ii,i)=nanmean(G(:))/meannorm;
        generalnorm(ii,i)=overmean(ii,i)/normnorm(ii,i);

    end
end
toc
end