for s = 1:4
    
    %stockric = RIC{s};
    
    R1 = R(2:end,s);
    C = N(2:end,s);
    M = zeros(numel(R1));
    n = numel(R1);
    %M(1:n+1:end) = log(mean((V(:,s))));
    M(1:n+1:end) = 1;
    
    for i = 1:numel(R1)-1
        M(i+1:end,i) = C(1:end-i);
    end
    
    
    G(:,s) = M\R1;
    
end



    figure
    loglog(1:m-1,G)
    set(gca,'xscale','log')
    %legend(RIC(1:stocks))
    xlabel('Lag')
    ylabel('G_0')
    title('Bare response functions of 10 stocks')