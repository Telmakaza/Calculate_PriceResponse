%% visualisePriceResponse -- visualize the price impact of individual stocks
% Author: E. Nonyane
% Date: December 03, 2017

%% Clear workspace
clc
clear
close all

%% Configure paths
addpath('C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\Classes')
addpath('C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\functions')
datapath = 'C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\Market Information\';

%% Set params
Market = 'SSE';
year = '2010';
analysis = 'Single';
liquidity = 'Volume';
priceResponse = 'RL';
fnum = '3_63';

%% Load data
fileName = [datapath, Market, '\SingleStocks\', Market, '6Y', year, '.mat'];
load(fileName);

%% Visualize price respnse

% Clear stocks with no data
for k = numel(Stocks):-1:1
    if isempty(Stocks(k).BPIM)
        Stocks(k) = [];
    end
end

N = numel(Stocks);
ADTV = zeros(N,1);

switch liquidity
    case 'Volume'
        for i = 1:numel(Stocks)
            ADTV(i) = mean(Stocks(i).ADTVolume);
        end
    case 'Value'
        for i = 1:numel(Stocks)
            ADTV(i) = mean(Stocks(i).ADTValue);
        end
end

% Clear stocks with zero liquidity
ADTV(ADTV==0) = [];

% Create bin edges and bid stocks by liquidity
numBins = 3;
binEdges = zeros(numBins,1);
for ii = 1:numBins
    binEdges(ii) = quantile(ADTV,ii/numBins);
end
binidx = PriceResponse.binData(ADTV,binEdges);

% Plot curves
if strcmp(priceResponse, 'Price Impact')
    
    for i = 1:2
        figure(i)
        hold on
        box on
    end
    
elseif strcmp(priceResponse, 'CL') || strcmp(priceResponse, 'DL') || ...
        strcmp(priceResponse, 'RL') || strcmp(priceResponse, 'G0') 
    
    figure(1)
    hold on
    box on
end

% Initialise matrix to store data

dataout1 = nan(20, N*3);
dataout2 = nan(20, N*3);

for j = 1:N
    switch binidx(j)
        case 1
            C = 'r';
            dataout1(:,3*j) = 1;
            dataout2(:,3*j) = 1;
        case 2
            C = 'g';
            dataout1(:,3*j) = 2;
            dataout2(:,3*j) = 2;
        case 3
            C = 'b';
            dataout1(:,3*j) = 3;
            dataout2(:,3*j) = 3;
    end
    
    switch priceResponse
        case 'Price Impact'
            figure(1)
            plot(Stocks(j).BPIM(:,1), Stocks(j).BPIM(:,2) ,'-s', 'Color', C)
            
            % get buyer and seller price impacts
            bpi = Stocks(j).BPIM(:,2);
            bomega = Stocks(j).BPIM(:,1);
            
            spi = -Stocks(j).SPIM(:,2);
            somega = Stocks(j).SPIM(:,1);
            
            % Get number of buyer and seller price changes
            nb = numel(bpi);
            ns = numel(spi);
            
            % Populate data matrix
            dataout1(1:nb, 3*j-1) = bpi;
            dataout1(1:nb, 3*j-2) = bomega;
            
            dataout2(1:ns, 3*j-1) = spi;
            dataout2(1:ns, 3*j-2) = somega;
            
            
            
            figure(2)
            plot(Stocks(j).SPIM(:,1), -Stocks(j).SPIM(:,2) ,'-s', 'Color', C)
            
        case 'CL'
            figure(1)
            L = 1:numel(Stocks(j).CL);
            plot(L, Stocks(j).CL, 'Color', C);
            ncl = numel(L);
            dataout1(1:ncl, 3*j - 2) = L';
            dataout1(1:ncl, 3*j - 1) = Stocks(j).CL;
            
        case 'DL'
            figure(1)
             L = 1:numel(Stocks(j).DL);
             plot(L, sqrt(Stocks(j).DL./L'), 'Color', C)
             ncl = numel(L);
             dataout1(1:ncl, 3*j - 2) = L';
             dataout1(1:ncl, 3*j - 1) = sqrt(Stocks(j).DL./L');
             
        case 'RL'
             figure(1)
             L = 1:numel(Stocks(j).RL);
             plot(L, Stocks(j).RL, 'Color', C)
             ncl = numel(L);
             dataout1(1:ncl, 3*j - 2) = L';
             dataout1(1:ncl, 3*j - 1) = Stocks(j).RL;
             
        case 'G0'
             figure(1)
             L = 1:numel(Stocks(j).G0);
             plot(L, Stocks(j).G0, 'Color', C)
             ncl = numel(L);
             dataout1(1:ncl, 3*j - 2) = L';
             dataout1(1:ncl, 3*j - 1) = Stocks(j).G0;
    end
end


if strcmp(Market, 'BVSP')
    market = 'B3';
elseif strcmp(Market, 'ESE')
    market = 'EGX';
else
    market = Market;
end

switch priceResponse
    
    case 'Price Impact'
    figure(1)
    set(gca, 'xscale', 'log')
    set(gca, 'yscale', 'log')
    xlabel('$\omega$', 'interpreter', 'latex', 'fontsize', 20)
    ylabel('$\Delta p$', 'interpreter', 'latex', 'fontsize', 20)
    title(['Jan 2010 to May 2016 buyerer initiated price impact curves for ', market, ' listed stocks' ], 'fontsize', 15)

    figure(2)
    set(gca, 'xscale', 'log')
    set(gca, 'yscale', 'log')
    xlabel('$\omega$', 'interpreter', 'latex', 'fontsize', 20)
    ylabel('$-\Delta p$', 'interpreter', 'latex', 'fontsize', 20)
    title(['Jan 2010 to May 2016 seller initiated price impact curves for ', market, ' listed stocks'], 'fontsize', 15)
    
    
    % save output to csv file
    csvwrite(['C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\plotdata\', market, '\', fnum, 'left.csv'], dataout1)
    csvwrite(['C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\plotdata\', market, '\', fnum, 'right.csv'], dataout2)

    case 'CL'
        figure(1)
        set(gca, 'xscale', 'log')
        set(gca, 'yscale', 'log')
        xlabel('$\ell$', 'interpreter', 'latex', 'fontsize', 20)
        ylabel('$\mathcal{C}(\ell)$', 'interpreter', 'latex', 'fontsize', 20)
        title(['Jan 2010 to May 2016 trade sign autocorrelations curves for ', market, ' listed stocks'], 'fontsize', 15)
        if strcmp(Market, 'NSE')
            set(gca, 'yscale', 'lin')
        end
        
         % save output to csv file
    csvwrite(['C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\plotdata\', market, '\', fnum, 'left.csv'], dataout1)
        
    case 'RL'
        figure(1)
        set(gca, 'xscale', 'log')
        if strcmp(Market, 'ESE') || strcmp(Market, 'MOEX') || strcmp(Market, 'NSE')
            set(gca, 'yscale', 'log')
        end
        xlabel('$\ell$', 'interpreter', 'latex', 'fontsize', 20)
        ylabel('$\mathcal{R}(\ell)$', 'interpreter', 'latex', 'fontsize', 20)
        title(['Jan 2010 to May 2016 price response coefficient curves for ', market, ' listed stocks'], 'fontsize', 15)
        
         % save output to csv file
    csvwrite(['C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\plotdata\', market, '\', fnum, 'left.csv'], dataout1)
        
    case 'DL'
        figure(1)
        set(gca, 'xscale', 'log')
        if strcmp(Market, 'ESE') || strcmp(Market, 'MOEX') || strcmp(Market, 'NSE')
            set(gca, 'yscale', 'log')
        end
        xlabel('$\ell$', 'interpreter', 'latex', 'fontsize', 20)
        ylabel('$\sqrt{ \frac{\mathcal{D}(\ell)} {\ell} }$', 'interpreter', 'latex', 'fontsize', 20)
        title(['Jan 2010 to May 2016 price dispersion curves for ', market, ' listed stocks'], 'fontsize', 15)
        
         % save output to csv file
    csvwrite(['C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\plotdata\', market, '\', fnum, 'right.csv'], dataout1)
        
    case 'G0'
        figure(1)
        set(gca, 'xscale', 'log')
        set(gca, 'yscale', 'log')
        xlabel('$\ell$', 'interpreter', 'latex', 'fontsize', 20)
        ylabel('$G_0(\ell)$', 'interpreter', 'latex', 'fontsize', 20)
        title(['Jan 2010 to May 2016 bare response curves for ', market, ' listed stocks'], 'fontsize', 15)
        
         % save output to csv file
    csvwrite(['C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\plotdata\', market, '\', fnum, 'right.csv'], dataout1)
end

%% Save plot
plotPath = 'C:\Users\ENonyane\Desktop\PR_Plots\';
type = '.pdf';
switch priceResponse
    case 'Price Impact'
        %set(figure(1), 'units','normalized','outerposition',[0 0 1 1])
        %set(figure(2), 'units','normalized','outerposition',[0 0 1 1])
        saveas(figure(1), [plotPath, Market, '\SingleStocks\BPI', liquidity, type])
        saveas(figure(2), [plotPath, Market, '\SingleStocks\SPI', liquidity, type])
        
    case 'CL'
        %set(figure(1), 'units','normalized','outerposition',[0 0 1 1])
        saveas(figure(1), [plotPath, Market, '\SingleStocks\CL', liquidity, type])
        
    case 'DL'
        %set(figure(1), 'units','normalized','outerposition',[0 0 1 1])
        saveas(figure(1), [plotPath, Market, '\SingleStocks\DL', liquidity, type])
        
    case 'RL'
        %set(figure(1), 'units','normalized','outerposition',[0 0 1 1])
        saveas(figure(1), [plotPath, Market, '\SingleStocks\RL', liquidity, type])
        
    case 'G0'
        %set(figure(1), 'units','normalized','outerposition',[0 0 1 1])
        saveas(figure(1), [plotPath, Market, '\SingleStocks\G0', liquidity, type])
        
end

close all
