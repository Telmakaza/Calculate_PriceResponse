%% recoverB3Plots.m -- Recover plots from E. Nonyane 2018, "Calculating the price response of stocks from emerging markets"
% Author E. Nonyane
% Date January 20, 2018

%% Clear workspace
clc
clear
close all

%% Take user inputs
fnum = input('Figure to recover (e.g 3.22, 3.27 etc): ', 's');
position = input('Position of figure in dissertation (left (l) or right (r)): ', 's');
switch position
    case 'r'
        position = 'right';
    case 'l'
        position = 'left';
end

%% Load data
file = [fnum(1), '_', fnum(3:end), position, '.csv'];
datamatrix = load(file);

%% Construct plot
figure
hold on
[~, N] = size(datamatrix);

for i = 1:N/3
    
    % Set plot color according
    switch datamatrix(1,3*i)
        case 1
            C = 'r';
        case 2
            C = 'g';
        case 3
            C = 'b';
    end
    
    if strcmp(fnum, '3.22') || strcmp(fnum, '3.23')
        plot(datamatrix(:,3*i - 2), datamatrix(:, 3*i - 1) , '-s', 'Color', C)
    else
        plot(datamatrix(:,3*i - 2), datamatrix(:, 3*i - 1) , 'Color', C)
    end
end


%% Format plot
if strcmp(file, '3_22left.csv') || strcmp(file, '3_22right.csv') || strcmp(file, '3_23left.csv') || strcmp(file, '3_23right.csv')
    set(gca, 'xscale', 'log')
    set(gca, 'yscale', 'log')
    xlabel('$\omega$', 'interpreter', 'latex', 'fontsize', 20)
    ylabel('$\Delta p$', 'interpreter', 'latex', 'fontsize', 20)
    title(['Figure ' , fnum, ' ', '(' position, ')'] , 'fontsize', 15)
    
elseif strcmp(file, '3_24left.csv') || strcmp(file, '3_25left.csv')
    set(gca, 'xscale', 'log')
    set(gca, 'yscale', 'log')
    xlabel('$\ell$', 'interpreter', 'latex', 'fontsize', 20)
    ylabel('$\mathcal{C}(\ell)$', 'interpreter', 'latex', 'fontsize', 20)
    title(['Figure ' , fnum, ' ', '(' position, ')'] , 'fontsize', 15)
    
elseif strcmp(file, '3_24right.csv') || strcmp(file, '3_25right.csv')
    set(gca, 'xscale', 'log')
    set(gca, 'yscale', 'log')
    xlabel('$\ell$', 'interpreter', 'latex', 'fontsize', 20)
    ylabel('$\sqrt{ \frac{\mathcal{D}(\ell)} {\ell} }$', 'interpreter', 'latex', 'fontsize', 20)
    title(['Figure ' , fnum, ' ', '(' position, ')'] , 'fontsize', 15)
    
elseif strcmp(file, '3_26left.csv') || strcmp(file, '3_27left.csv')
    set(gca, 'yscale', 'log')
    set(gca, 'xscale', 'log')
    xlabel('$\ell$', 'interpreter', 'latex', 'fontsize', 20)
    ylabel('$\mathcal{R}(\ell)$', 'interpreter', 'latex', 'fontsize', 20)
    title(['Figure ' , fnum, ' ', '(' position, ')'] , 'fontsize', 15)
    
elseif strcmp(file, '3_26right.csv') || strcmp(file, '3_27right.csv')
    set(gca, 'xscale', 'log')
    set(gca, 'yscale', 'log')
    xlabel('$\ell$', 'interpreter', 'latex', 'fontsize', 20)
    ylabel('$G_0(\ell)$', 'interpreter', 'latex', 'fontsize', 20)
    title(['Figure ' , fnum, ' ', '(' position, ')'] , 'fontsize', 15)
end
