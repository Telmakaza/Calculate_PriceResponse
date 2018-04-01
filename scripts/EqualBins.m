%% Create bins with same number of data points

x = Stocks(2).BV;
y = zeros(numel(x),1);

BinEdges = zeros(1,20);

for i = 1:20
    BinEdges(i) = quantile(x,i/20);
end

BinEdges = logspace(-3.2,1);

for i = 1:numel(x)
    for j = 1:numel(BinEdges)
        if j == 1
            if x(i) <= BinEdges(j)
                y(i) = j;
            end
        elseif j~=1 
            if x(i) > BinEdges(j-1) && x(i) <= BinEdges(j)
                y(i) = j;
            end
        end
    end
end

BinEdges = unique(BinEdges);