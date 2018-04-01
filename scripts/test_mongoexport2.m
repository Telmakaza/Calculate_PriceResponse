clc
clear
addpath('C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\functions');
ticker = 'JTOPI';
collection = 'JSETransactions';
startDate = '04-Jan-2010'; 
endDate = '04-Jan-2010';
startTime = '09:00:00.000';
endTime = '15:00:00.000';
startDateTime = [startDate, ' ', startTime]; 
endDateTime =  [endDate, ' ', endTime];
tempcsvout = 'C:\Users\ENonyane\Documents\MATLAB\tout.csv';
fieldFile = 'C:\Users\ENonyane\Documents\MATLAB\ff.csv';

tic
data = extractfromMongoDBcsvPR2(ticker, collection, startDateTime, endDateTime, tempcsvout, fieldFile);
toc