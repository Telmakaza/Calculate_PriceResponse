function out = loadGroupedPR(Market, year)
%LOADGROUPEDPR - Load the grouped price response array of a particular
%market

filePath = 'C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\Market Information\';
fullFile = [filePath,Market,'\groupedStocksForTex\','G',Market,year];

gstruct = load(fullFile);
out = gstruct.gStocks;

