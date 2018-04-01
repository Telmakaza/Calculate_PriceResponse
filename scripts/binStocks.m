%% Create ADTV bins
% This script divides stocks into five different groups (ordered by ADTV)
%
% Author: E.Nonyane
% Date: 30-06-2017

%% Clear workspace
%clc
%clear
%close all

%% Configure paths

addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Classes');
addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\functions');

%% Load data

load('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\JSE\JSE6Y')

%clearvars -except Stocks

%% Extract the ADTV of each stock

n = numel(Stocks);

m = 25; % The number of three months in 1587 days

ADTV = zeros(n,m);

for j = 1:m
    for i = 1:n
        if numel(Stocks(i).ADTValue) ~= 2319
            ADTV(i,j) = nan;
        else
            if j == 1
                ADTV(i,j) = mean(Stocks(i).ADTVolume(1:90));
            elseif j~=1 && j<17
                ADTV(i,j) = mean(Stocks(i).ADTVolume((j-1)*90+1:j*90));
            else 
                ADTV(i,j) = mean(Stocks(i).ADTVolume((j-1)*90+1:end));
            end
        end
    end
end

%% Bin stocks by ADTV

binEdges = zeros(1,5);
binidx = zeros(n,m); % Bin index for each stock for each three months

for k = 1:m
    for i = 1:5
        binEdges(i) = quantile(ADTV(:,k),i/5);
    end
    
    binidx(:,k) = PriceResponse.binData(ADTV(:,k),binEdges);
    
end