function x = calMovingAV(C,L)
%CALMOVINGAV calculates the moving average of a time series
% x = CALMOVINGAV(C,l) calculates the l day moving average of time series l

% Get the size of time series
n = length(C);

% Initialize moving avarage vector
x = zeros(n-L,1);

% Calculate the moving avarage
for i = 1:n-L
    Cvec = C(i:i+L);
    x(i) = mean(Cvec(Cvec~=0));
end