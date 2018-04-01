function objarray = loadPRObjectArray(Market,Year)
%LOADPROBJECTARRAY - load the array of an object of type price response.
%   LOADOBJECTARRAY(Market, Year) loads the object array of a market
%   specified by Market (1 x 3 char) , and year specified by Year 
%   (1 x 4 char).

% get the file name
dataPath = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\';
fullFile = [dataPath, Market, '\SingleStocks\', Market, '1Y', Year];

% Load object array into workspace
objstruct = load(fullFile);
objarray = objstruct.Stocks;