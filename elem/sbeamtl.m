%=========================================================================
%
%                               SBEAM ELEMENT MATRICES
%
% Note: Updated for new things on 04/10/2011
%==========================================================================
function [X,gdof,m,kt,kg,fie,fde,fme,SE,EE,AV] = sbeamtl(FE,X,E,N,D,DM,U,Ui,Vel,Acc,FD,FI,FM,SE,EE,el,AV)

disp(' ACTUALIZAR ELEMENTO TOTAL LAGRANGIANO PORQUE LAS FUERZAS INERCIALES ESTAN PREPARADAS PARA SER INCREMENTALES, POR ESO NO ANDA EL TL')
%-----------------------------------------------------------------------------------------------
nxel = 2;      nn1 = E(el,4);         nn2 = E(el,5);   
secid = E(el,3); %Element Section
%-----------------------------------------------------------------------------------------------

I0=zeros(3,3);
longel=sqrt( (N(nn2,2)-N(nn1,2))^2 + (N(nn2,3)-N(nn1,3))^2 + (N(nn2,4)-N(nn1,4))^2);

% -------------------------   VARIABLES NODALES  ------------------------------------
udofn1=X.CTable(nn1,1:3);       udofn2=X.CTable(nn2,1:3);  % DOF de Desplazamientos
rdofn1=X.CTable(nn1,4:6);       rdofn2=X.CTable(nn2,4:6);  % DOF de Rotaciones
gdof = [ udofn1 rdofn1     udofn2 rdofn2];  

phi1=U(rdofn1,X.tstep+1);            phi2=U(rdofn2,X.tstep+1);              % Rotaci�n Incremental
x0n1 = N(nn1,2:4)' +  U(udofn1,X.tstep+1);                 x0n2 = N(nn2,2:4)' + U(udofn2,X.tstep+1);                          % Posici�n actual

% R1 = X.Rr(nn1*3-2:nn1*3,:) *  expmap(phi1);          R2 = X.Rr(nn2*3-2:nn2*3,:) * expmap(phi2); % Rotacion total  
R1 =  expmap(phi1);                 R2 = expmap(phi2); % Rotacion total  
T1 =  tangmap (phi1);               T2 = tangmap (phi2);   

en1= R1 * AV(el*3-2:el*3,1:3,1);                     en2= R2 * AV(el*3-2:el*3,4:6,1); % Current Configuration Triad
AV(el*3-2:el*3,1:6,X.tstep+1)= [ en1  en2 ];  % Guardo las ternas actuales 


se2n1=skew(en1(:,2));    se3n1=skew(en1(:,3)); %OJO CAMBIO DE SIGNO
se2n2=skew(en2(:,2));    se3n2=skew(en2(:,3)); %OJO CAMBIO DE SIGNO 


% -------------------------   VARIABLES EN ip1, eta=0  ------------------------------------
% Funciones de forma y sus derivadas en ip=0;
N1=0.5;         N2=0.5;           dN1=-1/longel;    dN2=1/longel;
NI=dia3(N1);         dNI=dia3(dN1);   jac=longel/2; 
     
phiip1=N1*phi1+N2*phi2 ;   Tip1=tangmap(phiip1); 

ei = N1*en1 + N2*en2;        ei2=ei(:,2);       ei3=ei(:,3);
de = dN1*en1 + dN2*en2;      de2=de(:,2);       de3=de(:,3);
dx0 = dN1*x0n1 + dN2*x0n2;  
sei3=skew( N1*en1(:,3)+N2*en2(:,3) ); 
sdx0=skew(dx0);          sde2=skew(de2);  sde3=skew(de3);


% -------------------------------------------------------------------------------------------
%%                                  T A N G E N T      M A T R I C E S 
% --------------------------------------------------------------------------------------------

%% -------------------------------------- TANGENT OF INTERNAL FORCES ---------------------------------------
km=zeros(12,12); kg=zeros(12,12); kt=zeros(12,12); H = zeros (9,18);   G = zeros(18,18);
nips=1; %1 Point Integrations

