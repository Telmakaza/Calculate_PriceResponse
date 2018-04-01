function makeTexLiqTable(obj)

% Get number of objects in object array
n = numel(obj);

% Get market from object
Market = obj(1).Market;

for i = n:-1:1
    if isempty(obj(i).BetaAll)
        obj(i) = [];
    end
end

for i = 1:43
    
    if ~isempty(obj(i).BetaAll)
    
        % Open .txt file
        if i == 1
            fileId = fopen([Market,'.txt'], 'w');
        end
    
        % Write to .txt file
        fprintf(fileId, [obj(i).RIC, ' & ',num2str(round2D(obj(i).BetaR1)),...
            ' & ', num2str(round2D(obj(i).BetaR2)),...
            ' & ', num2str(round2D(obj(i).BetaAll)),'\\\\','\r\n']);
    end
    
end

fclose(fileId);

function r = round2D(x)

r = round(100*x)/100;

