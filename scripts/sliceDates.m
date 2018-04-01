%% sliceDates:
% Script for calculation the master price impact curve and master bare
% impact function of a market.
%
% Author: E.Nonyane
% Date: 22-June-2017

%% Clear workspace

clc
clear
%close all

%% Configure paths

addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Classes');
addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\functions');
addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\scripts');

%% Import market data

transff = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\MongoExp\ff.csv';

Market = 'ESE';

Collection = [Market,'Transactions'];

SDate = '04-Jan-2010';
EDate = '10-May-2016';

marketCell = importMarketCSV(Market);

% Extract stock RICs

Tickers = unique(marketCell(:,1));


Tickers = Tickers(3:end); % Eliminate "#RIC" and index from stock list

if any(strcmp(Market,'MOEX') | strcmp(Market,'BVSP'))
    Tickers = Tickers(2:end);
elseif strcmp(Market,'JSE')
    Tickers(14:15) = [];
end

%% Imprort the bin index matfile

stockStrct = load(['C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\',Market,'\',Market,'6Y']);
Stocks = stockStrct.Stocks;
binidx = binByADTV(Stocks);

%% Calculate the price response of the input market

[dailydates] = upper(cellstr(datestr(datenum(SDate):1:datenum(EDate))));

n = numel(dailydates);

%dateObjectMatrix(5,n,17) = GroupedPriceResponse;

% Choose total number of three months
numOf3M = 25;

% Choose total number of groups
numgroups = 3;

for kk = 1:numOf3M
    
    
    % Create index to reference thedates
     tM = 90; % Approx. equal to 3 months 
    
    if kk == 1
        threeMonthsIdx = 1:tM;
    elseif kk ~=1 && kk < numOf3M 
        
            threeMonthsIdx = (kk-1)*tM+1:kk*tM;
            
    elseif kk == 25
        
        threeMonthsIdx = (kk-1)*tM+1:2319;
        
    end
    
    nDays = numel(threeMonthsIdx);
    
    if kk == 1
        dateObjectMatrix(numgroups,nDays) = GroupedPriceResponse;
    else
        dateObjectMatrix(numgroups,nDays+1) = GroupedPriceResponse;
    end
    
    
    % Loop over liquidity groups
    for sgroup = 1:numgroups
        
        dateObjects = GroupedPriceResponse(Tickers(binidx(:,kk)==sgroup),dailydates,Market);
        
        % Loop over 3 months
        parfor i = threeMonthsIdx
            
            tempOut = ['C:\JobData\enonyane\Gtempdata\tempJob',Market,num2str(i),'.csv'];
            
            dateObjects(i) = ...
                dateObjects(i).stockParameters(Collection,dailydates{i},tempOut,transff);
            
        end
        
        
        
        % Construct volume and price impact vectors; calculate the daily averragae
        % price response
        dPB = [];
        BV = [];
        
        dPS = [];
        SV = [];
        
        TB = [];
        TS = [];
        
        RL = zeros(1000,n);
        CL = zeros(1000,n);
        DL = zeros(1000,n);
        G0 = zeros(1000,n);
        
        
        
        for i = 1:n
            
            if ~isempty(dateObjects(i).GdPB)
                
                % Extract buyer price impact information
                dPB = [dPB;dateObjects(i).GdPB'];
                BV = [BV;dateObjects(i).GBV'];
                TB = [TB;dateObjects(i).GTB'];
                
                % Clear unused buyer information data
                dateObjects(i).GdPB = [];
                dateObjects(i).GBV = [];
                dateObjects(i).GTB = [];
                
                % Extract seller price impacts
                dPS = [dPS;dateObjects(i).GdPS'];
                SV = [SV;dateObjects(i).GSV'];
                TS = [TS;dateObjects(i).GTS'];
                
                % Clear unused seller information
                dateObjects(i).GdPS = [];
                dateObjects(i).GSV = [];
                dateObjects(i).GTS = [];
                
                % Calculate the time dependent parameters
                RL(:,i) = dateObjects(i).GRL;
                CL(:,i) = dateObjects(i).GCL;
                DL(:,i) = dateObjects(i).GDL;
                G0(:,i) = dateObjects(i).GG0;
            end
            
        end
        
            
        CL(:,any(CL,1)) = [];
        RL(:,any(RL,1)) = [];
        DL(:,any(DL,1)) = [];
        G0(:,any(G0,1)) = [];
        
        CL = mean(CL,2);
        RL = mean(RL,2);
        DL = mean(DL,2);
        G0 = mean(G0,2);
        
        % Construct a PriceResponse object and calculate the price impacts of
        % grouped stocks
        
        groupedStocks = PriceResponse;
        
        groupedStocks.dPB = dPB;
        groupedStocks.BV = BV;
        groupedStocks.TB = TB;
        
        groupedStocks.dPS = dPS;
        groupedStocks.SV = SV;
        groupedStocks.TS = TS;
        
        groupedStocks.binSpacing = 'logSpace';
        
        for k = 1:6
            figure(k)
            hold on
        end
        
        C = rand(1,3);
        
        % Calculate the Price Impact
        CalPrIM(groupedStocks)
        
        % Store the buyer price impact matrix
        dateObjects(1).GBPIM = groupedStocks.BPIM;
       
        % Store the seller price impact matrix
        dateObjects(1).GSPIM = groupedStocks.SPIM;
        
        % Store the information of group
        for i = numel(dateObjects):-1:2
            if isempty(dateObjects(i).GRL)
                dateObjects(i) = [];
            end
        end
        
        
        dateObjectMatrix(sgroup,:) = dateObjects;
        
        
        
    end
    
    filePath = ['C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\',Market,'\dateObjectsNumTrades\'];
    fileName = ['JSE1MdateObj',num2str(kk),'.mat'];
    
    save([filePath,fileName],'dateObjectMatrix')
    
    
    
    
end

