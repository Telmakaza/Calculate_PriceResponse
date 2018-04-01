%% calibPriceResponse: calibrates price response parameters
% Author: E. Nonyane
% Date: August 30, 2017

%% Clear workspace
clc
clear

%% Configure paths

addpath('C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\Classes');
addpath('C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\functions');

%% Load data

Market = 'BSE';
dataFilePath = ['C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\Market Information\',Market,'\GroupedStocks2\'];
fullFileName = [dataFilePath,'groupedStocks'];
load(fullFileName);

%% Calculate price response parameters
n = numel(groupedStocks);

tic
for j = 1:n
    groupedStocks(j) = groupedStocks(j).calibPR;
end
toc