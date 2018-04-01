function data = extractEODData(Collection, RIC, Date,tempCSVoutput, transactionsFieldFile)

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
[executionString] = ['"mongoexport.exe" ' ...,
    '--host 146.141.56.129 --port 27017 ', ...
    '--authenticationDatabase BRICSData ',...
    '-u enonyane ',...
    '-p q3r1 ',...
    '-d BRICSData ', ...
    '-c ', Collection, ' ' ...
    '-q ', ...
    '"{''#RIC'': ''', RIC, ''', ''Date[G]'': ''' Date ''' }" ', ...
    '--type=csv ', ...
    '--fieldFile ', ...
    '"', fieldFile, '" ', ...
    '--out ', ...
    '"', tempCSVoutput, '"'];

% Execute mongoexport, data stored temporarily on disk in CSV file
dos(executionString,'-echo');

switch RIC
    case '.JTOPI'
        STime = '07:10:00.000';
        ETime = '14:50:00.000';
        
    case '.BSESN'
        STime = '03:55:00.000';
        ETime = '09:50:00.000';
        
    case '.BVSP'
        STime = '12:10:00.000';
        ETime = '18:45:00.000';
        
    case '.EGX30'
        STime = '08:10:00.000';
        ETime = '12:20:00.000';
        
    case '.IRTS'
        STime = '07:10:00.000';
        ETime = '15:29:00.000';
        
    case '.NSE20'
        STime = '06:40:00.000';
        ETime = '11:50:00.000';
        
    case '.SSE50'
        STime = '01:40:00.000';
        ETime = '03:20:00.000';
        
        %STime2 = '05:10:00.000';
        %ETime2 = '06:50:00.000';
end


% Read CSV file into MATLAB workspace, remove extraneous quotations in
% string columns
temp = textscan(fopen(tempCSVoutput),'%f %s','headerlines',1,'delimiter',',');

if ~isempty(temp)
    
    prices = temp{1,1};
    dateNumbers = datenum(temp{1,2});
    
    % Clean data from preopening
    prices(dateNumbers < datenum(STime) | dateNumbers > datenum(ETime)) = [];
    
    % Remove non-index event
    if ~isempty(prices)
        prices(prices==0) = [];
        
        % Extract end of day parameters
        data = zeros(4,1);
        if ~isempty(prices)
            data(1) = max(prices);
            data(2) = min(prices);
            data(3) = prices(1);
            data(4) = prices(end);
        else
            data = zeros(4,1);
        end
    else
        data = zeros(4,1);
    end
    
end

% Delete unused data
fclose('all');
delete(tempCSVoutput);
