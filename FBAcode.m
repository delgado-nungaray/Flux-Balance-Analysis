%  Programa para la optimizacion de rutas metabolicas
%  F L U X     B A L A N C E     A N A L Y S I S
%  Laboratorio de Bioinformatica e Ing. Metabolica
%  Universidad de Guadalajara
%  (c)Orfil Gonzalez Reynoso
%  17 de marzo de 2011
%  Version 1.0
%  30 de enero de 2024
%  Version 1.1

%  Primer paso abrir la matriz estequiometrica
clear
clc
format longG    
% Archivo donde se tienen las reacciones estequiométricas
    arch = 'iJD1249_run.xlsx';
    
    [S, R] = xlsread(arch, 'Run');

% Numero de flujos de intercambio (nfi)     

    nfi=205;    
    [Aeq,metabolito]=genmatriz(S,R,nfi);


% archivo para determinar los limites de los flujos de intercambio

   [S1,R1]= xlsread(arch, 'Bounds'); 

%  Determinando rango de la matriz

   [nr,nc]=size(Aeq);

   beq=zeros(nr,1);

   fluinternos = nc - nfi;

% limites de las recciones internas
    lb=zeros(nc,1);
    ub=zeros(nc,1);

   for i=1:fluinternos; 
       lb(i)=0;
       ub(i)=100;
   end
                  
       
%  limites de los flujos de intercambio
       cont=0;
    for i = fluinternos+1:nc
        cont=cont+1;
        lb(i)=S1(cont,1);
        ub(i)=S1(cont,2);
    end

%  Definición de la funcion objetivo f
 
    f=zeros(nc,1);

%  DEFINICION DE LA FUNCION OBJETIVO - Biomasa y PvdQ
    
    %f(251)=1;
    f([251,825])=1;
    f=-f;
    
    disp ( '  LA SOLUCION ENCONTRADA ES LA SIGUIENTE')

% llamando la subrutina de optimización
    
   OPTIONS = optimoptions('linprog', 'Algorithm', 'dual-simplex', 'Display', 'iter');
   [x,fval,exitflag,output,lambda]=linprog(f,[],[],Aeq,beq,lb,ub,OPTIONS);
   
 
      numero=1:nc;
      numero=numero';
      valores=[numero,x];
      disp(valores);


     fprintf(' Biomasa = %6.4f\n\n',fval)
     fprintf(' Biomasa = %6.4f PvdQ = %3.4f\n\n',x(251),x(825))
  
    
     
     spy(Aeq);



arch = 'Analysis for gene deletion.xlsx';  
data = readtable(arch);

% Extract relevant columns
rxns = data{:, 1};  % Reaction IDs
flux_biomass = data{:, 2};  % Flux when maximizing biomass
flux_biomass_pvdq = data{:, 6};  % Flux when maximizing biomass + PvdQ

flux_shift = flux_biomass_pvdq - flux_biomass;

threshold = 90;  % Define a meaningful threshold
significant_rxns = abs(flux_shift) > threshold & (flux_biomass_pvdq == 0);

% Create a table with filtered results
filtered_results = table(rxns(significant_rxns), flux_biomass(significant_rxns), flux_biomass_pvdq(significant_rxns), ...
    'VariableNames', {'Reaction', 'Flux_Biomass', 'Flux_Biomass_PvdQ'});

% Display results
disp(filtered_results);