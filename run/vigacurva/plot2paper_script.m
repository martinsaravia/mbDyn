%-------------------------------------------------
%      GRAFICADOR DE CURVAS Y EXPORTADOR A EPS
%
% Martin Saravia - 10-08-2013
%
% Nota: Requiere GhostScript, export_file, pdftops
%       Ver export_file
%-------------------------------------------------
clc
clear all
addpath([cd '/pre/']); config ; 
addpath([cd '/plot/']);
%-------------------------------------------------
%                  PARAMETROS
%-------------------------------------------------

LPF = 0:1:10;
%-------------------------------------------------
%                 CURVAS
%-------------------------------------------------

% DESPLAZAMIENTOS
% load('arc45.mat')
% var1 = U(301:303,:);
% load('arc45_ss.mat')
% var2 = U(301:303,:);

%DEFORMACIONES
load('arc45.mat')
var1 = squeeze ( EE(1:3,2,:) );
load('arc45_ss.mat')
var2 = squeeze ( EE(1:3,2,:) );

 var1(:,1)=0;

h=figure(1);
set(h,'Position', [200, 200, 500, 300])
set(h, 'color', 'white')
hold on

p1=plot(var1,LPF);
set(p1, 'LineStyle', '.', 'LineWidth', 1.0, 'Color', 'Black');
% set(p2, 'Marker', 'o', 'MarkerFaceColor', [0.5 0.5 0.5], 'MarkerEdgeColor', [0 0 0], 'MarkerSize', 1.0);
p2=plot(var2,LPF);
set(p2, 'LineStyle', '-', 'LineWidth', 1.0, 'Color', 'Black');
% set(p1, 'Marker', 'x', 'MarkerFaceColor', [0.5 0.5 0.5],
% 'MarkerEdgeColor', [0 0 0], 'MarkerSize', 1.4);



set(gca,'FontSize',8,'FontName','Times','Box','on')
xlabel('Shear and Torsional Strains','FontSize',10,'FontName','Times'); 
ylabel('LPF','FontSize',10,'FontName','Times'); 
leg = legend('Large Strain Formulation','Present',2);
set(leg,'Interpreter','none','Location','NorthWest','FontSize',10)

%-------------------------------------------------
%             EXPORTACION FIGURA
%-------------------------------------------------
export_fig ('Figure 6.eps',-eps, h) 