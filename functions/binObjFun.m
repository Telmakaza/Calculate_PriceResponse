function meanVol = binObjFun(Vol,Idx)

meanVol = abs(mean(Vol(Idx==1)) - mean(Vol(Idx==2)))...
    + abs(mean(Vol(Idx==3)) - mean(Vol(Idx==4)));

if isnan(meanVol)
    meanVol = 10000000000;
end


