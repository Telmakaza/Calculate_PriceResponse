function data = extractfromMongoDBcsvf(Collection, RIC, Date, STime,ETime,tempCSVoutput, transactionsFieldFile)

%extractfromMongoDB extracts order book data from a MongoDB database
%
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
%


% Specify field file for mongoexport

        [fieldFile] = transactionsFieldFile;
 


% Construct the execution string for mongoexport
[executionString] = ['"mongoexport.exe" ' ... %'-h 146.141.56.129 --port 27017 ', ...
                        '-d BVSPData ', ...
                        '-c ', Collection, ' ' ...
                        '-q ', ...
                        '"{''#RIC'': ''', RIC, ''', ''Date[G]'': ''' Date ''' , ''Time[G]'': {''$gte'': ''' STime ''', ''$lte'': ''' ETime '''}}" ', ...
                        '--sort ', ...
                        '"{''Time[G]'': 1}" ', ...
                        '--type=csv ', ...
                        '--fieldFile ', ...
                        '"', fieldFile, '" ', ...
                        '--out ', ...
                        '"', tempCSVoutput, '"'];
                    
% Execute mongoexport, data stored temporarily on disk in CSV file
               
dos(executionString,'-echo');

% Read CSV file into MATLAB workspace, remove extraneous quotations in
% string columns

   [tempData] = textscan(fopen(tempCSVoutput),'%q %q %q %q %q %q %q %q','delimiter', ',' ,'headerlines',1);


temp = str2double(cat(2,tempData{5:end}));

temp(isnan(temp)) = 0;

data = [cat(2,tempData{1:4}),num2cell(temp)];

% Delete temporary CSV file
fclose('all');
delete(tempCSVoutput);
