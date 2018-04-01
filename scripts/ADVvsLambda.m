%% ADvsLambda - Plot the ADV of a group of stocks aginst their ADV
% Author: E. Nonyane
% Date: August 27, 2017

%% Plot ADV vs Liquidity

% Input Market string
Market = 'BSE';

% Construct loading string
dataPath = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\';
fileName = [dataPath,Market,'\SingleStocks\',Market,'1Y2010'];
load(fileName);
n = numel(Stocks);

% Clear stocks with no required data
for i = n:-1:1
    if isempty(Stocks(i).BPIM)
        Stocks(i) = [];
    end
end

% Claculate liquidity
n = numel(Stocks);

Liq = zeros(n,1);
ADV = zeros(n,1);

for i = 1:n
    PriceResponse.calBetaLambda(Stocks(i));
    Liq(i) = Stocks(i).Lambda;
    ADV(i) = mean(Stocks(i).ADTVolume);
end

close all
loglog(ADV,Liq,'*')
disp(corrcoef(ADV,Liq))