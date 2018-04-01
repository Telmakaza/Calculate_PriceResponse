function BinIndex = binByADTV(obj)
% BINBYADTV sort stocks by average daily value\volume traded.
%   binidx = BINBYADTV(obj) outputs a (n x M) matrix, binidx. Each element
%   of binidx correspons to an ADTV bin

% Set number of 3 months in the period: 04-Jan-2010 to 10-May-2016

obj([4 6 8 9 12 16 17 19 24 27]) = [];


M = 25;

% Get size of object array
n = numel(obj);

% Initialise outputmatrix
BinIndex = zeros(n,M);


% Get bin indices for each 3 months
for jj = 1:M
    
    % Initialise ADTV and binidx vector
    ADTV = zeros(n,1);
    binidx = zeros(n,1);
    
    % Extract the ADTV of each object
    for ii = 1:n
        if numel(obj(ii).ADTValue) ~= 2319
            ADTV(ii) = nan;
        else
            if jj == 1
                ADTV(ii) = sum(obj(ii).tradesPerDay(1:90));
            elseif jj~=1 && jj<M
                ADTV(ii) = sum(obj(ii).tradesPerDay((jj-1)*90+1:jj*90));
            else
                ADTV(ii) = sum(obj(ii).tradesPerDay((jj-1)*90+1:end));
            end
        end
    end
    
    % Calculate average ADTV per bin
    adtvPerBin = sum(ADTV)/4;
    
    % Create matrix that tracks Stocks
    stockMatrix = [(1:n)', ADTV];
    
    % Sort stockMatrix by ADTV
    stockMatrix = sortrows(stockMatrix,2);
    
    sortedADTV = stockMatrix(:,2);
    
    % Initialise Sum variable and loop indices
    S = sortedADTV(1);
    i = 1;
    j = 1;
    
    % Initialise index vector and Sum vector
    sumInBin = zeros(5,1);
    binEdges = zeros(5,1);
    
    
    % Get bin edges
    
    while i < n %S < adtvPerBin
        
        S = S + sortedADTV(i+1);
        
        if S >= adtvPerBin
            sumInBin(j) = S;
            binEdges(j) = i;
            
            % update loop index
            j = j+1;
            
            if i<=n-2
                S = sortedADTV(i+2);
                i = i+1;
                %else
                %   sumInBin(j-1) = sum(sortedADTV(i:end));
                %  binEdges(j-1) = numel(sortedADTV);
            end
        end
        
        i = i + 1;
    end
    
    % Get size of binEdges vector
    binEdges(binEdges==0) = [];
    m = numel(binEdges);
    
    % Populate binidx vector
    for j = 1:m
        if j ==1
            binidx(1:binEdges(j)+1) = j;
        else
            binidx(binEdges(j-1)+2:binEdges(j)+1) = j;
        end
    end
    
    % unsort stocks
    
    sortedBinMatrix = [binidx,stockMatrix(:,1)];
    originalOrderedMatrix = sortrows(sortedBinMatrix,2);
    
    binidx = originalOrderedMatrix(:,1);
    binidx(binidx==0) = 3;
    
    BinIndex(:,jj) = binidx;
    
    
end