%% groupedPR6Y - calculate average price response over six years
% Author: E. Nonyane
% Date: November 18, 2017

%% Clear workspace
clc
clear
close all

%% Configure paths

addpath('C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\Classes')
addpath('C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\functions')

%% Set initial paramers
Market = 'SSE';
Year = cell(7);
for j = 0:6
    Year{j+1} = ['201',num2str(j)];
end

%% Initialize price response curves

CL = zeros(1000,7,3);
DL = zeros(1000,7,3);
RL = zeros(1000,7,3);
BPI = zeros(20,7,3);
BV = zeros(20, 7, 3);
SPI = zeros(20,7,3);
SV = zeros(20,7,3);
G0 = zeros(1000,7,3);

% Grouped parameters
GCL = zeros(1000,3);
GRL = zeros(1000,3);
GDL = zeros(1000,3);
GG0 = zeros(1000,3);
GBPI = zeros(20,3);
GBV = zeros(20,3);
GSPI = zeros(20,3);
GSV = zeros(20,3);

%% Loop over data and populate initalised matrices

for y = 0:6
    temp = loadGroupedPR(Market, Year{y+1});
    for g = 1:3
        CL(:,y+1,g) = temp(g).CL;
        DL(:,y+1,g) = temp(g).DL;
        RL(:,y+1,g) = temp(g).RL;
        G0(:,y+1,g) = temp(g).G0;
        
        nb = numel(temp(g).BPIM(:,2));
        ns = numel(temp(g).SPIM(:,1));
        
        BPI(1:nb,y+1,g) = temp(g).BPIM(:,2);
        BV(1:nb,y+1,g) = temp(g).BPIM(:,1);
        SPI(1:ns,y+1,g) = temp(g).SPIM(:,2);
        SV(1:ns,y+1,g) = temp(g).SPIM(:,1);
    end
    
    for g = 1:3
        GCL(:,g) = mean(CL(:,:,g),2);
        GDL(:,g) = mean(DL(:,:,g),2);
        GRL(:,g) = mean(RL(:,:,g),2);
        GG0(:,g) = mean(G0(:,:,g),2);
        GBPI(:,g) = mean(BPI(:,:,g),2);
        GSPI(:,g) = mean(SPI(:,:,g),2);
        GBV(:,g) = mean(BV(:,:,g),2);
        GSV(:,g) = mean(SV(:,:,g),2);
    end
end

%% Initialize price response objects to store results
groupedStocks(3) = PriceResponse;

%% Save price response object
for m = 1:3
    groupedStocks(m).CL = GCL(:,m);
    groupedStocks(m).BPIM = [GBV(:,m),GBPI(:,m)];
    groupedStocks(m).SPIM = [GSV(:,m),GSPI(:,m)];
    groupedStocks(m).G0 = GG0(:,m);
    groupedStocks(m).Market = Market;
end

