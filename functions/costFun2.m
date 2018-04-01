function  epsilon = costFun2(cdLiq,dp,omega,L)

c = cdLiq(1);
d = cdLiq(2);
%C = cdLiq(3);

%L = 0.8;

epsilon = mean( abs( (L^-d)*dp - omega/(L^c) ) );