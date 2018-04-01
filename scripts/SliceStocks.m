%% Clear Workspace
clc
clear
close all
%% Congifure paths

addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Classes');
addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\functions');

%% Initialize parameters.

MARKETS = {'BVSP', 'BSE', 'ESE', 'JSE', 'MOEX', 'NSE', 'SSE'};

startDate = {'01-Jan-2010','01-Jan-2011','01-Jan-2012','01-Jan-2013',...
        '27-Jan-2014','01-Jan-2015','01-Jan-2016'};
    
endDate = {'10-May-2016','31-Dec-2011','31-Dec-2012','31-Dec-2013',...
        '31-Dec-2014','31-Dec-2015','10-May-2016'};
    
FieldFile = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\MongoExp\ff.csv';
    
%% Loop over markets
for m = 1:7
    
    Market = MARKETS{m};
    
    % Import report csv
    marketCell = importMarketCSV(Market);
    
    % Extract stock RIC from report csv
    Tickers = unique(marketCell(:,1));
    
    % Eliminate "#RIC" and index from stock list
    Tickers = Tickers(3:end);
    
    % Remove items which are not stock from ticker list
    if any(strcmp(Market,'MOEX') | strcmp(Market,'BVSP'))
        Tickers = Tickers(2:end);
    end
    
    % Get number of tickers
    n = numel(Tickers);
    
    % Instantiate price response object array
    Stocks = PriceResponse(Tickers,'logSpace',Market);
        
    % Set collection name
    Collection = [Market,'Transactions'];
    
    % Populate the 'Analysis' PriceResponse property
    for i = 1:numel(Tickers)
          Stocks(i).Analysis = 'Single';
    end
    
    % Loop over years
    for y = 1
        
        % Set start and end dates
        SDate = startDate{y};
        EDate = endDate{y};
        
        % Calculate price response in parallel
        parfor i=1:numel(Tickers)
            tempOut = ['C:\JobData\enonyane\tempdata\temp',Market,num2str(i),'.csv'];
            Stocks(i) = Stocks(i).DailyParameters(Collection,SDate,EDate,...
                tempOut,FieldFile,'Full Price Response');
        end
        
        % Save output
        save(['C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\',Market,'\SingleStocks\',Market,'6Y',SDate(end-3:end),'.mat'],'Stocks')
        
        % Clear stock variable
        clear Stocks
        
    end
end