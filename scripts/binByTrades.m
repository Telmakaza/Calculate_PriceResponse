%% Script for binning stocks by number of trades
%
% Author: E.Nonyane
% Date: 23-Jun-2017

%% Clear workspace
clc
clear
close all

%% Configure paths

addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Classes');
addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\functions');

%% Load data

load('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\JSE\JSE_2010_to_2016')


%% Calculate the mean number of trades for each stock

n = numel(Stocks);

meanNumTrades = zeros(n,3);
meanNumTrades(:,1) = 1:43; % Keeps track of the stock

for i = 1:n
    meanNumTrades(i,2) = mean(Stocks(i).Tradesperday);
end

%% Bucket Stocks by number of trades

meanNumTrades = sortrows(meanNumTrades,2);

meanNumTrades(1:21,3) = 1;
meanNumTrades(22:32,3) = 2;
meanNumTrades(33:40,3) = 3;
meanNumTrades(41:43,3) = 4;

meanNumTrades = sortrows(meanNumTrades,1);

binidx = meanNumTrades(:,3);

