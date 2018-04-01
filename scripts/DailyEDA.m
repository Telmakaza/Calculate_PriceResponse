%% Daily EDA: Do an EDA on daily data
% Author: E. Nonyane
% Date: September 19, 2017

%% Clear workspace

clc
clear
close all

%% Configure paths

addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Classes')
addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\functions')


%% Import market data from report csv file and price response object array.

% Set initial parameters
Market = 'BVSP';
marketCell = importMarketCSV(Market);
Year = '2015';

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
[lowIdx, highIdx, lowDay, highDay] = getHighestAndLowestADV(objArray, Year);

%% Instatiate price response object and visulaise level one data

% Plot least active stock
Stock = PriceResponse(Tickers(lowIdx),'No Spacing required', Market);
Stock.extractfromMongoDBcsvPR(Collection, lowDay, tempCSVOut, transff, 'Include quote volumes');
Stock.CleanCompt('Quote sizes included')
plotOrderBook(Stock, lowDay)
plotTrades(Stock)
ylabel('Transaction price (in local currency)')
title(['Asynchronous transactions of ' Stock.RIC, ' on April 07, 2015'])
set(gca, 'color', 'k')

% Plot most active stock
% Stock = PriceResponse(Tickers(highIdx),'No Spacing required', Market);
% Stock.extractfromMongoDBcsvPR(Collection, highDay, tempCSVOut, transff, 'Include quote volumes');
% Stock.CleanCompt('Quote sizes included')
% plotOrderBook(Stock, highDay)
% plotTrades(Stock)
% ylabel('Transaction price (in local currency)')
% title(['Asynchronous transactions of ' Stock.RIC, ' on April 23, 2015'])
% set(gca, 'color', 'k')

