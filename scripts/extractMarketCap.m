%% Reuters market cap web scraper

% Author: E.Nonyane
% Date: 07-07-2017


%% Configure paths

addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\functions');


%% Clear workspace

clc
clear

%% Import market data from report csv file.

Market = 'JSE';

marketCell = importMarketCSV(Market);

% Extract stock RICs

Ric = unique(marketCell(:,1));

Ric = Ric(3:end); % Eliminate "#RIC" and index from stock list


marketCap = zeros(numel(Ric),1);

for i = 1:numel(Ric)
    
    urlString = urlread(['http://www.reuters.com/finance/stocks/overview?symbol=',Ric{i}]);
    
    %% Remove remove undesired markup
    
    urlString = regexprep(urlString,'<script.*?/script>','');
    urlString = regexprep(urlString,'<style.*?/style>','');
    urlString = regexprep(urlString,'<.*?>','');
    
    %% Extract the Market Cap
    marketCapPos = strfind(urlString,'Market Cap');
    
    % Get string containing market cap
    
    if ~isempty(marketCapPos)
        marketCapString = urlString(marketCapPos:marketCapPos+40);
        
        % Remove blank spaces;
        marketCapString = strtrim(marketCapString);
        
        % Find ';' in the market cap string
        semicolonPos = strfind(marketCapString,';');
        
        % Extract the market cap
        
        marketCap(i) = str2double(marketCapString(semicolonPos+1:end));
        
        if ~isempty(strfind(marketCapString,'Mil.'))
            marketCap(i) = marketCap(i)*1e+06;
        else
            error(['Market cap not in Mil! Market Cap string is:', marketCapString])
        end
    else
        marketCap(i) = NaN;
    end
end