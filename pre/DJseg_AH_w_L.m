%----------------------------------------------------------------------
%                SEGMENT PROPERTIES FOR LINEAL ELEMENT
%
%----------------------------------------------------------------------

function [D,DM] = DJseg_AH_w_L (nseg,C,wseg,s0,s1,Dy,Dz,Ds,y0,z0,dYs,dZs,dws)




A11=C(1,1); A16=C(1,2);               B11=C(1,4);  B16=C(1,5);   
            A66=C(2,2);                            B66=C(2,5); 
                          A55=C(3,3);   
                                      D11=C(4,4);  D16=C(4,5); 
                                                   D66=C(5,5); 
                                                   

%FORMULACION LINEAL 2011                                                   
% D = [A11*Ds -(B11*Dy) + (A11*Ds*(Dz + 2*z0))/2 B11*Dz + (A11*Ds*(Dy + ...
% 2*y0))/2 A16*Dy A16*Dz (B16*(Dy^2 + Dz^2) + A16*Ds*(Ds*dws + Dz*y0 - ...
% Dy*z0))/Ds;
% 
% -(B11*Dy) + (A11*Ds*(Dz + 2*z0))/2 (D11*Dy^2)/Ds - B11*Dy*(Dz + 2*z0) ...
% + (A11*Ds*(Dz^2 + 3*Dz*z0 + 3*z0^2))/3 (-6*D11*Dy*Dz + ...
% A11*Ds^2*(2*Dy*Dz + 3*Dz*y0 + 3*Dy*z0 + 6*y0*z0) + 3*B11*Ds*(-(Dy*(Dy ...
% + 2*y0)) + Dz*(Dz + 2*z0)))/(6*Ds) (Dy*((-2*B16*Dy)/Ds + A16*(Dz + ...
% 2*z0)))/2 (Dz*((-2*B16*Dy)/Ds + A16*(Dz + 2*z0)))/2 (Ds*(Ds*dws + ...
% Dz*y0 - Dy*z0)*(-2*B16*Dy + A16*Ds*(Dz + 2*z0)) + (Dy^2 + ...
% Dz^2)*(-2*D16*Dy + B16*Ds*(Dz + 2*z0)))/(2*Ds^2);
% 
% B11*Dz + (A11*Ds*(Dy + 2*y0))/2 (-6*D11*Dy*Dz + A11*Ds^2*(2*Dy*Dz + ...
% 3*Dz*y0 + 3*Dy*z0 + 6*y0*z0) + 3*B11*Ds*(-(Dy*(Dy + 2*y0)) + Dz*(Dz + ...
% 2*z0)))/(6*Ds) (A11*Ds*(Dy^2 + 3*Dy*y0 + 3*y0^2))/3 + Dz*((D11*Dz)/Ds ...
% + B11*(Dy + 2*y0)) (B16*Dy*Dz)/Ds + (A16*Dy*(Dy + 2*y0))/2 ...
% (B16*Dz^2)/Ds + (A16*Dz*(Dy + 2*y0))/2 -(-((Dy^2 + Dz^2)*(2*D16*Dz + ...
% B16*Ds*(Dy + 2*y0))) - Ds*(2*B16*Dz + A16*Ds*(Dy + 2*y0))*(Ds*dws + ...
% Dz*y0 - Dy*z0))/(2*Ds^2);
% 
% A16*Dy (Dy*((-2*B16*Dy)/Ds + A16*(Dz + 2*z0)))/2 (B16*Dy*Dz)/Ds + ...
% (A16*Dy*(Dy + 2*y0))/2 (A66*Dy^2 + A55*Dz^2)/Ds ((-A55 + ...
% A66)*Dy*Dz)/Ds (2*B66*Dy*(Dy^2 + Dz^2) + 2*A66*Ds*Dy*(Ds*dws + Dz*y0 ...
% - Dy*z0) - A55*Ds*Dz*(Dy^2 + Dz^2 + 2*Dy*y0 + 2*Dz*z0))/(2*Ds^2);
% 
% A16*Dz (Dz*((-2*B16*Dy)/Ds + A16*(Dz + 2*z0)))/2 (B16*Dz^2)/Ds + ...
% (A16*Dz*(Dy + 2*y0))/2 ((-A55 + A66)*Dy*Dz)/Ds (A55*Dy^2 + ...
% A66*Dz^2)/Ds (A55*Ds*Dy*(Dy^2 + 2*Dy*y0 + Dz*(Dz + 2*z0)) + ...
% 2*Dz*(B66*(Dy^2 + Dz^2) + A66*Ds*(Ds*dws + Dz*y0 - Dy*z0)))/(2*Ds^2);
% 
% (B16*(Dy^2 + Dz^2) + A16*Ds*(Ds*dws + Dz*y0 - Dy*z0))/Ds ...
% (-2*D16*Dy*(Dy^2 + Dz^2) + A16*Ds^2*(Dz + 2*z0)*(Ds*dws + Dz*y0 - ...
% Dy*z0) + B16*Ds*(-2*Ds*dws*Dy - 2*Dy*Dz*y0 + Dz^2*(Dz + 2*z0) + ...
% Dy^2*(Dz + 4*z0)))/(2*Ds^2) (2*D16*Dz*(Dy^2 + Dz^2) + B16*Ds*(Dy^3 + ...
% 2*Dy^2*y0 + 2*Dz*(Ds*dws + 2*Dz*y0) + Dy*Dz*(Dz - 2*z0)) + ...
% A16*Ds^2*(Dy + 2*y0)*(Ds*dws + Dz*y0 - Dy*z0))/(2*Ds^2) ...
% (2*B66*Dy*(Dy^2 + Dz^2) + 2*A66*Ds*Dy*(Ds*dws + Dz*y0 - Dy*z0) - ...
% A55*Ds*Dz*(Dy^2 + Dz^2 + 2*Dy*y0 + 2*Dz*z0))/(2*Ds^2) ...
% (A55*Ds*Dy*(Dy^2 + 2*Dy*y0 + Dz*(Dz + 2*z0)) + 2*Dz*(B66*(Dy^2 + ...
% Dz^2) + A66*Ds*(Ds*dws + Dz*y0 - Dy*z0)))/(2*Ds^2) (Ds^2*(Ds*dws + ...
% Dz*y0 - Dy*z0)*(B66*(Dy^2 + Dz^2) + A66*Ds*(Ds*dws + Dz*y0 - Dy*z0)) ...
% + Ds*(Dy^2 + Dz^2)*(D66*(Dy^2 + Dz^2) + B66*Ds*(Ds*dws + Dz*y0 - ...
% Dy*z0)) - (A55*Ds^3*((Dy*y0 + Dz*z0)^3 - (Dy*(Dy + y0) + Dz*(Dz + ...
% z0))^3))/(3*(Dy^2 + Dz^2)))/Ds^4];

