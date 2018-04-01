function  p = plotTrades(Stock)
%PLOTTRADES - plot the prices of trades with respect to time directly from
%the orderbook of a particular stock
% PLOTTRADES(Stock) produces a two dimensional plot of trade prices
% against (local) time. 

% Extract trade prices, volumes and times
timePriceVol = cell2mat(Stock.data(strcmp(Stock.data(:,4), 'Trade'), [3 5 6]));

Market = Stock.Market;

% Set GMT Offset
switch Market
    case 'BSE'
        GMTOffset = '05:30';
    case 'BVSP'
        GMTOffset = '02:00';
    case 'ESE'
        GMTOffset = '02:00';
    case 'JSE'
        GMTOffset = '02:00';
    case 'MOEX'
        GMTOffset = '03:00';
    case 'NSE'
        GMTOffset = '03:00';
    case 'SSE'
        GMTOffset = '08:00';
end

if strcmp(Market,'BVSP')
    GMTOffset = -datenum(GMTOffset);
else
    GMTOffset = datenum(GMTOffset);
end

% Offset date to local time
timePriceVol(:,1) = timePriceVol(:,1) + GMTOffset;

% Bin trading volumes
N = 4; % Number of bins
binEdges = zeros(N,1);
for j = 1:N
    binEdges(j) = quantile(timePriceVol(:,3), j/N);
end
binidx = PriceResponse.binData(timePriceVol(:,3), binEdges);

% Generate plot
figure(1)
hold on
C = rand(1,3);
for i = 1:length(timePriceVol)
    if numel(binidx) < i
        break
    end
    
    if binidx(i) == 1
        M = 1;
    elseif binidx(i) == 2
        M  = 5;
    elseif binidx(i) == 3
        M = 10;
    elseif binidx(i) == 4
        M = 20;
        if timePriceVol(i,3) > 10*std(timePriceVol(:,3))+ mean(timePriceVol(:,3))
            M = 50;
        end
    end
    p = plot(timePriceVol(i,1), timePriceVol(i,2), '.', 'Color', C, 'MarkerSize', M);
end
datetick(gca,'x','HH:MM')
xlabel('Local time')
ylabel('Price (in local currency)')
box on

