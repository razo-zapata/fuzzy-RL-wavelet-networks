function [X,r,Cambio] = Reward_L1(teta1, teta1p, teta2, teta2p, Limite)
%
% function [X,r] = Reward_L1(teta1, teta1p, teta2, teta2p, Limite)
%
% Esta funcion calcula el reward para el entrenamiento del Link1 del
% pendubot. Recibe la configuracion del estado en el que se encuentra el
% pendubot, es decir, las cuatro variables que conforman el estado: teta,
% teta1, teta2, teta2p. Ademas de un Limite de error.
% 
% Las Recompensas se asignan de la siguiente manera:
% IF (ANG1 > (5/4)*pi

Rango = (pi*5/180); % 5 grados

ANG1 = abs(teta1);        % Angulo
VEL1 = abs(teta1p);       % Velocidad
DIF1 = abs(ANG1 - pi); % Diferencia entre pi y Angulo


ANG2 = abs(teta2);
VEL2 = abs(teta2p);
DIF2 = abs(ANG2 - pi);

X = [teta1;...
     teta1p;...
     teta2;...
     teta2p];

% SI HUBO CAMBIO DE ESTADO
Cambio = 0;

% Para aquellos estados desconocidos
r = -10;

if ( (DIF1 > Rango) || (DIF2 > Rango) ) % Fuera de los puntos de operación
    r      = -10;
    Cambio = 1;
elseif( DIF1 <= Limite )
    r = -3;
    if( DIF2 <= Limite )
        r = -2;
        if( VEL1 <= Limite )
            r = -1;
            if( VEL2 <= Limite )
                r = 1;
            end
        end
    end
elseif((DIF1 <= Rango) || (DIF2 <= Rango) )
    r = -5;
end