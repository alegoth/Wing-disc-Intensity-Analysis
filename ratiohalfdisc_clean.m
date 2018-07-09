%This script measures the ratio between the right and left of the image for
%both channels. 
function [ratiohalf,ratiocontr,rationorm]=ratiohalfdisc_clean(oricent,normcent)
half=floor(size(oricent,2)/2);
oriant=oricent(:,1:half,:);
normant=normcent(:,1:half,:);
oripost=oricent(:,half+1:end,:);
normpost=normcent(:,half+1:end,:);
antint=nanmean(oriant(:));
antintnorm=nanmean(normant(:));
postint=nanmean(oripost(:));
postintnorm=nanmean(normpost(:));
ratiohalf=postint/antint;
ratiocontr=postintnorm/antintnorm;
rationorm=ratiohalf/ratiocontr;
end