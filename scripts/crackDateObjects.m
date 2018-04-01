%% crackDateObjects: 
% This script imports the GroupedPrice Response of the JSE and plots master
% curves
% Author: E.Nonyane
% Date: 19-Jul-2017


%% Clear workspace

clc
clear
close all

%% Configure paths
addpath('C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Classes')
%addpath('C:\Users\MSS_Mster\Documents\MATLAB\ENonyane_PR\Classes')

%% Import GroupedPriceResponse objects and plot master curves

for i = 1:6
    figure(i)
    hold on
end


N = 25;

uGRL = zeros(1000,N);
uGCL = uGRL;
uGDL = uGRL;
uGG0 = uGRL;

inputFileName = 'ESE3MonthsNumTradesDateObj';

for i = 1:N
    
    filePath = ...
        'C:\Users\MSS_Master\Documents\MATLAB\ENonyane_PR\Market Information\ESE\dateObjectsNumTrades\';
         dateObjectStruct = load([filePath,inputFileName,num2str(i)]);
         
         % Extract the date ObjectMatric
         dateOjbectMatrix = dateObjectStruct.dateObjectMatrix;
         
         % Get the size of the dateObjectMatrix
         [r, c] = size(dateOjbectMatrix);
         
         % Initialise grouped price response functions
         GRL = zeros(1000,c);
         GCL = GRL;
         GDL = GRL;
         GG0 = GRL;
         
         for j = 1:r
             for k = 2:c
                 GRL(:,k) = dateOjbectMatrix(j,k).GRL;
                 GDL(:,k) = dateOjbectMatrix(j,k).GDL;
                 GCL(:,k) = dateOjbectMatrix(j,k).GCL;
                 GG0(:,k) = dateOjbectMatrix(j,k).GG0;
             end
             
             for k = c:-1:1
                 if ~any(GG0(:,k))
                     GRL(:,k) = [];
                     GDL(:,k) = [];
                     GCL(:,k) = [];
                     GG0(:,k) = [];
                 end
             end
             
             GRL = mean(GRL,2);
             GDL = mean(GDL,2);
             GCL = mean(GCL,2);
             GG0 = mean(GG0,2);
             
             xxx(:,i) = GRL;
             uGRL(:,i) = GRL;
             uGDL(:,i) = GDL;
             uGCL(:,i) = GCL;
             uGG0(:,i) = GG0;
             
             if i == N
                 uGRL(:,any(isnan(uGRL))) = [];
                 uGDL(:,any(isnan(uGDL))) = [];
                 uGCL(:,any(isnan(uGCL))) = [];
                 uGG0(:,any(isnan(uGG0))) = [];
                 
                 uGRL = mean(uGRL,2);
                 uGDL = mean(uGDL,2);
                 uGCL = mean(uGCL,2);
                 uGG0 = mean(uGG0,2);
                 
                 C = rand(1,3);
                 
                 figure(1)
                 plot(uGCL,'color',C)
                 set(gca,'xscale','log')
                 set(gca,'yscale','log')
                 ylabel('$\mathcal{C}(\ell)$','Interpreter','latex','fontsize',20)
                 xlabel('$\ell$','Interprete','latex','fontsize',20)
                 box on
                 
                 L = 1:1000;
                 
                 normDL = uGDL./L';
                 
                 figure(2)
                 plot(normDL,'color',C)
                 set(gca,'xscale','log')
                 xlabel('$\ell$','Interpreter','latex','fontsize',20)
                 ylabel('$\sqrt{\frac{\mathcal{D}(\ell)}{\ell}}$','Interpreter','latex','fontsize',20)
                 box on
                 
                 figure(3)
                 plot(uGRL,'color',C)
                 set(gca,'xscale','log')
                 ylabel('$\mathcal{R}(\ell)$','Interpreter','latex','fontsize',20)
                 xlabel('$\ell$','Interprete','latex','fontsize',20)
                 box on
                 
                 figure(4)
                 plot(uGG0,'color',C)
                 set(gca,'xscale','log')
                 set(gca,'yscale','log')
                 ylabel('$G_0(\ell)$','Interpreter','latex','fontsize',20)
                 xlabel('$\ell$','Interprete','latex','fontsize',20)
                 box on
                 
                 figure(5)
                 plot(dateOjbectMatrix(j,1).GBPIM(:,1),dateOjbectMatrix(j,1).GBPIM(:,2),'-s','color',C)
                 set(gca,'xscale','log')
                 set(gca,'yscale','log')
                 ylabel('$\Delta p$','Interpreter','latex','fontsize',20)
                 xlabel('$\omega$','Interprete','latex','fontsize',20)
                 box on
                 
                 figure(6)
                 plot(dateOjbectMatrix(j,1).GSPIM(:,1),-dateOjbectMatrix(j,1).GSPIM(:,2),'-s','color',C)
                 set(gca,'xscale','log')
                 set(gca,'yscale','log')
                 ylabel('$\Delta p$','Interpreter','latex','fontsize',20)
                 xlabel('$\omega$','Interprete','latex','fontsize',20)
                 box on
                 
             end
             
         end
                 
         
end



