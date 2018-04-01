transff = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\MongoExp\ff.csv';

Market = 'JSE';

Collection = [Market,'Transactions'];

SDate = '04-Jan-2016';
EDate = '04-Jan-2016'; 

marketCell = importMarketCSV(Market);

% Extract stock RICs

Tickers = unique(marketCell(:,1));


Tickers = Tickers(3:end); % Eliminate "#RIC" and index from stock list

if any(strcmp(Market,'MOEX') | strcmp(Market,'BVSP'))
    Tickers = Tickers(2:end);
end

tempCSVoutput = ['C:\JobData\enonyane\Gtempdata\temp',num2str(1),'.csv'];

%% Group stocks by number of trades

binidxStrct = load('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\JSE\JSE_BINS.mat');

binidx = binidxStrct.binidx;

[Date] = upper(cellstr(datestr(datenum(SDate):1:datenum(EDate))));

n = numel(Date);

obj = GroupedPriceResponse(Tickers(binidx==3),Date,Market);

%obj = stockParameters(obj,Collection,Date,tempCSVoutput,transff);

