%% indexCandlePlot 
% This script constructs canple plots of an index from end of day data
% Author: E.Nonyane
% DAte: August 05, 2017

%% Clear workspace

clc
clear
close all

%% Configure paths

addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\functions')

%% Set initial parameters

% Specify start and end dates
startDate = '01-Jan-2010';
endDate = '31-Dec-2010';
[dailydates] =...
    upper(cellstr(datestr(datenum(startDate):1:datenum(endDate))));

% Specify market parameters
Market = 'ESE';
Collection = [Market,'Transactions'];
RIC = '.EGX30';
transff = 'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\MongoExp\idxff.csv';

% Initialise end of day matrix
n = numel(dailydates);
EODMatrix = zeros(4,n);

parfor i = 1:n
    tempCSV = ['C:\JobData\enonyane\idxTempData\',Market,num2str(i),'.csv'];
    EODMatrix(:,i)= extractEODData(Collection,RIC,dailydates{i},tempCSV,transff);
end

EODMatrix(:,~any(EODMatrix)) = [];

H = EODMatrix(1,:);
L = EODMatrix(2,:);
O = EODMatrix(3,:);
C = EODMatrix(4,:);

% Construct candle plots
cndl(H,L,O,C)

% Set the background color of plot
set(gca,'Color',[0.8 0.8 0.8])
%datetick('x','mmm','keeplimits')
hold on
% Calculate the moving avarage
C(isnan(C)) = 0;
MA20 = calMovingAV(C(~isnan(C)),20);
nDays = numel(C);
MA20Plot = plot(21:nDays,MA20,'linewidth',2);

% Change plot properties to what we disire
% h = gcf;
% axisObjects = get(h,'children');
% 
% considerdMonths = {'Aug 2015','Sep 2015', 'Oct 2015', 'Nov 2015',...
%     'Dec 2015', 'Jan 2016', 'Feb 2016', 'Mar 2016',...
%     'Apr 2016','May 2016', 'Jun 2016'};
% 
% for i = 1:11
%     axisObjects.XTickLabel(i,1:3) = considerdMonths(i);
% end
grid on

% Change grid color
ylabel('Value of index','fontsize',15)
xlabel('Trading day','fontsize',15)
title(['Candlestick chart of the EGX30', ' index for the 2010 financial year'],'fontsize',15)
legendHandle = legend(MA20Plot,'20 Day Moving Avarage');
legendHandle.Color = 'w';
box on

% Adjust Legend setting