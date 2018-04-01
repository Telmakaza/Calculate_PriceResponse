classdef  GroupedPriceResponse < handle
    % GrupedPriceResponse - Class definition of GroupedPriceResponse Object
    % This class calculate the price response of grouped stocks. It
    % attempts to encapsulate the data and methods used to calculate the
    % the price impact and bare impact functions of grouped stocks (from
    % Thompson Rueters History Tick Data. Each instance of this class
    % represents a trading day. 
    
    properties 
      Date % The date of a specific day  
      Tickers % The tickers of a group of stocks
      GdPB % Buyer price chanage
      GdPS % Seller price change
      GBV % Volumes corresponind to the price change vector dPB
      GSV % Volumes corresponding to the price change vector dPS
      GRL % Price response coefficient of gruped stocks
      GDL % Square root of normalized mean squared displacement of the price
      GCL % Trade sign autocorrelation function of grouped stocks
      GG0 % Estimate of bare propergator function of gruped stocks
      Market % Stock exchange at which stocks with RICs "Tickers" are traded
      GTB % Trade times of buyer price impacts
      GTS % Trade times of seller price impacts
      GBPIM % Grouped buyer price impact matrix
      GSPIM % Grouped seller price impact matrix
    end
    
    %% GroupedPriceResponse procedures
    methods
       
        %% GroupedPriceResponse constructor method
        function obj = GroupedPriceResponse(varargin)
            
            switch nargin
                case 3
                    
                tickerList = varargin{1};
                dateList = varargin{2};
                market = varargin{3};
                
                n = numel(dateList);
                obj(n) = GroupedPriceResponse;
                
                for i = 1:n
                    obj(i).Tickers = tickerList;
                    obj(i).Date = dateList{i};
                    obj(i).Market = market;
                end
            
            end
        end
        
        %% Method for calculating stock parameters
        function obj = stockParameters(obj,Collection,Date,tempCSVoutput,transff)
            
            tickers = obj.Tickers;
            market = obj.Market;
            
            n = numel(tickers);
            
            % Initialize price response array
            priceRespObj = PriceResponse(tickers,'logspace',market);
            
            
            buyerpopIdx = 0; % Buyer population index
            sellerpopIdx = 0; % Seller population index
            
            CL = zeros(1000,n);
            RL = zeros(1000,n);
            DL = zeros(1000,n);
            G0 = zeros(1000,n);
            
            for i = 1:n
                
                priceRespObj(i).Analysis = 'Grouped';
                
                priceRespObj(i) = ...
                    priceRespObj(i).DailyParameters(Collection,Date,Date,...
                    tempCSVoutput,transff,'Grouped Stocks Analysis');
                
                % Extract price cahnages and associated volumes from
                % PriceResponse objects
                buyerdP = priceRespObj(i).dPB;
                buyerVol = priceRespObj(i).BV;
                nBuyer = numel(buyerdP);
                buyerT = priceRespObj(i).TB;
                
                sellerdP = priceRespObj(i).dPS;
                sellerVol = priceRespObj(i).SV;
                nSeller = numel(sellerdP);
                sellerT = priceRespObj(i).TS;
                
                % Populate GroupedPriceResponse objects
                obj.GdPB(buyerpopIdx + 1: buyerpopIdx + nBuyer) = buyerdP;
                obj.GBV(buyerpopIdx + 1: buyerpopIdx + nBuyer) = buyerVol;
                obj.GTB(buyerpopIdx + 1: buyerpopIdx + nBuyer) = buyerT;
                
                obj.GdPS(sellerpopIdx + 1: sellerpopIdx + nSeller) = sellerdP;
                obj.GSV(sellerpopIdx + 1: sellerpopIdx + nSeller) = sellerVol;
                obj.GTS(sellerpopIdx + 1: sellerpopIdx + nSeller) = sellerT;
                
                if ~isempty(priceRespObj(i).RL) && numel(priceRespObj(i).RL) >= 1000
                    CL(:,i) = priceRespObj(i).CL;
                    RL(:,i) = priceRespObj(i).RL;
                    DL(:,i) = priceRespObj(i).DL;
                    G0(:,i) = priceRespObj(i).G0;
                else
                    CL(:,i) = zeros(1000,1);
                    RL(:,i) = zeros(1000,1);
                    DL(:,i) = zeros(1000,1);
                    G0(:,i) = zeros(1000,1);
                end
                
                
            end
            
            % Clear Less less activley traded stocks
            CL(:,~any(CL,1)) = [];
            RL(:,~any(RL,1)) = [];
            DL(:,~any(DL,1)) = [];
            G0(:,~any(G0,1)) = [];
            
            % Calculate price response estimates
            CL = mean(CL,2);
            RL = mean(RL,2);
            DL = mean(DL,2);
            G0 = mean(G0,2);
            
            % Populate GroupedPriceResponse Object
            obj.GCL = CL;
            obj.GRL = RL;
            obj.GDL = DL;
            obj.GG0 = G0;
            
            clear priceRespObj
                       
        end
        
    end
    
    %% GroupedPriceResponse static procedures
    
end