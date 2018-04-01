
%% Configure paths

addpath('C:\Users\QuERILab\Documents\MATLAB\ENonyane_PR\Classes');
addpath('C:\Users\QuERILab\Documents\MATLAB\ENonyane_PR\Functions');

%% Visualise the number of classified trades per days

Market = 'BSE';

for Year = 0:6
    
    % Clear workspace
    clear Stocks ADV 
    close all
    
    % Load data
    filePath = ['C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\',Market,'\SingleStocks\'];
    fileName = [Market,'1Y201',num2str(Year),'.mat'];
    fullFileName = [filePath,fileName];
    load(fullFileName);


    for i = 1:6
        figure(i)
        hold on
    end

%Stocks(14:15) = [];

    for i = 1:numel(Stocks)
        ADTV(i) = mean(Stocks(i).ADTVolume);
    end

    ADTV(ADTV==0) = nan;

    [~,a] = min(ADTV);
    [~,b] = max(ADTV);

    for j = [a b]

        if ~isempty(Stocks(j).SPIM) || 1
        
            switch j
                case a
                    C = 'b';
                    Leg = [Stocks(a).RIC,' (Lowest ADV)'];
                case b
                    C = 'r';
                    Leg = [Stocks(b).RIC,' (Highest ADV)'];
            end
        
            PriceResponse.Plot_PR(Stocks(j),C,Leg)
        
%         % Calculate the Beta and Lambda constants
%         buyerOmega = Stocks(j).BPIM(:,1);
%         dPB = Stocks(j).BPIM(:,2);
%         
%         % Perform linear regression in different regions of w
%         % Region All
%         nn = length(Stocks(j).BPIM);
%         X = [-ones(nn,1) log(buyerOmega)];
%         Y = log(dPB);
%         beta = X\Y;
%         Stocks(j).BetaAll = beta(2);
%         Stocks(j).Lambda = exp(beta(1));
%         
%         % Region 1
%         Y1 = Y(X(:,2)<=10^(-1));
%         X1 = X(X(:,2)<=10^(-1),:);
%         
%         beta = X1\Y1;
%         Stocks(j).BetaR1 = beta(2);
%         
%         % Region 2 
%         Y2 = Y(X(:,2)>10^(-1));
%         X2 = X(X(:,2)>10^(-1),:);
%         
%         beta = X2\Y2;
%         Stocks(j).BetaR2 = beta(2);
%         
%         % Claculate the cost of a market order
%         Stocks(j).mOrderCost = Stocks(j).G0(end)/Stocks(j).G0(1);
        end
    
    end

    for i = [1 4:6]
        figure(i)
        set(gca,'xscale','log')
        set(gca,'yscale','log')
        box on
        legend('show')
    end



    for i = 2:3
        figure(i)
        set(gca,'xscale','log')
        box on
        legend('show')
    end

%close all

% figure(7)
% hold on
% 
% clear x
% clear y
% % for j = [1:30]
% %     
% %     ADTV = Stocks(j).ADTVolume;
% %     ADTV(ADTV==0) = [];
% %     
% %     x(j) = sum(ADTV);
% %     y(j) = Stocks(j).Lambda;
% %     %plot(sum(Stocks(j).ADTVolume),Stocks(j).Lambda,'-s b')
% % end
% x(x==0) = [];
% y(y==0) = [];
% 
% loglog(x,y,'s b')
% set(gca,'xscale','log')
% set(gca,'yscale','log')
% box on
% 
% 
% figure(8)
% hold on
% clear Cost
% for j = 1:30
%     
%     Cost(j) = Stocks(j).mOrderCost;
%     
% end
% 
% Cost(Cost==0) = [];
% 
% 
% 
% loglog(Cost,x,'s')

end