% Beam Strains and Stresses
EE(1,el,X.tstep+1) = 0.5*( dx0'*dx0 - EE(1,el,1) ); % Axial Strain
EE(2,el,X.tstep+1) = dx0'*de3 - EE(2,el,1);  
EE(3,el,X.tstep+1) = dx0'*de2 - EE(3,el,1); 
EE(4,el,X.tstep+1) = dx0'*ei2 - EE(4,el,1); 
EE(5,el,X.tstep+1) = dx0'*ei3 - EE(5,el,1); 
EE(6,el,X.tstep+1) = de2'*ei3 - EE(6,el,1);
EE(7,el,X.tstep+1) = de2'*de2 - EE(7,el,1);
EE(8,el,X.tstep+1) = de3'*de3 - EE(8,el,1);
EE(9,el,X.tstep+1) = de2'*de3 - EE(9,el,1);

SE(1:9,el,X.tstep+1) = D(:,:,secid) * EE(1:9,el,X.tstep+1);  % Total Beam Stresses

Nax1=SE (1,el,X.tstep+1);    M2=SE (2,el,X.tstep+1);     M3=SE (3,el,X.tstep+1);     Q2=SE (4,el,X.tstep+1);  Q3=SE(5,el,X.tstep+1);    
M1=SE(6,el,X.tstep+1);       P2=SE(7,el,X.tstep+1);      P3=SE(8,el,X.tstep+1);      P23=SE(9,el,X.tstep+1);  % Rename Beam Stresses


% H Matrix - Evaluated at integration point ip=0
H(1,1:3) = dx0';
H(2,1:3) = de3';                                                                         H(2,16:18) = dx0';
H(3,1:3) = de2';                                                  H(3,13:15) = dx0';
H(4,1:3) = ei2';    H(4,7:9) = dx0';
H(5,1:3) = ei3';                         H(5,10:12) = dx0';
                                         H(6,10:12) = de2';       H(6,13:15) = ei3';
                                                                  H(7,13:15) = 2*de2';
                                                                                         H(8,16:18) = 2*de3' ;
                                                                  H(9,13:15) = de3' ;    H(9,16:18) = de2' ;       
                                                                  
% B Matrix - B = [Bj   Bj]
B = [       dNI                I0                -dNI                I0           ;
            I0                 NI                 I0                 NI           ;    
            I0           N1 * se2n1' * T1'        I0           N2 * se2n2' * T2'    ;
            I0           N1 * se3n1' * T1'        I0           N2 * se3n2' * T2'    ;     
            I0          dN1 * se2n1' * T1'        I0          dN2 * se2n2' * T2'    ;
            I0          dN1 * se3n1' * T1'        I0          dN2 * se3n2' * T2'    ];
 
        
        

% A Matrix arising from linealization of Virtual Strains xiT( f_cross( en1(:,3),dx0 ),phi1)
% BE CAREFULL - AAAn MUST BE FED WITH TOTAL BEAM STRESSES


AAAn1 = ( M2*dN1+Q3*N1 )*( xiT( f_cross( en1(:,3),dx0 ),phi1)+T1*sdx0*se3n1*T1' ) + ...
        ( M3*dN1+Q2*N1 )*( xiT( f_cross( en1(:,2),dx0 ),phi1)+T1*sdx0*se2n1*T1' ) + ... 
         M1 * ( dN1*     (xiT( f_cross( en1(:,2),ei3 ),phi1)+T1*sei3*se2n1*T1') + N1*( xiT(f_cross(en1(:,3),de2),phi1)+T1*sde2*se3n1*T1') ) + ...
         2*P2 * dN1 * (xiT( f_cross(en1(:,2),de2) ,phi1)+T1*sde2*se2n1*T1') + ... 
         2*P3 * dN1 * (xiT( f_cross(en1(:,3),de3) ,phi1)+T1*sde3*se3n1*T1') + ... 
         P23 * dN1 * ( (xiT( f_cross(en1(:,2),de3 ),phi1)+T1*sde3*se2n1*T1') + (xiT( f_cross(en1(:,3),de2) ,phi1)+T1*sde2*se3n1*T1') ); 
  
AAAn2 = ( M2*dN2+Q3*N2 )*( xiT( f_cross(en2(:,3),dx0) ,phi2)+T2*sdx0*se3n2*T2' ) + ... 
        ( M3*dN2+Q2*N2 )*( xiT( f_cross(en2(:,2),dx0) ,phi2)+T2*sdx0*se2n2*T2' ) + ...
          M1 * ( dN2*(xiT( f_cross(en2(:,2),ei3) ,phi2) + T2*sei3*se2n2*T2') + N2*(xiT( f_cross(en2(:,3),de2) ,phi2)+T2*sde2*se3n2*T2') ) + ...
          2*P2 * dN2 * (xiT( f_cross(en2(:,2),de2) ,phi2)+T2*sde2*se2n2*T2') + ...
          2*P3 * dN2 * (xiT( f_cross(en2(:,3),de3) ,phi2)+T2*sde3*se3n2*T2') + ... 
          P23 * dN2 * ( (xiT( f_cross(en2(:,2),de3) ,phi2)+T2*sde3*se2n2*T2') + (xiT( f_cross(en2(:,3),de2) ,phi2)+T2*sde2*se3n2*T2') ); 
    
      

% G Matrix
G(1:3,1:3) = dia3(Nax1);                                G(1:3,7:9)=dia3(Q2);         G(1:3,10:12)=dia3(Q3);       G(1:3,13:15)=dia3(M3);        G(1:3,16:18)=dia3(M2);
                           G(4:6,4:6) = AAAn1+AAAn2;
G(7:9,1:3)=dia3(Q2);
G(10:12,1:3)=dia3(Q3);                                                                                          G(10:12,13:15)=dia3(M1); 
G(13:15,1:3)=dia3(M3);                                                              G(13:15,10:12)=dia3(M1);     G(13:15,13:15)= 2*dia3(P2);   G(13:15,16:18)= dia3(P23);
G(16:18,1:3)=dia3(M2);                                                                                          G(16:18,13:15)= dia3(P23);    G(16:18,16:18)= 2*dia3(P3);


% Element Tangent Stifness Matrix 

sw = int1d (nips);
for i=1:nips
    if strcmp(FE.step{1},'buckle')==1
        km = sw(2,i) * (B' * H' * D(:,:,secid) * H * B) * jac;
        kg = sw(2,i) * (B' * G * B) * jac;
        kt = km + kg;
    else
        kt = sw(2,i) * (B' * ( H'*D(:,:,secid)*H + G ) * B) * jac;
    end
end


%%  -------------------------------------- TANGENT OF EXTERNAL FORCES --------------------------------------- 
kl=zeros(12,12);   N=zeros(6,6*nxel);   nips=1;



% if nn2 == 51
%    
%    Dmsn = N2 * FE.sforce(1,5:7)'; %concentrated spatial incremental moment
%    
%    lip1 =  [ I0             I0         ;
%              I0       xiT(Dmsn,phiip1) ];  % Only for 1 point integration
% 
%     sw = int1d (nips); % Numerical Integration
%     for i=1:nips
%         for j=1:6
%             N(j,j) = ( 1 - sw(1,i) ) / 2;     N(j,j+6) = ( 1 + sw(1,i) ) / 2;
%         end  
%         kl = sw(2,i) * (N' * lip1 * N) * jac   + kl; % Concentrated spatial (fixed) Moment Term
%     end


    
    
%     kl = zeros(12,12); kl(10:12,10:12) = xiT(Dmsn,phi2);
%     
%     el
%     kl
%     max(max(kl))
%     
% end

%%  -------------------------------------- TANGENT OF INERTIAL FORCES ---------------------------------------
% NOT CONSIDERED


%%  -------------------------------------- TANGENT KERNEL  ---------------------------------------

kt = kt + kl;



%%  -------------------------------------- TANGENT MASS MATRIX  ---------------------------------------    
%%  -------------------------------------- TANGENT MASS MATRIX  ---------------------------------------    
m=zeros(12,12);   
if strcmp(FE.step{1,3},'DYNAMIC')==1
    N=zeros(6,6*nxel);   nips=2; mip1=zeros(6,6);  %1 Point Integration
    DMel=DM(:,:,secid);      mip1(1:3,1:3) = DMel(1:3,1:3);
    mip1(4:6,4:6) = Tip1' * DMel(4:6,4:6) * Tip1; % m en punto de integracion eta=0
    sw = int1d (nips); % Numerical Integration
    for i=1:nips
        for j=1:6
            N(j,j) = ( 1 - sw(1,i) ) / 2;     N(j,j+6) = ( 1 + sw(1,i) ) / 2;
        end   
        m = sw(2,i) * (N' * mip1 * N) * jac   + m;
    end
end



% -------------------------------------------------------------------------------------------
%%                               F O R C E    V E C T O R S 
% --------------------------------------------------------------------------------------------

%% -------------------------------- TOTAL INTERNAL FORCES  -----------------------------------------
fie = zeros(12,1); N=zeros(1,6*nxel); nips = 1;
sw = int1d (nips);
for i=1:nips
    for j=1:6
        N(1,j) = ( 1 - sw(1,i) ) / 2;     N(1,j+3) = ( 1 + sw(1,i) ) / 2;
    end  
    fie = sw(2,i) * ( (H*B)' * SE(1:9,el,X.tstep+1)) * jac + fie;     % Total Internal Force
end

%% -------------------------------- TOTAL INERTIA FORCES  -----------------------------------------
fme=zeros(12,1);

if strcmp(FE.step{1,3},'DYNAMIC')==1
    fme = m * Acc(gdof,X.tstep+1) ; % Linear part of INCREMENTAL inertia forces with respect to accelerations
end

%% -------------------------------- INCREMENTAL EXTERNAL ELEMENT FORCES  -----------------------------------------
% notar que las fuerzas nodales no se aplican en la rutina del elemento, solo se aplican las fuerzas distribuidas, de cuerpo, etc.

fde = zeros(12,1);  N=zeros(1,6*nxel);   nips = 1; % Numerical Integration Points
sw = int1d (nips); 

if isfield(FE,'bforce')==1 % GRAVITY Loads - Assuming that they act in the inertia centroid (no tangent terms because of inertia excentricity)
    grav = zeros(12,1);
    grav([FE.dyn{7} FE.dyn{7}+6],1) = FE.dyn{6};
    fde = m * grav; % Gravitational Force, Only traslational terms
end
   









    
    
    
