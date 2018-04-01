%% recoverB3Plots.m -- Recover plots from E. Nonyane 2018, "Calculating the price response of stocks from emerging markets"
% Author E. Nonyane
% Date January 20, 2018

%% Clear workspace
clc
clear
close all

%% Take user inputs
fnum = input('Figure to recover (e.g 3.12, 3.19 etc): ', 's');
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

if ~strcmp(fnum, '3.14') && ~strcmp(fnum, '3.17') && ~strcmp(fnum, '3.20')
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
        
        if strcmp(fnum, '3.12') || strcmp(fnum, '3.13')
            plot(datamatrix(:,3*i - 2), datamatrix(:, 3*i - 1) , '-s', 'Color', C)
        else
            plot(datamatrix(:,3*i - 2), datamatrix(:, 3*i - 1) , 'Color', C)
        end
    end
    
    
    %% Format plot
    if strcmp(file, '3_12left.csv') || strcmp(file, '3_12right.csv') || strcmp(file, '3_13left.csv') || strcmp(file, '3_13right.csv')
        set(gca, 'xscale', 'log')
        set(gca, 'yscale', 'log')
        xlabel('$\omega$', 'interpreter', 'latex', 'fontsize', 20)
        ylabel('$\Delta p$', 'interpreter', 'latex', 'fontsize', 20)
        title(['Figure ' , fnum, ' ', '(' position, ')'] , 'fontsize', 15)
        
    elseif strcmp(file, '3_15left.csv') || strcmp(file, '3_16left.csv')
        set(gca, 'xscale', 'log')
        set(gca, 'yscale', 'log')
        xlabel('$\ell$', 'interpreter', 'latex', 'fontsize', 20)
        ylabel('$\mathcal{C}(\ell)$', 'interpreter', 'latex', 'fontsize', 20)
        title(['Figure ' , fnum, ' ', '(' position, ')'] , 'fontsize', 15)
        
    elseif strcmp(file, '3_15right.csv') || strcmp(file, '3_16right.csv')
        set(gca, 'xscale', 'log')
        xlabel('$\ell$', 'interpreter', 'latex', 'fontsize', 20)
        ylabel('$\sqrt{ \frac{\mathcal{D}(\ell)} {\ell} }$', 'interpreter', 'latex', 'fontsize', 20)
        title(['Figure ' , fnum, ' ', '(' position, ')'] , 'fontsize', 15)
        
    elseif strcmp(file, '3_18left.csv') || strcmp(file, '3_19left.csv')
        set(gca, 'xscale', 'log')
        xlabel('$\ell$', 'interpreter', 'latex', 'fontsize', 20)
        ylabel('$\mathcal{R}(\ell)$', 'interpreter', 'latex', 'fontsize', 20)
        title(['Figure ' , fnum, ' ', '(' position, ')'] , 'fontsize', 15)
        
    elseif strcmp(file, '3_18right.csv') || strcmp(file, '3_19right.csv')
        set(gca, 'xscale', 'log')
        set(gca, 'yscale', 'log')
        xlabel('$\ell$', 'interpreter', 'latex', 'fontsize', 20)
        ylabel('$G_0(\ell)$', 'interpreter', 'latex', 'fontsize', 20)
        title(['Figure ' , fnum, ' ', '(' position, ')'] , 'fontsize', 15)
    end
    
else
    if strcmp(fnum, '3.14')
        plot(datamatrix(:,1), datamatrix(:,2), '-s', 'Color', 'r')
        plot(datamatrix(:,3), datamatrix(:,4), '-s', 'Color', 'g')
        plot(datamatrix(:,5), datamatrix(:,6), '-s', 'Color', 'b')
        legend('Groupe 1', 'Group 2', 'Group 3')
        set(gca, 'xscale', 'log')
        set(gca, 'yscale', 'log')
        xlabel('$\omega$', 'interpreter','latex', 'fontsize', 20)
        ylabel('$\Delta p $', 'interpreter','latex', 'fontsize', 20)
        title(['Figure ' , fnum, ' ', '(' position, ')'] , 'fontsize', 15)
    elseif strcmp(fnum, '3.17') || strcmp(file, '3_20right.csv')
        plot(datamatrix(:,1), 'Color', 'r')
        plot(datamatrix(:,2), 'Color', 'g')
        plot(datamatrix(:,3), 'Color', 'b')
        set(gca, 'xscale', 'log')
        set(gca, 'yscale', 'log')
        title(['Figure ' , fnum, ' ', '(' position, ')'] , 'fontsize', 15)
    else
        plot(datamatrix(:,1), 'Color', 'r')
        plot(datamatrix(:,2), 'Color', 'g')
        plot(datamatrix(:,3), 'Color', 'b')
        set(gca, 'xscale', 'log')
        title(['Figure ' , fnum, ' ', '(' position, ')'] , 'fontsize', 15)
    end
end
