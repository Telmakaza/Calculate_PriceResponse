%% Clear
clc
clear


%% Configure paths

profile on

% Store current directory
OldFolder = pwd;

% Change current directory to data files directory

datafilepath = 'C:\ZMarket Data';

addpath('C:\Users\Administrator\Desktop\Edward\MATLAB\functions');
addpath(datafilepath)

cd(datafilepath)

%% Extract the data file names

datafiles = dir(datafilepath);
datafiles = datafiles(~ismember({datafiles.name},{'.','..'}));
filenames = {datafiles.name};

%% Import file to MongoDB

% Unzip datafile
N = numel(filenames);

parfor j = 1:N
    
    % Import file into database
    
    exStr = ['mongoimport -d BRICSData -c BVSPTransactions --type csv --file',...
        ' ' filenames{j}, ' ', ' --ignoreBlanks  --fields "#RIC,Date[G],Time[G],GMT Offset,Type,x/Cntrb.ID,Price,Volume,Market VWAP,Buyer ID,Bid Price,Bid Size,No. Buyers,Seller ID,Ask Price,Ask Size"'];
    
    dos(exStr)
     
    
end

%% Return to original directory

cd(OldFolder)



profile viewer