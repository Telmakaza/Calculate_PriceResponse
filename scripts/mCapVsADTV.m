close all
for i = 1:33
    
    if ~isempty(Stocks(i).BPIM)
        M = Stocks(i).BPIM;
        M(isnan(M(:,1)),:) = [];
        M(M(:,2)==0) = [];
        y = M(:,2);
        x = [ones(size(M,1),1), M(:,1)];
        Beta = x\y;
        lambda(i) = Beta(1)^-10;
        ADTV(i) = mean((Stocks(i).normMarketCap));
    end
end
figure(1)
loglog(ADTV,lambda,'ms')
xlabel('$C$ : ADTV', 'Interpreter','latex','fontsize',20)
ylabel('$\lambda$  : Liquidity', 'Interpreter','latex','fontsize',20)
title('Liquidity vs ADTV')
