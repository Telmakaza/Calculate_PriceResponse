%% calAvGroupedPR - Calculate the average price response of grouped stocks
% Author: E. Nonayne
% Date = August 31, 2017

%% Clear worspace
clc
clear
close all

%% Configure paths
addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Classes')
addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\functions')

%% Set initail parameters
Market  = 'JSE';
dataPath  = ['C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\', Market,'\GroupedStocks\'];

%% Calculate grouped price response

% Loop over matfiles

for ii = 1:6
    figure(ii)
    hold on
end

for m = [5 6]
    
    % Load matfile
    fileName = [dataPath,Market,'G1Y201',num2str(m),'.mat'];
    load(fileName);
    
    % Clear non-trading days
    for i = length(groupedStocksMatrix):-1:1
        if isempty(groupedStocksMatrix(1,i).GdPB)
            groupedStocksMatrix(:,i) = [];
        end
    end
    
    n = length(groupedStocksMatrix);
    
    % Initialise price response object
    gStocks = PriceResponse({'lowNumTrades','medNumTrdaes','highNumTrades'},...
        'logSpace', Market);
    
    % Loop over groupes
    for j = 1:3
        
        switch j
            case 1
                c = 'r';
            case 2
                c = 'g';
            case 3
                c = 'b';
        end
        
        % calculate RL
        RL = [groupedStocksMatrix(j,:).GRL];
        RL(:,any(isnan(RL))) = [];
        RL = mean(RL,2);
        
        
        % Calculate DL
        DL = [groupedStocksMatrix(j,:).GDL];
        DL(:,any(isnan(DL))) = [];
        DL = mean(DL,2);
        L = (1:1000)';
        
        
        % Calculate CL
        CL = [groupedStocksMatrix(j,:).GCL];
        CL(:,any(isnan(CL))) = [];
        CL = mean(CL,2);
        
        
        % Claculate G0
        G0 = [groupedStocksMatrix(j,:).GG0];
        G0(:,any(isnan(G0))) = [];
        G0 = mean(G0,2);
        
        
        % Populate price response preperties
        gStocks(j).RL = RL;
        gStocks(j).DL = DL;
        gStocks(j).CL = CL;
        gStocks(j).G0 = G0;
        gStocks(j).BV = [groupedStocksMatrix(j,:).GBV];
        gStocks(j).TB = [groupedStocksMatrix(j,:).GTB];
        gStocks(j).dPB = [groupedStocksMatrix(j,:).GdPB];
        gStocks(j).SV = [groupedStocksMatrix(j,:).GSV];
        gStocks(j).dPS = [groupedStocksMatrix(j,:).GdPS];
        gStocks(j).TS = [groupedStocksMatrix(j,:).GTS];
        
        % Calculate the price impact of each group
        gStocks(j).CalPrIM
        
        % Plot curves
        PriceResponse.Plot_PR(gStocks(j),c,['2010',num2str(m)])
        
    end
    
    % Save gStocks in matfile
    saveFilePath = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\';
    saveFileFullName = [saveFilePath,Market,'\groupedStocksForTex\G',Market,'201',num2str(m)];
    save(saveFileFullName,'gStocks')
    
end

for i = [1 4:6]
    figure(i)
    set(gca,'xscale','log');
    set(gca,'yscale','log');
end

figure(3)
set(gca,'xscale','log');


