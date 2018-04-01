% Clear workspace
clc
clear

% Change current directory to data files directory
datafilepath = 'C:\ZMD';
cd(datafilepath)

% Extract data file names
datafiles = dir(datafilepath);
datafiles = datafiles(~ismember({datafiles.name},{'.','..'}));
filenames = {datafiles.name};

% Import file to MongoDB
N = numel(filenames); % Number of csv files

% Loop over files
for j = 1:N

    % Construct data importation execution string    
    exStr = ['mongoimport -d BRICSData -c NSETransactions --type csv --file',...
        ' ' filenames{j}, ' ', ' --ignoreBlanks  --fields "#RIC,Date[G],Time[G],GMT Offset,Type,Price,Volume,Market VWAP,Bid Price,Bid Size,Ask Price,Ask Size"'];
    
	% Execute execution string
    dos(exStr)
end



