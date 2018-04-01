function data = extractfromMongoDBcsvPR2(ticker, collection, startDateTime, endDateTime, tempcsvout, fieldFile)

% Convert Start/End dates to ISO date number (milliseconds since Unix
% epoch)
[unixEpoch] = datenum(1970,1,1,0,0,0);
[unixStartDateTime] = round((datenum(startDateTime) - unixEpoch) * 86400000);
[unixEndDateTime] = round((datenum(endDateTime) - unixEpoch) * 86400000);

% Construct the execution string for mongoexport
[executionString] = ['"mongoexport.exe" ',...
    '-d BRICSData2 ', ...
    '-c ', collection, ' ' ...
    '-q ', ...
    '"{''RIC'': ''', ticker, ''', ''DateTime'': {''$gt'': new Date(', num2str(unixStartDateTime), ') , ''$lte'': new Date(', num2str(unixEndDateTime),')}}" ', ...
    '--type=csv ', ...
    '--fieldFile ', ...
    '"', fieldFile, '" ', ...
    '--out ', ...
    '"', tempcsvout, '"'];
% Execute mongoexport, data stored temporarily on disk in CSV file
dos(executionString);

data = textscan(fopen(tempcsvout), '%s %s %q %f %f %f %f %f %f', 'delimiter', ',', 'headerlines', 1);

fclose('all');

% Read CSV file into MATLAB workspace, remove extraneous quotations in
% string columns

% switch nargin
%     case 5
%         tempData = textscan(fopen(tempCSVoutput),'%q %q %q %q %q %q %q %q','delimiter', ',' ,'headerlines',1);
%     case 6
%         tempData = textscan(fopen(tempCSVoutput),'%q %q %q %q %q %q %q %q %q %q','delimiter', ',' ,'headerlines',1);
% end
% 
% 
% temp = str2double(cat(2,tempData{5:end}));
% 
% temp(isnan(temp)) = 0;
% 
% Data = [cat(2,tempData{1:4}),num2cell(temp)];
% 
% % Delete temporary CSV file
% fclose('all');
% delete(tempCSVoutput);
end