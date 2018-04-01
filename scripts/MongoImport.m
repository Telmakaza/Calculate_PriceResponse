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

parfor j = 1
    
    % Import file into database
    
    exStr = ['mongoimport -d BRICSData -c JSETransactions --type csv --file',...
        ' ' filenames{j}, ' ', '--headerline'];
    
    dos(exStr)
     
    
end

%% Return to original directory

cd(OldFolder)



profile viewer