%FORMULACION LINEAL 2013
D=[A11*Ds -(B11*Dy) + (A11*Ds*(Dz + 2*z0))/2 B11*Dz + (A11*Ds*(Dy + ...
2*y0))/2 A16*Dy A16*Dz (B16*(Dy^2 + Dz^2) + A16*Ds*(Ds*dws + Dz*y0 - ...
Dy*z0))/Ds;

-(B11*Dy) + (A11*Ds*(Dz + 2*z0))/2 (D11*Dy^2)/Ds - B11*Dy*(Dz + 2*z0) ...
+ (A11*Ds*(Dz^2 + 3*Dz*z0 + 3*z0^2))/3 (-6*D11*Dy*Dz + ...
A11*Ds^2*(2*Dy*Dz + 3*Dz*y0 + 3*Dy*z0 + 6*y0*z0) + 3*B11*Ds*(-(Dy*(Dy ...
+ 2*y0)) + Dz*(Dz + 2*z0)))/(6*Ds) (Dy*((-2*B16*Dy)/Ds + A16*(Dz + ...
2*z0)))/2 (Dz*((-2*B16*Dy)/Ds + A16*(Dz + 2*z0)))/2 (Ds*(Ds*dws + ...
Dz*y0 - Dy*z0)*(-2*B16*Dy + A16*Ds*(Dz + 2*z0)) + (Dy^2 + ...
Dz^2)*(-2*D16*Dy + B16*Ds*(Dz + 2*z0)))/(2*Ds^2);

B11*Dz + (A11*Ds*(Dy + 2*y0))/2 (-6*D11*Dy*Dz + A11*Ds^2*(2*Dy*Dz + ...
3*Dz*y0 + 3*Dy*z0 + 6*y0*z0) + 3*B11*Ds*(-(Dy*(Dy + 2*y0)) + Dz*(Dz + ...
2*z0)))/(6*Ds) (A11*Ds*(Dy^2 + 3*Dy*y0 + 3*y0^2))/3 + Dz*((D11*Dz)/Ds ...
+ B11*(Dy + 2*y0)) (B16*Dy*Dz)/Ds + (A16*Dy*(Dy + 2*y0))/2 ...
(B16*Dz^2)/Ds + (A16*Dz*(Dy + 2*y0))/2 -(-((Dy^2 + Dz^2)*(2*D16*Dz + ...
B16*Ds*(Dy + 2*y0))) - Ds*(2*B16*Dz + A16*Ds*(Dy + 2*y0))*(Ds*dws + ...
Dz*y0 - Dy*z0))/(2*Ds^2);

A16*Dy (Dy*((-2*B16*Dy)/Ds + A16*(Dz + 2*z0)))/2 (B16*Dy*Dz)/Ds + ...
(A16*Dy*(Dy + 2*y0))/2 (A66*Dy^2 + A55*Dz^2)/Ds ((-A55 + ...
A66)*Dy*Dz)/Ds (2*B66*Dy*(Dy^2 + Dz^2) + 2*A66*Ds*Dy*(Ds*dws + Dz*y0 ...
- Dy*z0) - A55*Ds*Dz*(Dy^2 + Dz^2 + 2*Dy*y0 + 2*Dz*z0))/(2*Ds^2);

A16*Dz (Dz*((-2*B16*Dy)/Ds + A16*(Dz + 2*z0)))/2 (B16*Dz^2)/Ds + ...
(A16*Dz*(Dy + 2*y0))/2 ((-A55 + A66)*Dy*Dz)/Ds (A55*Dy^2 + ...
A66*Dz^2)/Ds (A55*Ds*Dy*(Dy^2 + 2*Dy*y0 + Dz*(Dz + 2*z0)) + ...
2*Dz*(B66*(Dy^2 + Dz^2) + A66*Ds*(Ds*dws + Dz*y0 - Dy*z0)))/(2*Ds^2);

(B16*(Dy^2 + Dz^2) + A16*Ds*(Ds*dws + Dz*y0 - Dy*z0))/Ds ...
(-2*D16*Dy*(Dy^2 + Dz^2) + A16*Ds^2*(Dz + 2*z0)*(Ds*dws + Dz*y0 - ...
Dy*z0) + B16*Ds*(-2*Ds*dws*Dy - 2*Dy*Dz*y0 + Dz^2*(Dz + 2*z0) + ...
Dy^2*(Dz + 4*z0)))/(2*Ds^2) (2*D16*Dz*(Dy^2 + Dz^2) + B16*Ds*(Dy^3 + ...
2*Dy^2*y0 + 2*Dz*(Ds*dws + 2*Dz*y0) + Dy*Dz*(Dz - 2*z0)) + ...
A16*Ds^2*(Dy + 2*y0)*(Ds*dws + Dz*y0 - Dy*z0))/(2*Ds^2) ...
(2*B66*Dy*(Dy^2 + Dz^2) + 2*A66*Ds*Dy*(Ds*dws + Dz*y0 - Dy*z0) - ...
A55*Ds*Dz*(Dy^2 + Dz^2 + 2*Dy*y0 + 2*Dz*z0))/(2*Ds^2) ...
(A55*Ds*Dy*(Dy^2 + 2*Dy*y0 + Dz*(Dz + 2*z0)) + 2*Dz*(B66*(Dy^2 + ...
Dz^2) + A66*Ds*(Ds*dws + Dz*y0 - Dy*z0)))/(2*Ds^2) (Ds^2*(Ds*dws + ...
Dz*y0 - Dy*z0)*(B66*(Dy^2 + Dz^2) + A66*Ds*(Ds*dws + Dz*y0 - Dy*z0)) ...
+ Ds*(Dy^2 + Dz^2)*(D66*(Dy^2 + Dz^2) + B66*Ds*(Ds*dws + Dz*y0 - ...
Dy*z0)) - (A55*Ds^3*((Dy*y0 + Dz*z0)^3 - (Dy*(Dy + y0) + Dz*(Dz + ...
z0))^3))/(3*(Dy^2 + Dz^2)))/Ds^4];



