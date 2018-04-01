%% importMongoDatanative: imports exchange rate data into native database
% Author: E. Nonyane
% Date: September 19, 2017

%% Clear workspace
clc
clear
close all


%% Configure paths

% Store current directory
OldFolder = pwd;

% Change current directory to data files directory
datafilepath = 'C:\Users\MSS_Master\Documents\Download Tick Data';
cd(datafilepath)

%% Extract the data file names

datafiles = dir(datafilepath);
datafiles = datafiles(~ismember({datafiles.name},{'.','..'}));
filenames = {datafiles.name};

%% Import file to MongoDB

% Unzip datafile
N = numel(filenames);

for j = 1:N
    
    % Import file into database
    
    exStr = ['mongoimport -d ExchangeRates -c EURUSD --type csv --file',...
        ' ' filenames{j}, ' ', ' --ignoreBlanks  --fields "Rate,DateTime,Bid Price,Ask Price"'];
    
    dos(exStr)
     
    
end

%% Return to original directory

cd(OldFolder)

