%% JSE EDA: EDA for JSE transaction data
% Author: E.Nonyane
% Date: September 19, 2017

%% Clear workspace

clc
clear
close all


%% Configure paths

addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Classes')

%% Set initial parameters and load data

Market = 'MOEX';
Year = {'2010', '2011', '2012', '2013', '2014', '2015', '2016'};
datapath = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\';

%figure(1)
%hold on

for k = 1:30
    for j = 1:7
    
        fullFile = [datapath, Market,'\SingleStocks\',Market,'1Y',Year{j}];
        load(fullFile)
        T = Stocks(k).tradesPerDay;
        T(T==0) = [];
    
    
        if j==1
            c = 0;
        else
            c = c + n;
        end
    
        n = numel(T);
    
        ntrades(c+1:n+c) = T;
    
    end
    
    figure(k)
    plot(ntrades)
end



