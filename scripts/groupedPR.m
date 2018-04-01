%% groupedPR - Calculate the price response of grouped stocks
% Author: E. Nonyane
% Date: August 30, 2017

%% Clear workspace

clc
clear
close all


%% Congigure paths

addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Classes')
addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\functions')

%% Set initail parameters
Market = 'ESE';
transff = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\MongoExp\ff.csv';
Collection = [Market,'Transactions'];
SDates = {'01-Jan-2010', '01-Jan-2011', '01-Jan-2012', '01-Jan-2013',...
    '01-Jan-2014', '01-Jan-2015', '01-Jan-2016'};
EDates = {'31-Dec-2010', '31-Dec-2011', '31-Dec-2012', '31-Dec-2013',...
    '31-Dec-2014', '31-Dec-2015', '10-May-2016'};
marketCell = importMarketCSV(Market);

dataFilePath = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\';

%% Claculate price respomnse for each year

% Loop over years
for y = 0:6
    
    % Extract stock RICs
    Tickers = unique(marketCell(:,1));
    Tickers = Tickers(3:end); % Eliminate "#RIC" and index from stock list
    if any(strcmp(Market,'MOEX') | strcmp(Market,'BVSP'))
        Tickers = Tickers(2:end);
    %elseif strcmp(Market,'JSE')
        %Tickers(14:15) = [];
    end
    
    % Load data
    fullFileName = [dataFilePath,Market,'\SingleStocks\',Market,'1Y201',num2str(y)];
    load(fullFileName);

    %   Clear inactive stocks
    for i  = numel(Stocks):-1:1
        if isempty(Stocks(i).Tradesperday)
            Stocks(i) = [];
            Tickers(i) = [];
        end
    end
    

    % Bin stocks
    binidx = binByNumTrades(Stocks);

    % Calculate dailydates
    year = y+1;
    [dailydates] = upper(cellstr(datestr(datenum(SDates{year}):1:datenum(EDates{year}))));

    % Count number of daily dates
    N = numel(dailydates);
    
    % Initailize groupedStocks object matrix
    groupedStocksMatrix(3,N) = GroupedPriceResponse;

    % Loop over groups
    for g = 1:3
        
        % Intialize grouped price response object
        groupedStocks = GroupedPriceResponse(Tickers(binidx==g),dailydates,Market);
        
        % Loop over daily dates
        parfor d = 1:N
            
            tempOut = ['C:\JobData\enonyane\Gtempdata\tempJob',Market,num2str(d),'.csv'];
            
            groupedStocks(d) = ...
                groupedStocks(d).stockParameters(Collection,dailydates{d},tempOut,transff);
            
        end
        
        groupedStocksMatrix(g,:) = groupedStocks;
        clear groupedStocks
    end
    
    % Save groupedStocksMatrix
    saveFilePath = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\';
    saveFileName = [saveFilePath,Market,'\GroupedStocks\',Market,'G1Y201',num2str(y),'.mat'];
    save(saveFileName,'groupedStocksMatrix');
    clear groupedStocksMatrix
end
