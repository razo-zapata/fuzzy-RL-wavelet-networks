function WAVENET = Wav4DRLSalidas(p,a,b,w,Nw)
% Este programa consiste en una estructura de wavenet, la cual solo calcula
% la salida actual para el patron "p" presentado.
%
% Los parametros son:
% p  = [x y z q];    Patron de entrada
% a  = [1];          Vector de escala
% b  = [x; y; z; q]; Vector de traslaciones en x, y, z y q
% w  = rand(1);      Vector de pesos sinapticos
% Nw = 1;            Numero de wavele seleccionada
% 

        % Cada una de las funciones base
        % size(a,2)
        % Existe el mismo numero de escalas, traslaciones en x en y en z y en q.
        % Se tiene una tupla de 4 f(a,bx,by,bz,bq)
        % for ci=1:size(b,2)
            % Para wavelets 4D
        %    G(ci) = (2^(a(ci)/2)) * Wav4D(Nw, ( (2^(a(ci))*p(1)) - b(1,ci)), ...
        %                                      ( (2^(a(ci))*p(2)) - b(2,ci)), ...
        %                                      ( (2^(a(ci))*p(3)) - b(3,ci)), ...
        %                                      ( (2^(a(ci))*p(4)) - b(4,ci)) );
        % end
        
        
        Tam = size(b,2);
        G = ( 2.^( (a(1))./2)) * Wav4D(Nw, ( (2.^(a(1:Tam)).*p(1)) - b(1,:)), ...
                                           ( (2.^(a(1:Tam)).*p(2)) - b(2,:)), ...
                                           ( (2.^(a(1:Tam)).*p(3)) - b(3,:)), ...
                                           ( (2.^(a(1:Tam)).*p(4)) - b(4,:)) );        
        
        % Para identificar la neurona con mayor activacion
        G2     = abs(G);
        Disp   = find( max(G2) == G2);
        % G2(Disp(1))
        
        % No existe soporte para el patron introducido
        if ( G2(Disp(1)) <= 0.2)
            % b  = [b [p(1)*(2^(a(1))) p(2)*(2^(a(1)))]' ];
            b  = [b [p(1)*(2^(a(1))) p(2)*(2^(a(1))) p(3)*(2^(a(1))) p(4)*(2^(a(1)))]' ];
            a  = [a a(1)];
            w  = [w; rand(1,size(w,2))];
            G2 = [G2 1];   
            % La neurona que dispara es la que se acaba de agregar
            % las neuronas estan representadas por fila, y sus pesos son
            % las columnas.
            Disp = size(w,1);
        end
        
        % Para cada una de las acciones
        NAcciones = size(w,2);
        SALIDA    = zeros(NAcciones,1);
        for ci = 1: NAcciones
            % Salida de la red, se debe probar con G y G2
            SALIDA(ci) = sum(G2*w(:,ci));
        end
        
    
WAVENET.p = p;
WAVENET.a = a;
WAVENET.b = b;
WAVENET.w = w;
WAVENET.Nw = Nw;
WAVENET.S  = SALIDA;

% Myw2 = Wav4DRLSalidas(p,t,Myw.a,Myw.b,Myw.w,Nw)