
%% Configure paths

addpath('C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\Classes');
addpath('C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\Functions');

%% Clear Workspace
clc
clear

%% Visualise the number of classified trades per days

Market = 'BVSP';

for Year = 6
    
    % Clear workspace
    clear Stocks ADTV 
    close all
    
    if Year~=6
        dateString = ['Jan 201',num2str(Year),' to ', 'Dec 201',num2str(Year)];
    else
        dateString = 'Jan 2016 to May 2016';
    end
    
    %dateString = 'Jan 2010 to May 2016';
    
    % Load data
    filePath = ['C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\Market Information\',Market,'\SingleStocks\'];
    fileName = [Market,'1Y201',num2str(Year),'.mat'];
    fullFileName = [filePath,fileName];
    load(fullFileName);

    for i = 1:6
        figure(i)
        hold on
    end

    switch Market
        case 'JSE'
            Stocks(14:15) = [];
    end
    
    for k = numel(Stocks):-1:1
        if isempty(Stocks(k).BPIM)
            Stocks(k) = [];
        end
    end

    for i = 1:numel(Stocks)
        ADTV(i) = mean(Stocks(i).ADTValue);
    end

    ADTV(ADTV==0) = [];
    
    
    for ii = 1:3
        binEdges(ii) = quantile(ADTV,ii/3);
    end
    
    binidx = PriceResponse.binData(ADTV,binEdges);

    
    N = numel(ADTV);
    

    for j = 1:N-1

        if ~isempty(Stocks(j).SPIM) 
        
            switch binidx(j)
                case 1
                    C = 'r';
                    
                case 2
                    C = 'g';
                    
                case 3
                    C = 'b';
                
            end
        
            PriceResponse.Plot_PR(Stocks(j),C,dateString)
            
            if strcmp(Market,'MOEX')
                figure(7)
                hold on
                loglog(Stocks(j).BV,Stocks(j).dPB,'.','markersize',.3,'Color',C)
            end
        
        end
    
    end

    for i = [1 4:6]
        figure(i)
        set(gca,'xscale','log')
        set(gca,'yscale','log')
        box on
        %legend('show')
    end
    
    for i = [5 6]
        figure(i)
        
    end
    

    
    
    % Save figures as pdf documents
    thesisPath = 'C:\Users\MSS_Master\Desktop\Thesis\';
    priceResFun = {'CL','RL','DL','G0L','BPI','SPI'};
    fullYear = ['201',num2str(Year)];
    
    
    figure(4)
    %xlim([0 100])
    set(gca,'xscale','lin')
    set(gca,'yscale','lin')
    
    %figure(1)
    %xlim([0 100])
    
    
   
    for i = 1:7
        figure(i)
        set(gca,'xscale','log')
        set(gca,'yscale','log')
        Map = [1 0 0; 0 1 0; 0 0 1];
        colormap(Map)
        colorbar
        %c = colorbar( 'Ticks',[0.33 0.67 1],'TickLabels', {'Low', 'Med', 'High'});
        %c.Label.String = 'ADV';
    end
    
    
    for i = 2:3
        figure(i)
        set(gca,'xscale','log')
        set(gca,'yscale','lin')
        box on
        
    end
    
    for i = 1:6
        F(i) = figure(i);
        %saveas(F(i),[thesisPath,Market,'Results\',num2str(fullYear),'\',Market,priceResFun{i},num2str(fullYear),'.pdf']);
        %saveas(F(i),[thesisPath,Market,'Results\6Year\',Market,priceResFun{i},num2str(fullYear),'.pdf']);
    end

end
