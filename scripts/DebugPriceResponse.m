addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Classes');
addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\functions');

Market = 'SSE';

Collection = [Market,'Transactions'];

marketCell = importMarketCSV(Market);

% Extract stock RICs

Tickers = unique(marketCell(:,1));


Tickers = Tickers(3:end); % Eliminate "#RIC" and index from stock list

if any(strcmp(Market,'MOEX') | strcmp(Market,'BVSP'))
    Tickers = Tickers(2:end);
end


startDate = '01-Nov-2010';
endDate = '01-Nov-2010';

[dailydates] = upper(cellstr(datestr(datenum(startDate):1:datenum(endDate))));

obj = PriceResponse(Tickers(31),'logSpace',Market);
tempCSVoutput = 'C:\JobData\tempnow.csv';
transactionsFieldFile = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\MongoExp\ff.csv';

ndays = numel(dailydates);
tic
for i = 1:ndays
    
    obj.extractfromMongoDBcsvPR(...
        Collection,dailydates{i},...
        tempCSVoutput,transactionsFieldFile);
   
    CleanCompt(obj);
    %Classf(obj)
    %obj.data = [];
end
toc


data = obj.data;

quotes = [data{:,7}];

plot(quotes(quotes~=0))
xlabel('time')
ylabel('bid price')
title('BSE bid prices on October 19, 2015')