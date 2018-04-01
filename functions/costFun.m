function epsilon = costFun(DG,C,dp,omega)

delta = DG(1);
gamma = DG(2);

M = median(omega);

binidx = zeros(numel(dp),1);

for i = 1:numel(omega)
    if omega(i) <= M
        binidx(i) = 1;
    else 
        binidx(i) = 2;
    end
end

%binidx = PriceResponse.binData(omega,binEdges);

muDp = zeros(1,2);
muOmega = zeros(1,2);
sigmaDp = zeros(1,2);
sigmaOmega = zeros(1,2);

for i = 1:2
    muDp(i) = mean(dp(binidx==i)*C^gamma);
    muOmega(i) = mean(omega(binidx==i)/C^delta);
    sigmaDp(i) = std(dp(binidx==i)*C^gamma);
    sigmaOmega(i) = std(omega(binidx==i)/C^delta);
end

sigmaOmega(isnan(muDp)|muDp == 0 ) = [];
sigmaDp(isnan(muDp)| muDp == 0) = [];

muOmega(isnan(muDp)|muDp == 0 ) = [];
muDp(isnan(muDp)| muDp == 0) = [];

muOmega(isnan(sigmaDp)| sigmaDp == 0) = [];
muDp(isnan(sigmaDp) | sigmaDp == 0) = [];

sigmaOmega(isnan(sigmaDp)| sigmaDp == 0) = [];
sigmaDp(isnan(sigmaDp) | sigmaDp == 0) = [];

epsilon = mean((sigmaDp./muDp).^2 + (sigmaOmega./muOmega).^2);