fullFilePath = ['C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\Market Information\', Market, '\GroupedStocks2\groupedStocks.mat'];
save(fullFilePath, 'groupedStocks');

%% Construct plots
for i = 1:6
    figure(i)
    hold on
    box on
end

market = Market;

switch Market
    case 'BVSP'
        Market = 'B3';
    case 'ESE'
        Market = 'EGX';
end

% Create data storage matrices
datacl = nan(1000,3);
datadl = nan(1000,3);
datarl = nan(1000,3);
datag0 = nan(1000,3);
databpi = nan(20,6);
dataspi = nan(20,6);




% Save price impact
nb1 = numel(GBV(:,1));
nb2 = numel(GBV(:,2));
nb3 = numel(GBV(:,3));
databpi(1:nb1,1) = GBV(:,1);
databpi(1:nb1,2) = GBPI(:,1);
databpi(1:nb2,3) = GBV(:,2);
databpi(1:nb2,4) = GBPI(:,2);
databpi(1:nb3,5) = GBV(:,3);
databpi(1:nb3,6) = GBPI(:,3);
csvwrite(['C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\plotdata\', Market, '\3_58left.csv'], databpi)


ns1 = numel(GSV(:,1));
ns2 = numel(GSV(:,2));
ns3 = numel(GSV(:,3));
dataspi(1:ns1,1) = GSV(:,1);
dataspi(1:ns1,2) = -GSPI(:,1);
dataspi(1:ns2,3) = GSV(:,2);
dataspi(1:ns2,4) = -GSPI(:,2);
dataspi(1:ns3,5) = GSV(:,3);
dataspi(1:ns3,6) = -GSPI(:,3);
csvwrite(['C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\plotdata\', Market, '\3_58right.csv'], dataspi)


% Save data CL
ncl1 = numel(GCL(:,1));
ncl2 = numel(GCL(:,2));
ncl3 = numel(GCL(:,3));
datacl(1:ncl1,1) = GCL(:,1);
datacl(1:ncl2,2) = GCL(:,2);
datacl(1:ncl3,3) = GCL(:,3);
csvwrite(['C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\plotdata\', Market, '\3_61left.csv'], datacl)

% Save DL
ndl1 = numel(GDL(:,1)); L1 = (1:ndl1)';
ndl2 = numel(GDL(:,2)); L2 = (1:ndl2)';
ndl3 = numel(GDL(:,3)); L3 = (1:ndl3)';
datadl(1:ndl1,1) = sqrt(GDL(:,1)./L1);
datadl(1:ndl2,2) = sqrt(GDL(:,2)./L2);
datadl(1:ndl3,3) = sqrt(GDL(:,3)./L3);
csvwrite(['C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\plotdata\', Market, '\3_61right.csv'], datadl)

% Save RL
nrl1 = numel(GRL(:,1));
nrl2 = numel(GRL(:,2));
nrl3 = numel(GRL(:,3));
datarl(1:nrl1,1) = GRL(:,1);
datarl(1:nrl2,2) = GRL(:,2);
datarl(1:nrl3,3) = GRL(:,3);
csvwrite(['C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\plotdata\', Market, '\3_64left.csv'], datarl)

% Save G0
ngl1 = numel(GG0(:,1));
ngl2 = numel(GG0(:,2));
ngl3 = numel(GG0(:,3));
datag0(1:ngl1,1) = GG0(:,1);
datag0(1:ngl2,2) = GG0(:,2);
datag0(1:ngl3,3) = GG0(:,3);
csvwrite(['C:\Users\ENonyane\Documents\MATLAB\ENonyane_PR\plotdata\', Market, '\3_64right.csv'], datag0)


% Format plots
figure(1)
plot(GCL(:,1), 'Color', 'r')
plot(GCL(:,2), 'Color', 'g')
plot(GCL(:,3), 'Color', 'b')
legend('Groupe 1', 'Group 2', 'Group 3')
set(gca, 'xscale', 'log')
set(gca, 'yscale', 'log')
xlabel('$\ell$', 'interpreter','latex', 'fontsize', 20)
ylabel('$\mathcal{C}(\ell)$', 'interpreter','latex', 'fontsize', 20)
title(['Jan 2010 to May 2016 daily average trade sign autocorrelation curves for ', Market,' stock groups'], 'fontsize', 10)

figure(2)
L = 1:1000;
plot(sqrt(GDL(:,1)./L'), 'Color', 'r')
plot(sqrt(GDL(:,2)./L'), 'Color', 'g')
plot(sqrt(GDL(:,3)./L'), 'Color', 'b')
legend('Groupe 1', 'Group 2', 'Group 3')
set(gca, 'xscale', 'log')
set(gca, 'yscale', 'log')
xlabel('$\ell$', 'interpreter','latex', 'fontsize', 20)
ylabel('$\sqrt{\frac{\mathcal{D}(\ell)}{\ell}}$', 'interpreter','latex', 'fontsize', 20)
title(['Jan 2010 to May 2016 daily average  $\sqrt{D(\ell)/\ell}$ curves for ', Market,' stock groups'], 'fontsize', 10, 'interpreter', 'latex')

figure(3)
plot(GRL(:,1), 'Color', 'r')
plot(GRL(:,2), 'Color', 'g')
plot(GRL(:,3), 'Color', 'b')
legend('Groupe 1', 'Group 2', 'Group 3')
set(gca, 'xscale', 'log')
xlabel('$\ell$', 'interpreter','latex', 'fontsize', 20)
ylabel('$\mathcal{R}(\ell)$', 'interpreter','latex', 'fontsize', 20)
title(['Jan 2010 to May 2016 daily average price response coefficient curves for ', Market,' stock groups'], 'fontsize', 10)

figure(4)
plot(GG0(:,1), 'Color', 'r')
plot(GG0(:,2), 'Color', 'g')
plot(GG0(:,3), 'Color', 'b')
legend('Groupe 1', 'Group 2', 'Group 3')
set(gca, 'xscale', 'log')
set(gca, 'yscale', 'log')
xlabel('$\ell$', 'interpreter','latex', 'fontsize', 20)
ylabel('$G_0(\ell)$', 'interpreter','latex', 'fontsize', 20)
title(['Jan 2010 to May 2016 daily average bare response curves for ', Market,' stock groups'], 'fontsize', 10)

figure(5)
plot(GBV(:,1), GBPI(:,1), '-s', 'Color', 'r')
plot(GBV(:,2), GBPI(:,2), '-s', 'Color', 'g')
plot(GBV(:,3), GBPI(:,3), '-s', 'Color', 'b')
legend('Groupe 1', 'Group 2', 'Group 3')
set(gca, 'xscale', 'log')
set(gca, 'yscale', 'log')
xlabel('$\omega$', 'interpreter','latex', 'fontsize', 20)
ylabel('$\Delta p $', 'interpreter','latex', 'fontsize', 20)
title(['Jan 2010 to May 2016 buyer initiated average price impact curves for ', Market,' stock groups'], 'fontsize', 10)

figure(6)
plot(GSV(:,1), -GSPI(:,1), '-s', 'Color', 'r')
plot(GSV(:,2), -GSPI(:,2), '-s', 'Color', 'g')
plot(GSV(:,3), -GSPI(:,3), '-s', 'Color', 'b')
legend('Groupe 1', 'Group 2', 'Group 3')
set(gca, 'xscale', 'log')
set(gca, 'yscale', 'log')
xlabel('$\omega$', 'interpreter','latex', 'fontsize', 20)
ylabel('$-\Delta p $', 'interpreter','latex', 'fontsize', 20)
title(['Jan 2010 to May 2016 seller initiated price impact curves for ', Market,' stock groups'], 'fontsize', 10)

%% Save plots

disPath = ['C:\Users\ENonyane\Desktop\PR_Plots\', market, '\GroupedStocks\'];
priceResFun = {'CL','DL','RL','G0L','BPI','SPI'};
for i = 1:6
    F = figure(i);
    %set(figure(i), 'units','normalized','outerposition',[0 0 1 1])
    saveas(F,[disPath, priceResFun{i},'.pdf']);
end

close all
