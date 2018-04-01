function Cost = G0Cost(G0,L)
    l = (1:1000)';
    Cost = sum( ( G0 - L(1) * ((L(2)^2 + l.^2).^(-L(3)/2)) ).^2 );
end