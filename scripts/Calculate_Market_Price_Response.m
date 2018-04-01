%% Clear Workspace
clc
clear

%% Congifure paths

addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Classes');
addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\functions')



%% Import market data from report csv file.
Exchange = importMarketCSV('BVSP');

%% Extract stock RICs and specify the collection from which to extract data

Tickers = unique(Exchange(:,1));

Tickers = Tickers(3:end); % Eliminate "#RIC" and index from stock list

Collection = 'BVSPTransactions';


%% Calculate the price response of all stocks
n = numel(Tickers);

FieldFile = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\MongoExp\ff.csv';

Stocks = PriceResponse(Tickers);

tic
parfor i=1:4
    tempOut = ['C:\JobData\enonyane\tempdata\temp',num2str(i),'.csv'];
    Stocks(i) = Stocks(i).DailyParameters(Collection,'04-Jan-2010','04-May-2010','07:30','14:50',tempOut,FieldFile);
end
toc


Visualise_PR
