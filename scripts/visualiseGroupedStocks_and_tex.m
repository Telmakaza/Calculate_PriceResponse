%% visualiseGroupedStocks_and_tex
% Author: E. Nonyane
% Date: September 10, 2017

%% Clear workspace
clc
clear
close all
%% Configure paths

addpath('C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\Classes')

%% Set initial parameters and plot results
Market = 'BVSP';
YEARS = {'2010','2011','2012','2013','2014', '2015', '2016'};

for y  = 1:7
    
    Year = YEARS{y};
    close all
    
    filePath = 'C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\Market Information\';
    fullFile = [filePath,Market,'\groupedStocksForTex\','G',Market,Year];
    
    % Import data
    load(fullFile)
    
    % plot results
    
    for i = 1:6
        figure(i)
        hold on
        hold all
        box on
    end
    
    for i = 1:3
        
        switch i
            case 1
                C = 'r';
                legendStr = 'Low';
            case 2
                C = 'g';
                legendStr = 'Med';
            case 3
                C = 'b';
                legendStr = 'High';
        end
        
        if strcmp(Year,'2016')
            dateString = ['Jan ', Year, ' to May ', Year];
        else
            dateString = ['Jan ', Year, ' to Dec ', Year];
        end
        PriceResponse.Plot_PR(gStocks(i),C,dateString)
        
    end
    
    l = cell(6,1);
    
    for i = [1 4 5 6]
        figure(i)
        set(gca, 'xscale', 'log')
        set(gca, 'yscale', 'log')
        l{i} = legend('Low ADV group', 'Medium ADV group', 'High ADV group');
    end
    
    for i = [2 3]
        figure(i)
        set(gca, 'xscale', 'log')
        l{i} = legend('Low ADV group', 'Medium ADV group', 'High ADV group');
    end
    
    for i = [5 6]
        l{i}.Location = 'southeast';
    end
    
    % Save figures as pdfs
    disPath = 'C:\Users\MSS_Master\Desktop\Thesis\';
    priceResFun = {'CL','RL','DL','G0L','BPI','SPI'};
    for i = 1:6
        F = figure(i);
        %saveas(F,[disPath,Market,'Results\',Year,'G\',Market,priceResFun{i},Year,'.pdf']);
    end
end
