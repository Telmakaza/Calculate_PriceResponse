function marketCell = importMarketCSV(marketString)
%importMarketCSV - importMarketCSV imports the csv file of a market into
% the MATLABworkspace. Market can be one of the following strings:
% 'BSE', 'BVSP', 'ESE', 'JSE', 'MOEX', 'NSE', 'SSE'.
%
% INPUTS:
%--------------------------------------------------------------------------
% Maket: A string that represents the accronym of a particular market
%
%--------------------------------------------------------------------------
% 
% OUTPUTS:
%--------------------------------------------------------------------------
% marketCell: A cell array containing market data
%
%--------------------------------------------------------------------------

switch marketString
    
    case 'JSE'
        filename = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\JSE\tim.gebbie@wits.ac.za-JSE-TRANS-2010-2016-N118193142-report.csv';
        delimiter = ',';
        formatSpec = '%s%s%s%s%s%s%s%[^\n\r]';
        fileID = fopen(filename,'r');
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
        fclose(fileID);
        marketCell = [dataArray{1:end-1}];
        
    case 'BVSP'
        filename1 = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\BVSP\tim.gebbie@wits.ac.za-BVSP-TRANS-2010-2012-N118211912-report.csv';
        filename2 = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\BVSP\tim.gebbie@wits.ac.za-BVSP-TRANS-2012-2014-N118211870-report.csv';
        filename3 = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\BVSP\tim.gebbie@wits.ac.za-BVSP-TRANS-2014-2016-N118211106-report.csv';
        delimiter = ',';
        formatSpec = '%s%s%s%s%s%s%s%[^\n\r]';
        fileID1 = fopen(filename1,'r');
        fileID2 = fopen(filename2,'r');
        fileID3 = fopen(filename3,'r');
        dataArray1 = textscan(fileID1, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
        dataArray2 = textscan(fileID2, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
        dataArray3 = textscan(fileID3, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
        fclose(fileID1);
        fclose(fileID2);
        fclose(fileID3);
        dataCell1 = [dataArray1{1:end-1}];
        dataCell2 = [dataArray2{1:end-1}];
        dataCell3 = [dataArray3{1:end-1}];
        marketCell = [dataCell1;dataCell2;dataCell3];
        
    case 'BSE'
        filename = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\BSE\tim.gebbie@wits.ac.za-BSE-TRANS-2010-2016-N118192597-report.csv';
        delimiter = ',';
        formatSpec = '%s%s%s%s%s%s%s%[^\n\r]';
        fileID = fopen(filename,'r');
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
        fclose(fileID);
        marketCell = [dataArray{1:end-1}];
        
    case 'ESE'
        filename = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\ESE\tim.gebbie@wits.ac.za-ESE-TRANS-2010-2016-N118602131-report.csv';
        delimiter = ',';
        formatSpec = '%s%s%s%s%s%s%s%[^\n\r]';
        fileID = fopen(filename,'r');
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
        fclose(fileID);
        marketCell = [dataArray{1:end-1}];

    case 'MOEX'
        filename = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\MOEX\tim.gebbie@wits.ac.za-RTS-TRANS-2010-2016-N118192374-report.csv';
        delimiter = ',';
        formatSpec = '%s%s%s%s%s%s%s%[^\n\r]';
        fileID = fopen(filename,'r');
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
        fclose(fileID);
        marketCell = [dataArray{1:end-1}];
        
    case 'NSE'
        filename = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\NSE\tim.gebbie@wits.ac.za-NSE-TRANS-2010-2016-N118592800-report.csv';
        delimiter = ',';
        formatSpec = '%s%s%s%s%s%s%s%[^\n\r]';
        fileID = fopen(filename,'r');
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
        fclose(fileID);
        marketCell = [dataArray{1:end-1}];
        
    case 'SSE'
        filename = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\SSE\tim.gebbie@wits.ac.za-SSE-TRANS-2010-2016-N118192877-report.csv';
        delimiter = ',';
        formatSpec = '%s%s%s%s%s%s%s%[^\n\r]';
        fileID = fopen(filename,'r');
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);
        fclose(fileID);
        marketCell = [dataArray{1:end-1}];
end
        
        