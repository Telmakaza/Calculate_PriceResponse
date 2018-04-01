%% price_time_vol-plot.m -- Visualise the intra-day price of a stock w.r.t time
% Author: E.Nonyane
% Date: October 18, 2017

%% Clear workspace
clc
clear 
close all
 
%% Congigure paths
addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\functions')
addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Classes')

%% Import market data from report csv file and price response object array.

% Set initial parameters
Market = 'ESE';
marketCell = importMarketCSV(Market);
Year = '2016';

% Extract stock RICs
Tickers = unique(marketCell(:,1));
Tickers = Tickers(3:end); % Eliminate "#RIC" and index from stock list
if any(strcmp(Market,'MOEX') | strcmp(Market,'BVSP'))
    Tickers = Tickers(2:end);
end
Collection = [Market,'Transactions'];
tempCSVOut = 'C:\JobData\enonyane\vistempout.csv';
transff = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\MongoExp\ff2.csv';

% Load price response object array and get least and most actively traded
% stock
objArray = loadPRObjectArray(Market, Year);

% Set dates
SDate = ['01-Jan-', Year];
EDate = ['31-Dec-', Year];
[dailydates] =...
                upper(cellstr(datestr(datenum(SDate):1:datenum(EDate))));

% Extact stock trades per day from object array
stockTradesPerDay = objArray.tradesPerDay;

% Get index of trading days
tradeDayIdx = (1:numel(dailydates))';
tradeDayIdx(stockTradesPerDay == 0) = []; % Remove non-trading days

%% Plot trade prices

% Select day and number of stocks
Day = dailydates{tradeDayIdx(82)};
N =  numel(Tickers);
Tickers = Tickers(1:N);

% Initialize graphic object array
ghandleArray = gobjects(N,1);

% Loop over stocks
tic
for i = N:-1:1
    Stock = PriceResponse(Tickers(i),'No Spacing required', Market);
    Stock.extractfromMongoDBcsvPR(Collection, Day, tempCSVOut, transff, 'Include quote volumes');
    Stock.CleanCompt('Quote sizes included')
    if ~isempty(Stock.data)
        ghandleArray(i) = plotTrades(Stock);
        ghandleArray(i).MarkerSize = 10;
    else
        Tickers(i) = [];
        ghandleArray(i) = [];
    end
    
end

% Format plot
title(['Asynchronous transactions of ',Market ,' listed stocks on May 04, 2016'])
l = legend(ghandleArray, Tickers);
set(l, 'Color', 'w', 'Location', 'eastoutside')
% Save plot
F = gcf;
set(gcf,'units','normalized','outerposition',[0 0 1 1])
set(gca, 'yscale', 'log')
set(gca, 'color', 'k')
F.InvertHardcopy = 'off';
%saveas(F, ['C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\',...
%    Market, '\Figures\', Market, 'Transactions.png'])

% Display time taken to complete plot
t = toc;
disp(['The code took: ', num2str(t/60), ' minutes'])
%close all
clear