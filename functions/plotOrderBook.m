function plotOrderBook(obj, Date)
%PLOTORDERBOOK - Visulise the top of the book. 
%   PLOTORDEBOOK(obj) plots the level 1 bid, ask and trade prices, for a 
%   single trading day, against the trade of day time. obj is an object of 
%   of type PriceResponse.

% Extract trade and quote prices and volumes.
bidPrices = cell2mat(obj.data(:,7));
askPrices = cell2mat(obj.data(:,9));
bidVolumes = cell2mat(obj.data(:,8));
askVolumes = cell2mat(obj.data(:,10));
tradePrices = cell2mat(obj.data(:,5));
tradeVolumes  = cell2mat(obj.data(:,6));

Market = obj.Market;

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

% Change zeros into Nans
bidPrices(bidPrices==0) = nan;
askPrices(askPrices==0) = nan;
tradePrices(tradePrices==0) = nan;
bidVolumes(bidVolumes==0) = nan;
askVolumes(askVolumes==0) = nan;
tradeVolumes(tradeVolumes==0) = nan;
times = cell2mat(obj.data(:,3)) + GMTOffset;

figure
hold on
% Plot the order book prices
bprice = plot(times, bidPrices,'.', 'color', 'b', 'markersize', 15);
aprice = plot(times, askPrices,'.', 'color', 'r', 'markersize', 15);
tprice = plot(times, tradePrices,'.', 'color', 'w', 'markersize', 5);
set(gca, 'color', 'k')
datetick(gca,'x','HH:MM')
xlabel('Time')
ylabel('Price (in local currency)')
title(['Quote and trade prices of ', obj.RIC, ' on ', Date])
plegend =legend([aprice, bprice, tprice], 'Ask price', 'Bid price', 'Trade price');
set(plegend, 'color', [.5 .5 .5])

% Plot order book volumes
figure
hold on
bvol = plot(times, bidVolumes, '.b', 'markersize', 5);
avol = plot(times, askVolumes, '.r', 'markersize', 5);
tvol = plot(times, tradeVolumes, '.w', 'markersize', 5);
set(gca, 'color', 'k')
set(gca,'yscale','log')
datetick(gca, 'x', 'HH:MM')
xlabel('Time')
ylabel('Volume')
title(['Quote and trade volumes of ', obj.RIC, ' on ', Date])
vlegend = legend([avol, bvol, tvol], 'Ask Volume', 'Bid Volume', 'Trade Volume');
set(vlegend, 'color', [.5 .5 .5])


