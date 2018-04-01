function binidx = binByNumTrades(obj)
% BINBYNUMTRADES group stocks by total number of trades per day.
%   binidx = BINBYADTV(obj) outputs a (n x 1) matrix, binidx. Each element
%   of binidx correspons to a "number of trades" bin.

% Get number of objects
n = numel(obj);

% Initialize bin index vector
binidx = zeros(n,1);

% Extract number of trades per day for each stock
Tradesperday = zeros(n,1);

for k = 1:n
    Tradesperday(k) = sum(obj(k).tradesPerDay);
end

tradesPerBin = sum(Tradesperday)/4;

% Create matrix that tracks Stocks
    stockMatrix = [(1:n)', Tradesperday];
    
    % Sort stockMatrix by ADTV
    stockMatrix = sortrows(stockMatrix,2);
    sortedADTV = stockMatrix(:,2);
    
    % Initialise Sum variable and loop indices
    S = sortedADTV(1);
    i = 1;
    j = 1;
    
    % Initialise index vector and Sum vector
    sumInBin = zeros(3,1);
    binEdges = zeros(3,1);
    
    
    % Get bin edges
    while i < n 
        
        S = S + sortedADTV(i+1);
        
        if S >= tradesPerBin
            sumInBin(j) = S;
            binEdges(j) = i;
            
            % update loop index
            j = j+1;
            
            if i<=n-2
                S = sortedADTV(i+2);
                i = i+1;
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
