function [data, headers] = extractmongodatanative(Username, Password, Market, Collection, RIC, StartDateTime, EndDateTime, tempCSVoutput, transactionsFieldFile, marketdepthFieldFile)
% EXTRACT TICK DATA FROM MONGO DATABASE
% -------------------------------------
% INPUTS:
% ----------------------------------------------------------------------------------------------------------------------------
%  Username                 (1xk) char          MongoDB username (see QuERILab administrator)
% 
%  Password                 (1xk) char          MongoDB password (see QuERILab administrator)
% 
%  Market                   (1xk) char          Geographical market considered. 
%                                               ['JSE', 'BSE', 'BOVESPA']
%  Collection               (1xk) char          Collection in TickData to extract from.
%                                               ['Transactions','MarketDepth']
%  RIC                      (1xk) char          Reuters instrument code.
%                                               [e.g. 'AGLJ.J', 'SBKJ.J']
%  StartDateTime            (1xk) char          Start date of period to extract (date and time).
%                                               [e.g. '2012-05-09 10:00]
%  EndDateTime              (1xk) char          End date of period to extract (date and time).
%                                               [e.g. '2012-05-09 10:15']
%  tempCSVoutput            (1xk) char          Filepath for temporary CSV file for Mongo output
%                                               [e.g. 'D:\mongoOutput.csv']
%  transactionsFieldFile    (1xk) char          Filepath for text field file for Transactions data
%                                               [e.g. 'D:\mongoTransactionsFieldFile.txt']
%  marketdepthFieldFile     (1xk) char          Filepath for text field file for Market Depth data
%                                               [e.g. 'D:\mongoMarketdepthFieldFile.txt']
% 
% OUTPUTS:
% ----------------------------------------------------------------------------------------------------------------------------
%   data                    (nxm) cell          All data returned as one contiguous cell matrix
%   headers                 (1xm) cell          Column headers (fields) for each column in data cell matrix
% 
% EXAMPLE:
% ----------------------------------------------------------------------------------------------------------------------------
% [data, headers] = extractmongodatanative('JSE','Transactions','MTNJ.J','2012-05-09 10:00','2012-05-09 10:15','D:\mongoOutput.csv','D:\mongoTransactionsFieldFile.txt','D:\mongoMarketdepthFieldFile.txt');
% [data, headers] = extractmongodatanative('JSE','Transactions','MTNJ.J','2012-05-09 10:00','2012-05-09 10:15','E:\MATLAB\mongoOutput.csv','G:\FieldFiles\mongoTransactionsFieldFile.txt','G:\FieldFiles\mongoMarketdepthFieldFile.txt');

% Convert Start/End dates to ISO date number (milliseconds since Unix
% epoch)
[unixEpoch] = datenum(1970,1,1,0,0,0);
[unixStartDateTime] = round((datenum(StartDateTime) - unixEpoch) * 86400000);
[unixEndDateTime] = round((datenum(EndDateTime) - unixEpoch) * 86400000);

% Specify field file for mongoexport
switch Collection
    case 'Transactions'
        [fieldFile] = transactionsFieldFile;
    case 'MarketDepth'
        [fieldFile] = marketdepthFieldFile;
end

% Construct the execution string for mongoexport
[executionString] = ['"mongoexport.exe" ', ...
                        '-u ', Username, ' ', ...
                        '-p ', Password, ' ', ...
                        '-h 146.141.56.11 --port 27017 ', ...
                        '-d TickData ', ...
                        '-c ', Market, Collection, ' ' ...
                        '-q ', ...
                        '"{''RIC'': ''', RIC, ''', ''DateTimeL'': {''$gte'': new Date(', num2str(unixStartDateTime), '), ''$lte'' : new Date(', num2str(unixEndDateTime), ') } }" ', ...
                        '--sort ', ...
                        '"{''DateTimeL'': 1}" ', ...
                        '--csv ', ...
                        '--fieldFile ', ...
                        '"', fieldFile, '" ', ...
                        '--out ', ...
                        '"', tempCSVoutput, '"'];
                    
% Execute mongoexport, data stored temporarily on disk in CSV file
tic               
[status, cmdout] = dos(executionString,'-echo');

% Read CSV file into MATLAB workspace, remove extraneous quotations in
% string columns
switch Collection
    case 'Transactions'
        [tempData] = textscan(fopen(tempCSVoutput), '%q %q %q %s %q %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f', 'delimiter', ',', 'headerlines', 1);
    case 'MarketDepth'
        [tempData] = textscan(fopen(tempCSVoutput), '%q %q %q %s %q %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f %20.1f', 'delimiter', ',', 'headerlines', 1);
end

% Concatenate cellarrays for final output
data = [cat(2, tempData{1:5}), num2cell(cat(2, tempData{6:end}))];
headers = textscan(fopen(fieldFile), '%s', 'delimiter', '\n');
headers = headers{1}';

% Delete temporary CSV file
fclose('all');
delete(tempCSVoutput);
toc