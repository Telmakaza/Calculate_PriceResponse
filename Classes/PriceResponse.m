classdef PriceResponse < handle
    % PriceResponse -  Class defenition for price response objects.
    % This class can be used to calculate the price response of stocks from
    % interday transaction data. It attempts to encapsulate the data and
    % methods used to calculate the bare impact and price impact of stocks
    % Initialise as: PriceResponse() or PriceResponse(Tickers). Where
    % 'Tickers' is a cell arrays of stock RICs
    
    %% Class attributes
    properties
        RIC % Stock's Reuters Intrument Code
        Tradesign  % Trade direction: +1 represents a buyer initiated trade
        % and -1represents a seller initiated trade
        Tradedate % Date of transactions
        Tradevolume % Transaction volume
        Midquote  % Mid-quote before the nth trade
        data % Dataset
        data2 % Second dataset
        dlogp  % Log price change
        v  % Volume associated with price chance
        Tradesperday % Number of classified trades per day
        CL % Autocorrelation of trade signs
        RL % Price response coeeficient
        G0
        DL % Mean squared displacement of the price
        CLV % CL1 mean of ts1.*ts2.log(V)
        BPIM % Buyer Price Impact Matrix
        SPIM % Seller Price Impact Matrix
        BV % Transacted volume of buyer initiated trades
        dPB % Price change caused by buyer initiated trades
        SV % Transacted volume of seller initaited trades
        dPS % Price change caused by seller initiated trades
        NB % Number of data points in buyer volume bins
        NS % Number of data points in seller volume bins
        TB % Time of buyer initiated trades 
        TS % Time of seller initiated trades
        binSpacing % Bin spacing for price impact 
        ADTValue % Average daily traded value
        ADTVolume % Average daily traded volume
        ADVolatility % Average daily volatility
        AVSpread % Average spread
        Liq % Some liquidity 
        liquidityIndex % A liquidity index
        J % Value of objectfunction
        CBPIM % Collapsed buyer price impact
        normMarketCap % The normalized market capitalisation of the stock
        Market
        Analysis % Type of analysis. It could be single or grouped stock anaysis
        BetaR1
        BetaR2
        BetaAll
        Lambda
        LambdaR2
        mOrderCost
        tradesPerDay % number of trades per day
        Gamma0
        L0
        G0Beta
        C0
        C0Gamma
        
    end
    
    %% Class precedures
    methods
        
        %% PriceRespnse constructure method
        function obj = PriceResponse(Tickers,Spacing,Mkt)
            % INPUTS:
            %--------------------------------------------------------------
            % Tickers - Cell array of stock RICs
            %
            %--------------------------------------------------------------
            % OUTPUT:
            %--------------------------------------------------------------
            %   obj - PriceResponse object
            %
            %--------------------------------------------------------------
            
            if nargin~=0
                n = numel(Tickers);
                obj(n) = PriceResponse;
                for j = 1:numel(Tickers)
                    obj(j).RIC = Tickers{j};
                    obj(j).binSpacing = Spacing;
                    obj(j).Market = Mkt;
                end
            end
            
            
        end
        
        %% Data extraction algorithm from D.Hendricks et al 2017
        function  extractfromMongoDBcsvPR(varargin)
            
            %extractfromMongoDB extracts order book data from a MongoDB database
            %
            % INPUTS:
            % ----------------------------------------------------------------------------------------------------------------------------
            %  Username                 (1xk) char          MongoDB username (see QuERILab administrator)
            %
            %  Password                 (1xk) char          MongoDB password (see QuERILab administrator)
            %
            %  Market                   (1xk) char          Geographical market considered.
            %                                               ['JSE', 'BSE', 'BOVESPA']
            %  Collection               (1xk) char          Collection in TickData to extract from.
            %                                               ['Transactions','MarketDepth']
            %  RIC                      (1xk) char          Reuters instrument code.
            %                                               [e.g. 'AGLJ.J', 'SBKJ.J']
            %  StartDateTime            (1xk) char          Start date of period to extract (date and time).
            %                                               [e.g. '2012-05-09 10:00]
            %  EndDateTime              (1xk) char          End date of period to extract (date and time).
            %                                               [e.g. '2012-05-09 10:15']
            %  tempCSVoutput            (1xk) char          Filepath for temporary CSV file for Mongo output
            %                                               [e.g. 'D:\mongoOutput.csv']
            %  transactionsFieldFile    (1xk) char          Filepath for text field file for Transactions data
            %                                               [e.g. 'D:\mongoTransactionsFieldFile.txt']
            %
            % OUTPUTS:
            % ----------------------------------------------------------------------------------------------------------------------------
            %   data                    (nxm) cell          All data returned as one contiguous cell matrix
            %   headers                 (1xm) cell          Column headers (fields) for each column in data cell matrix
            %
            % EXAMPLE:
            % ----------------------------------------------------------------------------------------------------------------------------
            % [data, headers] = extractmongodatanative('JSE','Transactions','MTNJ.J','2012-05-09 10:00','2012-05-09 10:15','D:\mongoOutput.csv','D:\mongoTransactionsFieldFile.txt','D:\mongoMarketdepthFieldFile.txt');
            % [data, headers] = extractmongodatanative('JSE','Transactions','MTNJ.J','2012-05-09 10:00','2012-05-09 10:15','E:\MATLAB\mongoOutput.csv','G:\FieldFiles\mongoTransactionsFieldFile.txt','G:\FieldFiles\mongoMarketdepthFieldFile.txt');
            %
            
            
            
            
            % Specify field file for mongoexport 
            obj = varargin{1};
            Collection  = varargin{2};
            Date = varargin{3};
            tempCSVoutput = varargin{4};
            fieldFile = varargin{5};
           
            % Obtain the stock RIC
            ric = obj.RIC;
                    
             %'--host 146.141.56.152 --port 27017 ', ...
                %'--authenticationDatabase BRICSData ',...
                %'-u enonyane ',...
                %'-p q3r1 ',...
            
            % Construct the execution string for mongoexport
            [executionString] = ['"mongoexport.exe" ' ...,
                '-d BRICSData ', ...
                '-c ', Collection, ' ' ...
                '-q ', ...
                '"{''#RIC'': ''', ric, ''', ''Date[G]'': ''' Date ''' }" ', ...
                '--type=csv ', ...
                '--fieldFile ', ...
                '"', fieldFile, '" ', ...
                '--out ', ...
                '"', tempCSVoutput, '"'];
            % Execute mongoexport, data stored temporarily on disk in CSV file
            
            dos(executionString,'-echo');
            
            % Read CSV file into MATLAB workspace, remove extraneous quotations in
            % string columns
            
            switch nargin
                case 5
                    tempData = textscan(fopen(tempCSVoutput),'%q %q %q %q %q %q %q %q','delimiter', ',' ,'headerlines',1);
                case 6
                    tempData = textscan(fopen(tempCSVoutput),'%q %q %q %q %q %q %q %q %q %q','delimiter', ',' ,'headerlines',1);
            end
            
            
            temp = str2double(cat(2,tempData{5:end}));
            
            temp(isnan(temp)) = 0;
            
            Data = [cat(2,tempData{1:4}),num2cell(temp)];
            
            % Delete temporary CSV file
            fclose('all');
            delete(tempCSVoutput);
            obj.data = Data;
            
            if isempty(obj.data)
                if isempty(obj.ADTValue)
                    c = 0;
                else 
                    c = numel(obj.ADTValue);
                end
                obj.ADTValue(c+1) = 0;
                obj.ADTVolume(c+1) = 0;
                obj.ADVolatility(c+1) = 0;
                obj.AVSpread(c+1) = 0;
                obj.liquidityIndex(c+1) = 0;
                obj.tradesPerDay(c+1) = 0;
            end
            
        end
        
        %% Data cleaning
        function CleanCompt(varargin)
            %CleanCompt cleans and compacts data according to some specification
            %documet
            %
            % INPUT:
            %--------------------------------------------------------------------------
            % data: Cell array of level one order book data
            %
            % OUTPUT:
            %--------------------------------------------------------------------------
            % CCdata: Cell array of cleaned and compacted order book data
            
            obj = varargin{1};
            
            % Remove Auctions
            obj.data(strcmp(obj.data(:,4),'Auction'),:) = [];
            obj.data(strcmp('',obj.data(:,1)),:) = [];
            
            % Romove events outside of the contious double aution trading
            % period
            
            switch obj.Market
                case 'JSE'
                    STime = '07:10:00.000';
                    ETime = '14:50:00.000';
                    
                case 'BSE'
                    STime = '03:55:00.000';
                    ETime = '09:50:00.000';
                    
                case 'BVSP'
                    STime = '12:10:00.000';
                    ETime = '18:45:00.000';
                    
                case 'ESE'
                    STime = '08:10:00.000';
                    ETime = '12:20:00.000';
                    
                case 'MOEX'
                    STime = '07:10:00.000';
                    ETime = '15:29:00.000';
                    
                case 'NSE'
                    STime = '06:40:00.000';
                    ETime = '11:50:00.000';
                    
                case 'SSE'
                    STime = '01:40:00.000';
                    ETime = '03:20:00.000';
                    
                    STime2 = '05:10:00.000';
                    ETime2 = '06:50:00.000';
            end
            
            
            
            
            
            if strcmp(obj.Market,'SSE')
                
                % Convert the start and end times into date numbers
                STime = datenum(STime);
                ETime = datenum(ETime);
                
                STime2 = datenum(STime2);
                ETime2 = datenum(ETime2);
                
                
                % Convert all of the evnt times into date numbers
                obj.data(:,3) = num2cell(datenum(obj.data(:,3)));
                
                %----------------------------------------------------------
                
                %---------------Session 1 data cleaning-------------------
                
                
                % Clean trade sesssion 1 data
                tempDataSet1 = obj.data;
                
                % Extract event times
                eventTimes = [tempDataSet1{:,3}]';
                
                % Clear data from 10 minutes just after opening (in ses 1)
                tempDataSet1(eventTimes<STime,:) = [];
                
                % Update event times
                eventTimes =[tempDataSet1{:,3}]';
                
                %  Clear data 10 minutes before closing in ses 1
                tempDataSet1(eventTimes>ETime,:) = [];
                
                % Create an index for all session 1 data
                tradeSessionIndex1 = ones(size(tempDataSet1,1),1);
                
                %----------------------------------------------------------
                
                %---------------Session 2 data cleaning--------------------
                
                % Clear trade session 2 data
                tempDataSet2 = obj.data;
                
                % Update event times
                eventTimes = [tempDataSet2{:,3}]';
                
                % Clear data 10 from 10 minutes after opening in ses 2
                tempDataSet2(eventTimes<STime2,:) = [];
                
                % update event times
                eventTimes = [tempDataSet2{:,3}]';
                
                % Clear data from 10 minutes before clossing in ses 2
                tempDataSet2(eventTimes>ETime2,:) = [];
                
                % Create an index for session 2 data
                tradeSessionIndex2 = 2*ones(size(tempDataSet2,1),1);
                
                
                %----------------------------------------------------------
                
                
                % Reconstrcut the data cell
                obj.data = [tempDataSet1;tempDataSet2];
                
                % Make an index to track trades of the two different trade
                % periods
                tradeSessionIndex = [tradeSessionIndex1;tradeSessionIndex2];
                obj.data = [obj.data, num2cell(tradeSessionIndex)];
                
                
            else
                % Convert start and end dates into date numbers
                STime = datenum(STime);
                ETime = datenum(ETime);
                
                % Convert all the event times into date numbers
                obj.data(:,3) = num2cell(datenum(obj.data(:,3)));
                
                % Extract the trade times
                eventTimes = [obj.data{:,3}]';
                
                % Clear events 10 minutes after opening
                obj.data(eventTimes<STime,:) = [];
                
                % Update event times
                eventTimes = [obj.data{:,3}]';
                
                % Clear events 10 minutes before closing
                obj.data(eventTimes>ETime,:) = [];
                
                % Create an index for all of the session one events
                tradeSessionIndex = num2cell(ones(size(obj.data,1),1));
                
                % Reconstruct the data cell
                obj.data = [obj.data, tradeSessionIndex];
            end
            
            
            % Separate quotes from trades
            dataQ = obj.data(strcmp(obj.data(:,4),'Quote'),:);
            dataT = obj.data(strcmp(obj.data(:,4),'Trade'),:);
            
            
            % Pull down quotes
            if ~isempty(dataT) && ~isempty(dataQ)
                
                switch nargin
                    
                    case 1
                        
                        for i = 2:size(dataQ,1)
                            if dataQ{i,7} == 0
                                dataQ{i,7} = dataQ{i-1,7};
                            elseif dataQ{i,8} == 0
                                dataQ{i,8} = dataQ{i-1,8};
                            end
                        end
                        
                    case 2
                        
                        for i = 2:size(dataQ,1)
                            
                            for Column = 7:10
                                if dataQ{i,Column} == 0
                                    dataQ{i,Column} = dataQ{i-1,Column};
                                end
                            end  
                        end
                end
                        
                
                % Extract the quote times
                quoteTimes = [dataQ{:,3}]';
                
                % Get list of quotes with unique timestamp
                [~,uniquerowindex] = unique(quoteTimes,'last');
                
                % Compact quotes
                dataQ = dataQ(uniquerowindex,:);
                
                
                % Clean nonsensical quotes and trades
                dataQ(cell2mat(dataQ(:,7))<=0,:) = [];
                dataQ(cell2mat(dataQ(:,8))<=0,:) = [];
                dataT(cell2mat(dataT(:,6))<=0,:) = [];
                
                if ~isempty(dataT) && ~isempty(dataQ)
                    
                    % Get trade timestamps
                    tradesTimes = [dataT{:,3}]';
                    
                    %Trades = eventTimes(strcmp(obj.data,'Trades'));
                    
                    %-----------------------------------------------------%
                    
                    % VWAP compact trades with the same timestamp
                    col5Prices = cell2mat(dataT(:,5));
                    col6Vols = cell2mat(dataT(:,6));
                   
                    % Loop over trades
                    for j = 1:numel(tradesTimes)
                        P = col5Prices(tradesTimes == tradesTimes(j));
                        Q = col6Vols(tradesTimes == tradesTimes(j));
                        dataT{j,5} = P'*Q/sum(Q);
                        dataT{j,6} = sum(Q);
                    end
                    
                    %-----------------------------------------------------%
                    
                    % Remove trades with the same timestamp
                    [~,utindex] = unique(tradesTimes,'first');
                    
                    dataT = dataT(utindex,:);
                    
                    % Replace raw data with clean data
                    obj.data = sortrows([dataT;dataQ],3);
                    
                    % Extract the trade price and volume
                    priceVolMat = cell2mat(dataT(:,5:6));
                    
                    for k = 1:2
                        priceVolMat(priceVolMat(:,k)==0,:) = [];
                    end
                    
                    tradePrice = priceVolMat(:,1);
                    tradeVolume = priceVolMat(:,2);
                    
                    % Extract the bid and ask price
                    Bid_Ask = cell2mat(obj.data(:,7:8));
                    
                    for k = 1:2
                        Bid_Ask(Bid_Ask(:,k)==0,:) = [];
                    end
                    
                    bidPrice = Bid_Ask(:,1);
                    askPrice = Bid_Ask(:,2);
                    
                    % Populate the ADTV and data properties
                    
                    c = obj.ADTValue;
                    %c = c(c~=0);
                    
                    if isempty(c)
                        c = 0;
                    else
                        c = numel(c);
                    end
                    
                    if isempty(tradeVolume)
                        obj.ADTValue(c + 1) = 0;
                    else
                        
                        totalVolume = sum(tradeVolume);
                        totalValue = tradePrice'*tradeVolume;
                        averageSpread = mean((askPrice - bidPrice)./askPrice);
                        
                        % Count the number of trades per day
                        obj.tradesPerDay(c+1) = numel(tradeVolume);
                        
                        obj.ADTValue(c+1) = totalValue;
                        obj.ADTVolume(c+1) = totalVolume;
                        obj.ADVolatility(c + 1) = sqrt(sum(log(tradePrice(2:end)./tradePrice(1:end-1)).^2));%*sqrt(numel(tradePrice));
                        obj.AVSpread(c+1) = averageSpread;
                        
                        avgNormVolume = mean(tradeVolume/mean(tradeVolume));
                        avgNormValue = mean(tradePrice.*tradeVolume/mean(tradePrice.*tradeVolume));
                        
                        % Creat liquidity index
                        obj.liquidityIndex(c+1) =  (averageSpread^-1)/100 + avgNormVolume + avgNormValue;
                    end
                    
                end
                
             else 
                    
                 c = obj.ADTValue;
                    
                 if isempty(c)
                     c = 0;
                 else
                     c = numel(c);
                 end
                    
                 obj.ADTValue(c+1) = 0;
                 obj.ADTVolume(c+1) = 0;
                 obj.ADVolatility(c+1) = 0;
                 obj.AVSpread(c+1) = 0;
                 obj.liquidityIndex(c+1) = 0;
                
            end  
            
        end
        
        %% Trade Classification Algorithm from Lee and Ready 1991
        function Classf(obj)
            %Classf - Classf classifies trades as either buyer
            % intitaited or seller initiated
            %
            % INPUTS:
            %----------------------------------------------------------
            %
            %   obj: A PriceResponse object
            %
            %----------------------------------------------------------
            % OUTPUTS:
            %----------------------------------------------------------
            % ts: A vector of trades directions with +1 representing a
            % buyer initiated trade and -1 a seller initiated trade
            %
            %----------------------------------------------------------
            
            r = size(obj.data,1);
            
            % Initialise trade signs and dates vector
            ts = zeros(r,1);
            mn = zeros(r,1);
            vl = zeros(r,1);
            dp = zeros(r,1);
            dpb = dp;
            dps = dp;
            buyerv = dp;
            sellerv = dp;
            pitimes = dp;
            pitimeb = dp;
            T = dp;
            tradeSesIdx = cell2mat(obj.data(:,9));
            
            lastclass = 0;
            %lastmidq = 0;
            
            
            if ~isempty(obj.data)
                for j = 2:r
                    % Quote Rule
                    if strcmp(obj.data{j,4},'Trade') && strcmp(obj.data{j-1,4},'Quote') && ...
                            ( obj.data{j-1,8}~=0 && ...
                            obj.data{j-1,7}~=0) && obj.data{j,9} == obj.data{j-1,9} && ... % This ensures that we are using information from 1 trading session
                            3*obj.data{j,5} > ( obj.data{j-1,7} + obj.data{j-1,8})/2 % Ensures that we dont classify trades using anomalous quotes
                        
                        if .5*(obj.data{j-1,7} + obj.data{j-1,8}) < obj.data{j,5}
                            ts(j) = 1;
                            lastclass = 1;
                        elseif .5*(obj.data{j-1,7} + obj.data{j-1,8}) > obj.data{j,5}
                            ts(j) = -1;
                            lastclass = -1;
                        end
                        
                        % Tick Rule
                    elseif lastclass ~=0 && any(strcmp(obj.data{j,4},'Trade')...
                            & strcmp(obj.data{j-1,4},'Trade')) && obj.data{j,9} == obj.data{j-1,9} && ... % This ensures that we compare events in the same trading session
                            3*obj.data{j,5} > ( (obj.data{j-1,7} + obj.data{j-1,8})/2 ) % Ensures that we dont classify trades using anomalous quotes
                        
                        if obj.data{j,5}>obj.data{j-1,5}
                            ts(j) = 1;
                        elseif obj.data{j,5}<obj.data{j-1,5}
                            ts(j) = -1;
                        elseif obj.data{j,5}==obj.data{j-1,5}
                            ts(j) = lastclass;
                        end
                    end
                    
                    % Calculate the mid-quote before each classified trade
                    if ts(j)~=0 && obj.data{j,9} == obj.data{j-1,9} % This ensures that we compare events in the same trading session
                            
                        if strcmp(obj.data{j,4},'Trade') && strcmp(obj.data{j-1,4},'Quote')
                            mn(j) = .5*(obj.data{j-1,7} + obj.data{j-1,8}); Lmq = mn(j);
                        elseif strcmp(obj.data{j,4},'Trade') && strcmp(obj.data{j-1,4},'Trade')
                            mn(j) = Lmq;
                        end
                    end
                    
                    % Calculate the price change after each classified trade
                    
                    if ts(j) ~= 0 && j~=r && obj.data{j,9} == obj.data{j-1,9} % This ensures that we compare events in the same trading session
                        
                        if strcmp(obj.data{j,4},'Trade') && ...
                                strcmp(obj.data{j-1,4},'Quote') && ...
                                strcmp(obj.data{j+1,4},'Quote')
                            
                            prevlogmidq = log( .5*(obj.data{j-1,7} + obj.data{j-1,8}));
                            
                            nextlogmidq = log(.5*(obj.data{j+1,7} + obj.data{j+1,8}));
                            
                            dp(j) = nextlogmidq - prevlogmidq;
                            
                            vl(j) = obj.data{j,6};
                            
                            T(j) = datenum(obj.data{j,2});
                            
                            
                            if ts(j) == 1
                                
                                dpb(j)  = dp(j); %log10(obj.data{j+1,8})  - log10(obj.data{j-1,8});
                                buyerv(j) = vl(j);
                                pitimeb(j) = T(j);
                                if dpb(j) == 0
                                    dpb(j) = NaN;
                                    %pitimeb(j) = NaN;
                                end
                            elseif ts(j) == -1
                                dps(j)  = dp(j);%log10(obj.data{j+1,7})  - log10(obj.data{j-1,7});
                                sellerv(j) = vl(j);
                                pitimes(j) = T(j);
                                if dps(j) == 0
                                    dps(j) = NaN;
                                    %pitimes(j) = NaN;
                                    
                                end
                            end
                            
                        end
                    end
                    
                end
                
                
                
                % Extract trade volumes, dates, signs and midquotes
                td = datenum(obj.data(ts~=0,2));
                tradeSesIdx(ts==0) = [];
                td = [td,tradeSesIdx];
                tv = cell2mat(obj.data(ts~=0,6));
                ts2 = ts(ts~=0);
                mn = mn(mn~=0);
                
                n = numel(ts2);
                
                
                % Populate properties with
                c = obj.Tradesign;
                c = c(c~=0);
                
                if isempty(c)
                    c = 0;
                    
                else
                    c = numel(c);
                end
                
                if ~isempty(td)
                    obj.Tradesign(c+1:c+n) = ts2;
                    obj.Tradedate(c+1:c+n,1) = td(:,1);
                    obj.Tradedate(c+1:c+n,2) = td(:,2);
                    obj.Tradevolume(c+1:c+n) = tv;
                    obj.Midquote(c+1:c+n) = mn;
                end
                
                
                % Populate buyer price impact
                dpb(dpb==0) = [];
                buyerv(buyerv==0) = [];
                pitimeb(pitimeb == 0) = [];
                
                c = obj.BV;
                c = c(c~=0);
                
                if isempty(c)
                    c = 0;
                else
                    c = numel(c);
                end
                
                m = numel(dpb);
                obj.BV(c+1:c+m) = buyerv;
                obj.dPB(c+1:c+m) = dpb;
                obj.TB(c+1:c+m) = pitimeb;
                
                
                
                % Populate seller price impact
                dps(dps==0) = [];
                sellerv(sellerv==0) = [];
                pitimes(pitimes==0) = [];
                
                c = obj.SV;
                c = c(c~=0);
                
                if isempty(c)
                    c = 0;
                else
                    c = numel(c);
                end
                
                m = numel(dps);
                obj.dPS(c+1:c+m) = dps;
                obj.SV(c+1:c+m) = sellerv;
                obj.TS(c+1:c+m) = pitimes;
                
                
                
            end
            % Clear unused data
            obj.data = [];
            
            
        end
        
        %% Method for calculating daily parameters
        function obj = DailyParameters(obj,Collection,SDate,EDate,...
                tempCSVoutput, transactionsFieldFile, userChoice)
            %DailyParameters - DailyParameters claculates the daily
            % paremeters of a stock
            %
            % INPUTS:
            %----------------------------------------------------------
            %
            %   obj: PriceResponse object
            %   Collection:
            %   RIC:
            %   Date:
            %   STime:
            %   ETime:
            %   tempCSVoutput:
            %   transactionsFieldFile:
            %
            %----------------------------------------------------------
            %
            % OUTPUTS
            %----------------------------------------------------------
            %
            
            [dailydates] =...
                upper(cellstr(datestr(datenum(SDate):1:datenum(EDate))));
            
            ndays = numel(dailydates);
            
            for i = 1:ndays
                obj.extractfromMongoDBcsvPR(...
                    Collection,dailydates{i},...
                    tempCSVoutput,transactionsFieldFile);
                
                if ~isempty(obj.data)
                    
                    switch userChoice
                        
                        case 'Full Price Response'
                            
                            % Clean the data
                            obj.CleanCompt
                            
                            % Classify trades
                            obj.Classf
                            
                            % Clear unnecersy data to reduce parallel overhead
                            obj.data = [];
                            
                        case 'Partial Price Response'
                            
                            obj.CleanCompt
                            
                            obj.data = [];
                            
                        case 'Grouped Stocks Analysis'
                            obj.CleanCompt
                            
                            obj.Classf
                            
                            obj.data = [];
                    end
                    
                end
            end
            
            
            obj.ADVolatility = mean(obj.ADVolatility);
            obj.AVSpread = mean(obj.AVSpread);
            
            if ~isempty(obj.Tradesign) && strcmp(userChoice,'Full Price Response')
                TakeAverages(obj)
                CalPrIM(obj)
            elseif ~isempty(obj.Tradesign) && strcmp(userChoice,'Grouped Stocks Analysis')
                TakeAverages(obj)
            end
                
            
        end
                
        %% Method for calculating the daily average price response
        function TakeAverages(obj)
            
            ts = obj.Tradesign;
            td = obj.Tradedate;
            mn = obj.Midquote;
            mn(mn==0) = [];
            ts(ts==0) = [];
            td(td==0,:) = [];
            volumes = obj.Tradevolume;
            analysis = obj.Analysis;
            
            [mn,ts,td] = PriceResponse.clear5Std(mn,ts,td);
            
            % Get the number of trading sessions in a day
            
            
            udays = unique(td(:,1));
            
            nUniquedays = numel(udays);
            
            if nUniquedays ~=0
                
                numoftrades = zeros(nUniquedays,1);
                
                tradeSesIdx = unique(td(:,2));
                
                nTradeSes = numel(tradeSesIdx);
                
                for i = 1:nTradeSes
                    for j = 1:nUniquedays
                        numoftrades(j,i) = numel(ts(td(:,1)==udays(j) & td(:,2) == tradeSesIdx(i)));
                    end
                end
                
                obj.Tradesperday = numoftrades;
                
                if mean(mean(numoftrades)) < 1000
                    L = floor(median(median(numoftrades)));
                else
                    L = 1000;
                end
                
                
                % Initialise daily daily [...] matrices
                
                dailyCL = zeros(L,nUniquedays*nTradeSes);
                dailyCLV = zeros(L,nUniquedays*nTradeSes);
                dailyRL = zeros(L,nUniquedays*nTradeSes);
                dailyDL = zeros(L,nUniquedays*nTradeSes);
                dailyG0 = zeros(L,nUniquedays*nTradeSes);
                
                for i = 1:nTradeSes
                    for j = 1:nUniquedays
                        
                        switch i
                            case 2
                                plusIdx = nUniquedays;
                            case 1
                                plusIdx = 0;
                        end
                        
                        daytempTS = ts(td(:,1)==udays(j) & td(:,2) == tradeSesIdx(i));
                        daytempMN = mn(td(:,1)==udays(j) & td(:,2) == tradeSesIdx(i));
                        tempVolumes = volumes(td(:,1)==udays(j) & td(:,2) == tradeSesIdx(i));
                        
                        
                        if numel(daytempTS) >= L
                            dailyCL(:,j + plusIdx) = PriceResponse.TSAuto(daytempTS,L-1);
                            dailyCLV(:,j + plusIdx) = PriceResponse.TSAuto(daytempTS,L-1,tempVolumes);
                            
                            daytempRL = PriceResponse.ResC(daytempTS,daytempMN,analysis);
                            dailyRL(:,j + plusIdx) = daytempRL(1:L);
                            
                            dailyG0(:,j + plusIdx) = PriceResponse.bareProp(dailyCLV(:,j),dailyRL(:,j),tempVolumes);
                            
                            daytempDL = PriceResponse.MSD(daytempMN,analysis);
                            dailyDL(:,j + plusIdx) = daytempDL(1:L);
                            
                            
                        end
                    end
                end
                
                dailyCL = mean(dailyCL,2);
                dailyCLV = mean(dailyCLV,2);
                dailyRL = mean(dailyRL,2);
                dailyDL = mean(dailyDL,2);
                dailyG0 = mean(dailyG0,2); %PriceResponse.bareProp(dailyCLV,dailyRL,volumes);
                
                
                obj.CL = dailyCL;
                obj.CLV = dailyCLV;
                obj.RL = dailyRL;
                obj.DL = dailyDL;
                obj.G0 = dailyG0;
                
                % Clear unused data
                obj.Tradesign = [];
                obj.Tradevolume = [];
                obj.Midquote = [];
                obj.Tradedate = [];
                
                
            end
            
            
        end
        
        %% Method for calulating the price impact function
        function CalPrIM(obj)
            %CalPrIM - CalPrIM calculates the price change caused by buyer and
            % sell initiated trades (separatly).
            
            % INPUT:
            %------------------------------------------------------------------
            % obj: Object of type PriceResponse
            %
            %------------------------------------------------------------------
            %
            % OUPUT:
            %------------------------------------------------------------------
            
            %% Calculate the price impact of buyer initiated trades
            
            % Extract the price change and volume vector from the object
            buyervol = obj.BV;
            buyervol(isnan(buyervol)) = 0;
            buyerdp = obj.dPB;
            buyerdp(isnan(buyerdp)) = 0;
            buyerT = obj.TB;
            
            sellervol = obj.SV;
            sellerdp = obj.dPS;
            sellerdp(isnan(sellerdp)) = 0;
            sellerT = obj.TS;
            
            
            [buyerdp,buyervol,buyerT,sellerdp,sellervol,sellerT] =...
                PriceResponse.clear5stdPI(buyerdp,buyervol,buyerT,sellerdp,...
                sellervol,sellerT);
            
            % Clear trades that cause no impact and nonsensicle trades
            
            buyerdp(buyervol==0) = [];
            
            buyervol(buyervol==0) = [];
            
            % Count number of seller volumes
            totBuyerVol = numel(buyervol);
            
            % Get the list of unique days
            uniqueBuyerTime = unique(buyerT);
            
            % Initailse daily seller volume cell
            wb = cell(1,numel(uniqueBuyerTime));
            
            % Populate daily seller volume cell
            for i = 1:numel(uniqueBuyerTime)
                wb{:,i} = buyervol(uniqueBuyerTime(i) == buyerT)';
            end
            
            nBuyerTime = numel(uniqueBuyerTime);
            normBuyervol = cell(1,nBuyerTime);
            % Calculate the normalized daily volume
            for i = 1:numel(uniqueBuyerTime)
                for j = 1:numel(wb{i})
                    normBuyervol{1,i}(j) = ...
                        wb{1,i}(j)/sum(wb{i})*(totBuyerVol/sum(buyervol))^-1;
                end
            end
            
            % Collate buyer volumes
            buyervol = [normBuyervol{:}];
            
            % Initailise the buyer volume bin edges
            
            Spacing = obj.binSpacing;
            
            switch Spacing
                case 'logSpace'
                    buyerBinEdges = logspace(-2,0.5,20);
                case 'equalBins'
                    buyerBinEdges = zeros(1,20);
                    for i = 1:20
                        buyerBinEdges(i) = quantile(buyervol,i/20);
                    end
            end
            
            % Bucket the buyer volumes into the initialised vector
            
            
            buyeridx = PriceResponse.binData(buyervol,buyerBinEdges);
            
            numInBuyerBin = zeros(1,20);
            for i = 1:20
                numInBuyerBin(i) = sum(buyeridx==i);
            end
            
            %C = mean(obj.ADTValue);
            %options = optimset('MaxIter',2000);
            
            %             [delta,Fval] =...
            %                 fminunc(@(DG)(costFun(DG,C,buyerdp,buyervol,buyerBinEdges)),[-0.05;-0.05]);
            
            
            % Initilise the price impact matrix
            buyerPI = zeros(1,20);
            bVol = zeros(1,20);
            buyerdpErr = zeros(1,20);
            buyerVolErr = zeros(1,20);
            
            % Calculate the mean price impact in each voulme bucket
            for i = 1:20
                buyerPI(i) = mean(buyerdp(buyeridx == i));
                bVol(i) = median(buyervol(buyeridx == i));
                buyerdpErr(i) = std(buyerdp(buyeridx == i));
                buyerVolErr(i) = std(buyervol(buyeridx == i));
            end
            
            buyerPI(numInBuyerBin==0) = [];
            bVol(numInBuyerBin==0) = [];
            buyerdpErr(numInBuyerBin==0) = [];
            buyerVolErr(numInBuyerBin==0) = [];
            %[cdLiq,Fval] =...
            %    fminunc(@(cdLiq)(costFun2(cdLiq,buyerPI,bVol,C)),[0;0]);
            
            % Set up gobal optimization proceedure
            %objFun = @(X0)costFun2(X0,buyerPI,bVol,C);
            
            %initGuess = [0,0];
            
            %problem = createOptimProblem('fmincon','objective',objFun,'x0',initGuess);
            %gs = GlobalSearch;
            
            %[X0,XF,~,~] = run(gs,problem);
            
            %[X0,~] = fminunc(@(X0)(costFun(X0,C,buyerPI,bVol)),[0;0]);
            
            %L = cdLiq(3);
            %L = C;
            
            
            obj.BPIM = [bVol',buyerPI',buyerdpErr',buyerVolErr'];
            %obj.CBPIM = [bVol'/L^cdLiq(1), buyerPI'/L^cdLiq(2)];
            obj.NB = numInBuyerBin;
            %obj.c_Const = cdLiq(1);
            %obj.d_Const = cdLiq(2);
            %obj.Liq = L;
            %obj.J = [Fval;XF];
            
            %obj.GAMMA = X0(1);
            %obj.DELTA = X0(2);
            
            %% Calculate the price impact of seller initiated trades
            
            % Extract seller volumes and price changes from object
            
            
            % Clear price impacts nonsensical trades (i.e price impacts
            % with volume zero)
            
            sellerdp(sellervol==0) = [];
            
            sellerT(sellervol==0) = [];
            
            sellervol(sellervol==0) = [];
            
            
            % Count number of seller volumes
            totSellerVol = numel(sellervol);
            
            % Get the list of unique days
            uniqueSellerTime = unique(sellerT);
            
            % Initailse daily seller volume cell
            w = cell(1,numel(uniqueSellerTime));
            
            % Populate daily seller volume cell
            for i = 1:numel(uniqueSellerTime)
                w{:,i} = sellervol(uniqueSellerTime(i) == sellerT)';
            end
            
            % Calculate the normalized daily volume
            nSellerTime = numel(uniqueSellerTime);
            normSellervol = cell(1,nSellerTime);
            
            for i = 1:numel(uniqueSellerTime)
                for j = 1:numel(w{i})
                    normSellervol{1,i}(j) = ...
                        w{1,i}(j)/sum(w{i})*(totSellerVol/sum(sellervol))^-1;
                end
            end
            
            % Collate seller volumes
            sellervol = [normSellervol{:}];
            
            % Crate seller volume bin edges
            
            switch Spacing
                case 'logSpace'
                    
                    sellerBinEdges = logspace(-2,.5,20);
                    
                case 'equalBins'
                    
                    sellerBinEdges = zeros(1,20);
                    for i = 1:20
                        sellerBinEdges(i) = quantile(sellervol,i/20);
                    end
            end
            
            
            
            
            % Bucket volumes in bin range
            
            selleridx = PriceResponse.binData(sellervol,sellerBinEdges);
            
            numInSellerBin = zeros(1,20);
            for i = 1:20
                numInSellerBin(i) = sum(selleridx==i);
            end
            
            % Initialse seller price impact matrix
            SPI = zeros(1,20);
            sVol = zeros(1,20);
            sellerdpErr = zeros(1,20);
            sellerVolErr = zeros(1,20);
            
            
            % Calculate the seller price impact in each bin
            for i = 1:20
                SPI(i) = mean(sellerdp(selleridx == i));
                sVol(i) = median(sellervol(selleridx == i));
                sellerdpErr(i) = std(sellerdp(selleridx == i));
                sellerVolErr(i) = std(sellervol(selleridx == i));
            end
            
            % Clear bins that dont have any data points
            SPI(numInSellerBin==0) = [];
            sVol(numInSellerBin==0) = [];
            sellerdpErr(numInSellerBin==0) = [];
            sellerVolErr(numInSellerBin==0) = [];
            
            % Populate object properties
            obj.SPIM = [sVol',SPI',sellerdpErr',sellerVolErr'];
            
            obj.NS = numInSellerBin;
            
            obj.BV = [];
            obj.dPB = [];
            obj.TB = [];
            
            obj.SV = [];
            obj.dPS = [];
            obj.TS = [];
        end
        
        %% Method for calibrating parameters
        function obj = calibPR(obj)
            
            obj.calBetaLambda;
            obj.calibrateG0;
            obj.calibrateCL;
            
        end
        
        %% Method to calculating the beta and lambda constants of price impact
        function  calBetaLambda(obj)
            % CALBETALAMBDA Calculate the beta and lambda exponent of price
            % impact function on stock
            
            % Get buyer price changes and normalized volumes
            buyerdPB = abs(obj.SPIM(:,2));
            buyerV = obj.SPIM(:,1);
            
            % Construct linear regression matrix and vector
            n = numel(buyerdPB);
            X = [-ones(n,1) log(buyerV)];
            Y = log(buyerdPB);
            
            % Perform linear regression on entire region of omega
            beta = X\Y;
            
            % Populate the beta and lambda properties
            obj.BetaAll = beta(2);
            obj.Lambda = exp(beta(1));
            
            % Perfomr linear regression on large value of omega
            %XLarge = X(X(:,2)<=10^(-1),:);
            %YLarge = Y(X(:,2)<=10^(-1));
            %betaLarge = XLarge\YLarge;
            %obj.BetaR2 = betaLarge(2);
            %obj.LambdaR2 = exp(betaLarge(1));
        end
        
        %% Method to calibrate bare response
        function  calibrateG0(obj)
            
            % Define cost function
            CF = @(L)G0Cost(obj.G0,L);
            
            % Set initial guess
            x0 = [0 0 0];
            
            % Specify Problem
            problem = createOptimProblem('fmincon','objective',CF,'x0',x0);
            gs = GlobalSearch;
            L = run(gs,problem);
            
            % Populate object properties
            obj.Gamma0 = L(1);
            obj.L0 = L(2);
            obj.G0Beta = L(3);
            
            function Cost = G0Cost(G0,L)
                    l = (1:numel(G0))';
                    Cost = sum( ( G0 - L(1) * ((L(2)^2 + l.^2).^(-L(3)/2)) ).^2 );
            end
            
        end
        
        %% Method to calibrate C(L)
        function  calibrateCL(obj)
            
             % Set initial condition
             x0 = [0.5 0.5];
             ObjFun = @(X)C0Cost(obj.CL,X);
             % Specify Problem
             problem = createOptimProblem('fmincon','objective',ObjFun,'x0',x0);
             gs = GlobalSearch;
             C = run(gs,problem);
             
             % Populate object parameters
             obj.C0 = C(1);
             obj.C0Gamma = C(2);
             
             % Define cost function
            function Cost = C0Cost(C0,x)
                l = (1:numel(C0))';
                Cost = norm( C0 - (x(1)./l.^x(2)) );
            end
        end
     
        
    end
    
    %% Static Methods
    methods(Static)
        
        %% Method for calculating the autocorrelation of trade signs
        function crr = TSAuto(varargin)
            
            ts = varargin{1};
            l = varargin{2};
            
            
            switch nargin
                case 3
                    v = varargin{3};
            end
            
            crr = zeros(l+1,1);
            
            for i = 1:l
                ts1 = ts(1:end-i);
                ts2 = ts(i+1:end);
                
                switch nargin
                    case 2
                        crr(i) = sum(ts1.*ts2)/numel(ts) - (sum(ts1)/numel(ts))^2;
                        
                    case 3
                        v1 = v(1:end-i);
                        crr(i) = sum(ts1.*ts2.*log(v1))/numel(ts);
                end
            end
        end
        
        
        %% Method for calculating the average response coeficient
        function arc = ResC(ts,mn,Analysis)
            
            arc = zeros(numel(mn),1);
            
            for l = 1:numel(mn)
                
                mn1 = mn(1:end-l);
                mn2 = mn(l+1:end);
                tn = ts(1:end-l);
                
                switch Analysis
                    case 'Single'
                    arc(l) = sum(tn.*(mn2-mn1))/numel(mn);
                    
                    case 'Grouped'
                        arc(l) = sum(tn.*(log(mn2) - log(mn1)))/numel(mn);
                        
                end
            end
        end
        
        %% Method for calculating the mean squred displacement of the price
        function dl = MSD(mn,Analysis)
            
            dl = zeros(numel(mn),1);
            
            for l = 1:numel(mn)
                
                mn1 = mn(1:end-l);
                mn2 = mn(l+1:end);
                
                switch Analysis
                    case 'Single'
                    dl(l) = sum((mn2 - mn1).^2)/numel(mn);
                    
                    case 'Grouped'
                        dl(l) = sum((log(mn2) - log(mn1)).^2)/numel(mn);
                end
            end
        end
        
        %% Method for estimating the bare propergator function
        function G0 = bareProp(cl,rl,Volumes)
            
            n = numel(cl);
            
            M = zeros(n);
            
            M(1:n+1:end) = mean(log(Volumes));
            
            for i = 1:n-1
                M(i+1:end,i) = cl(1:end-i);
            end
            
            G0 = M\rl;
            
        end
        
        %% Visualisation method
        function Plot_PR(obj,C,dateString)
            
            % Defind color vector
            %C = rand(1,3);
            
            % Select frist figure and plot CL
            figure(1)
            loglog(obj.CL,'Color',C)
            xlabel('$\ell$','Interpreter','latex','fontsize',20)
            ylabel('$\mathcal{C}(\ell)$','Interpreter','latex','fontsize',20)
            title([dateString,' daily  average $\mathcal{C}(\ell)$ vs $\ell$'],'interpreter','latex','fontsize',15)
            
            % Selct second figure and plot RL
            figure(2)
            plot(obj.RL,'Color',C)
            set(gca, 'xscale','log')
            xlabel('$\ell$','Interpreter','latex','fontsize',20)
            ylabel('$\mathcal{R}(\ell)$','Interpreter','latex','fontsize',20)
            title([dateString,' daily  average $\mathcal{R}(\ell)$ vs $\ell$'],'interpreter','latex','fontsize',15)
            
            % Select third figure and plot DL
            figure(3)
            DL = obj.DL;
            L = 1:numel(DL);
            plot(L,sqrt(DL./L'),'Color',C)
            xlabel('$\ell$','Interpreter','latex','fontsize',20)
            ylabel('$\sqrt{\mathcal{D}(\ell) / \ell}$','Interpreter','latex','fontsize',20)
            title([dateString,' daily  average $\sqrt{\mathcal{D}(\ell) / \ell}$ vs $\ell$'],'interpreter','latex','fontsize',15)
            
            % Select forth figure and plot G0
            figure(4)
            loglog(obj.G0,'Color',C)
            xlabel('$\ell$','Interpreter','latex','fontsize',20)
            ylabel('$G_0(\ell)$','Interpreter','latex','fontsize',20)
            title([dateString,' daily  average $G_0(\ell)$ vs $\ell$'],'interpreter','latex','fontsize',15)
            
            % Select fith figure and plot buyer price impact functions
            figure(5)
            loglog(obj.BPIM(:,1),obj.BPIM(:,2),'-s','Color',C);
            xlabel('$\omega$','Interpreter','latex','fontsize',20)
            ylabel(' $\Delta p$','Interpreter','latex','fontsize',20)
            title({[dateString,' price impact curves'] ,'for buyer initiated trades'},'interpreter','latex','fontsize',15)
            
            % Select sixth figure and plot seller price impact functions
            figure(6)
            loglog(obj.SPIM(:,1),-obj.SPIM(:,2),'-s','Color',C);
            xlabel(' $\omega$','Interpreter','latex','fontsize',20)
            ylabel(' $-\Delta p$','Interpreter','latex','fontsize',20)
            title({[dateString, ' price impact curves'] ,' for sell initiated trades'},'interpreter','latex','fontsize',15)
            
        end
        
        %% Method to delete prices outside of 5 stanadard deviations
        
        function [mn,ts,td] = clear5Std(mn,ts,td)
            %clear5Std removes data points that are outside of 5 standard
            % deviations from the mean
            
            % INPUTS:
            %--------------------------------------------------------------
            % mn:
            % ts:
            % td:
            % -------------------------------------------------------------
            %
            % OUTPUTS:
            %--------------------------------------------------------------
            % mn:
            % ts:
            % td:
            %--------------------------------------------------------------
            
            
            X = mean(mn);
            
            ts( mn > X + 3*std(mn)) = [];
            td( mn > X +  3*std(mn),:) = [];
            mn( mn > X + 3*std(mn)) = [];
        end
        
        function [dPB,BV,BT,dPS,SV,ST] = clear5stdPI(dPB,BV,BT,dPS,SV,ST)
            
            % Calculate mean and standard deviation of price shifts
            av_dPB = mean(dPB);
            av_dPS = mean(dPS);
            std_dPB = std(dPB);
            std_dPS = std(dPS);
            
            % Perform cleaning
            BV( dPB > av_dPB + 3*std_dPB ) = [];
            BT( dPB > av_dPB + 3*std_dPB ) = [];
            dPB( dPB > av_dPB + 3*std_dPB  ) = [];
            
            SV( dPS > av_dPS + 3*std_dPS ) = [];
            ST( dPS > av_dPS + 3*std_dPS ) = [];
            dPS( dPS > av_dPS + 3*std_dPS ) = [];
            
        end
        
        %% Method to bin data points
        function binidx = binData(dataSet, binEdges)
            %binData bins dataSet into binEdges
            %
            % INPUTS:
            %--------------------------------------------------------------
            % dataSet:
            % binEdges:
            %--------------------------------------------------------------
            %
            % OUTPUTS:
            %--------------------------------------------------------------
            %
            % binidx:
            %--------------------------------------------------------------
            
            binidx = zeros(numel(dataSet),1);
            
            for i = 1:numel(dataSet)
                for j = 1:numel(binEdges)
                    if j == 1
                        if dataSet(i) <= binEdges(j)
                            binidx(i) = j;
                        end
                    elseif j~=1
                        if dataSet(i) > binEdges(j-1) && dataSet(i) <= binEdges(j)
                            binidx(i) = j;
                        end
                    end
                end
            end
        end
        
        
    end
     
    
end
