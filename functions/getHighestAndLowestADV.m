function [i,j, lowday, highday] = getHighestAndLowestADV(objarray, Year)
%GETHIGHESTANDLOWESTADV - get the indices of the stocks with the least and
%highest ADV from price response object, and the corresponding trading day
%   GETHIGHESTANDLOWESTADV(objarray) produces two indices, i, j. i is the 
%   index of the stock with the lowest ADV and j is the index of the stock 
%   with the higest ADV.

% get size of object array
n = numel(objarray);

% Initialise ADV vector
ADV = zeros(n,1);

% Claculate mean ADV for each object
for i = 1:n
    ADV(i) = mean(objarray(i).ADTVolume(objarray(i).ADTVolume~=0));
end

% Get indices 
[~,i] = min(ADV);
[~,j] = max(ADV);
[~, lowdayidx] = min(objarray(i).ADTVolume(objarray(i).ADTVolume~=0));
[~, highdayidx] = max(objarray(j).ADTVolume);

% Convert date indices into date strings
SDate = ['01-Jan-', Year];
EDate = ['31-Dec-', Year];
[dailydates] =...
                upper(cellstr(datestr(datenum(SDate):1:datenum(EDate))));
lowday = dailydates{lowdayidx};
highday = dailydates{highdayidx};
            
