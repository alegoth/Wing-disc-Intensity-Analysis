%This script translate the stack to put the center selected by hand at the
%center of the image.
function [normcent,oricent,trans,maskpostcent]=recenterimage_clean(maxproj,normclean,oriclean,maskpost)

figure, imshow(maxproj,[])
center = ginput(1);
close

s=size(oriclean);
imcenter=fliplr(round(s(1:2)/2));
trans=round(imcenter-center);
normclean(isnan(normclean))=2;
oriclean(isnan(oriclean))=2;
normcent=imtranslate(normclean,trans,'FillValues',2,'OutputView','full');
oricent=imtranslate(oriclean,trans,'FillValues',2,'OutputView','full');
maskpostcent=imtranslate(maskpost,trans,'FillValues',0,'OutputView','full');
normcent(normcent==2)=NaN;
oricent(oricent==2)=NaN;
end