% SECTION MASS MATRIX

I0 = zeros(3,3);

M = dia3(wseg*Ds); % Segment Mass

J = wseg * [-(dYs^2*s0^3)/3 - (dZs^2*s0^3)/3 + (dYs^2*s1^3)/3 + (dZs^2*s1^3)/3 - dYs*s0^2*y0 + dYs*s1^2*y0 - s0*y0^2 + s1*y0^2 - dZs*s0^2*z0 + dZs*s1^2*z0 - s0*z0^2 + s1*z0^2                      0                      0;
                0                      -(dZs^2*s0^3)/3 + (dZs^2*s1^3)/3 - dZs*s0^2*z0 + dZs*s1^2*z0 - s0*z0^2 + s1*z0^2                      ((s0 - s1)*(2*dYs*dZs*(s0^2 + s0*s1 + s1^2) + 3*dZs*(s0 + s1)*y0 + 3*dYs*(s0 + s1)*z0 + 6*y0*z0))/6;
                0                      ((s0 - s1)*(2*dYs*dZs*(s0^2 + s0*s1 + s1^2) + 3*dZs*(s0 + s1)*y0 + 3*dYs*(s0 + s1)*z0 + 6*y0*z0))/6                      -(dYs^2*s0^3)/3 + (dYs^2*s1^3)/3 - dYs*s0^2*y0 + dYs*s1^2*y0 - s0*y0^2 + s1*y0^2] ;

DM = [  M       I0 ; 
        I0      J  ];

%NOTE: J matrix is integrated in thickness


rn = y0*dZs-z0*dYs;
if rn <= 0
    disp(['WARNING: Negative normal coordinate for segment  ' num2str(nseg) ' '])
end

