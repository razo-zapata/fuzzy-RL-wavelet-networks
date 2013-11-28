function xdot = pendubot(t,x,tau,P)
% function xdot = pendubot(t,x,tau,P)

% P es el vector de constantes
m1  = P(1);  % masa 1
m2  = P(2);  % masa 2
l1  = P(3);  % longitud brazo 1
l2  = P(4);  % longitud brazo 2
lc1 = P(5);  % distancia al centro de masa de b1
lc2 = P(6);  % distancia al centro de masa de b2
I1  = P(7);  % inercia brazo 1
I2  = P(8);  % inercia brazo 2
g   = 9.81;  % gravedad m/s^2
             %   time step 0.05
% variables de estado
%x
%t
%tao
%P

teta1  = rem(x(1),2*pi);
teta1p = min(4*pi, max( -4*pi, x(2)));
teta2  = rem(x(3),2*pi);
teta2p = min(9*pi, max( -9*pi, x(4)));

phi2 = (m2*lc2)*g*cos(teta1 + teta2 - pi/2);

phi1 = -(m2*l1*lc2*teta2p^2)*sin(teta2)- 2*m2*l1*lc2*teta2p*teta1p*sin(teta2)+(m1*lc1 + m2*l1)*g*cos(teta1-pi/2)+phi2;

d2 = m2*(lc2^2 + l1*lc2*cos(teta2)) + I2;

d1 = m1*lc1^2+m2*(l1^2 + lc2^2 + 2*l1*lc2*cos(teta2))+ I1 + I2;

% ecuaciones diferenciales
%x4p = (tau + d2*phi1/d1 - m2*l1*lc2*(teta1p^2)*sin(teta2) - phi2) / (m2*(lc2^2) +I2 - (d2^2)/d1);
x4p = (d2*phi1/d1 - m2*l1*lc2*(teta1p^2)*sin(teta2) - phi2) / (m2*(lc2^2) +I2 - (d2^2)/d1);
x3p = teta2p;
%x2p = - (d2 * x4p + phi1)/d1;
x2p = tau - (d2 * x4p + phi1)/d1;
x1p = teta1p;

% Limitando valor de los angulos
x3pf = min(4*pi,max(-4*pi,x3p));
x1pf = min(9*pi,max(-9*pi,x1p));

% Limitando valor de las velocidades angulares
x4pf = min(9*pi,max(-9*pi,x4p));
x2pf = min(9*pi,max(-9*pi,x2p));

xdot= [ x1pf; x2pf; x3pf; x4pf ];
