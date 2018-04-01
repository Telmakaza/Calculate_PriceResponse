%% calGroupADV -- calculate the ADV and ADTV of stocks groups
% Author: E. Nonyane
% Date: 13 December 2017

%% Clear workspace
clc
clear
close all

%% Configure paths
addpath('C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\functions')
addpath('C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\Classes')
datapath = 'C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\Market Information\';

%% Set paramaters
Market = 'SSE';
nyears = 6;

%% Loop over data files and calculate ADV and ADTV

ADV = zeros(3, nyears + 1);
ADTV = zeros(3, nyears + 1);

for y = 0:nyears
    
    % Load data
    gStocksStruct = load([datapath, Market, '\GroupedStocks\', Market, 'G1Y201', num2str(y), '.mat']);
    gStocks =  gStocksStruct.groupedStocksMatrix;
    sStocksStruct = load([datapath, Market, '\SingleStocks\', Market, '1Y201', num2str(y)]);
    sStockArray = sStocksStruct.Stocks;
    
    % Loop over liquidity groups
    for j = 1:3
        tickers = gStocks(j).Tickers;
        
        % Calculate ADV and ADVT from stock array
        for i = 1:numel(tickers)
            for k = 1:numel(sStockArray)
                if strcmp(tickers{i}, sStockArray(k).RIC)
                    ADV(j, y + 1) = ADV(j, y + 1) + mean(sStockArray(k).ADTVolume);
                    ADTV(j, y + 1) = ADTV(j, y + 1) + mean(sStockArray(k).ADTValue);
                end
            end
        end
    end
end

mADV = mean(ADV, 2);
mADTV = mean(ADTV , 2);