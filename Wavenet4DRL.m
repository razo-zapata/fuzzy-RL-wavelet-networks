function WAVENET = Wavenet4DRL(p,t,a,b,w,Nw,alpha,Error,Reward,accion)
% Este programa consiste en una estructura de wavenet, dentro de la cual se
% realiza un entrenamiento en linea de la wavenet a medida que se van
% presentando patrones de entrada.
%
% Los parametros son:
% p  = [x y z q];    Patron de entrada
% t  = [0.5];        Valor objetivo
% a  = [1];          Vector de escala
% b  = [x; y; z; q]; Vector de traslaciones en x, y, z y q
% w  = rand(1);      Vector de pesos sinapticos
% Nw = 1;            Numero de wavele seleccionada
% alpha  = 0.2;      Tasa de aprendizaje
% Error  = Error anteriror
% Reward = Valor de señal de refuerzo
% accion = accion elegida
% 
% Si es necesario se agregaran neuronas a la wavenet para cubrir en su
% totalidad el espacio de acciones.

HisActiva  = [];

    if isempty(b)
        b  = [b [p(1)*(2^(a(1))) p(2)*(2^(a(1))) p(3)*(2^(a(1))) p(4)*(2^(a(1)))]' ];
        a  = [a  a(1)];
        w  = [w];
        k  = 1;
        S  = (2^(a(1)/2)) * Wav4D(Nw, ( (2^(a(1))*p(1)) - b(1,1)), ...
                                      ( (2^(a(1))*p(2)) - b(2,1)), ...
                                      ( (2^(a(1))*p(3)) - b(3,1)), ...
                                      ( (2^(a(1))*p(4)) - b(4,1)));
        SALIDA = S * w(1,accion);
        % Error
        Error  = (t - SALIDA)^2;
        
        G = S;
        
        % Neuronas Activadas
        NA = [1];        
    else
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
            G  = [G 1];
            % La neurona que dispara es la que se acaba de agregar
            % las neuronas estan representadas por fila, y sus pesos son
            % las columnas.
            Disp = size(w,1);
        end
        
        % Salida de la red, se debe probar con G y G2
        SALIDA = sum(G2*w(:,accion));
        
        % Peso de neurona a modificar, el que mas activo la neurona
        k = Disp(1);
        
        % Error
        Error = (t - SALIDA)^2;
        
        % Neuronas Activadas
        NA = find( (G2 >= 0.0000001) );
    end    
    
    TotalNeuronas = size(NA,2);
    
    for ci = 1: TotalNeuronas
        % Ajustar pesos
        % Q - Learning --> Q(st, at) = Q(st, at) + alpha [r(t+1) + \gamma max(a)Q(st+1,a) - Q(st,at]
        % w(k,accion) = w(k,accion) + alpha * ( Reward + ( t - SALIDA ) );
        % w(NA(ci),accion) = w(NA(ci),accion) + alpha * ( Reward + ( t - SALIDA ) );
    
        % Q(st, at) = Q(st, at) + alpha [r(t+1) + T max(a)Q(st+1,a) - Q(st,at] * Gradiente ( wi(j) )
        
        
        Activacion = abs(G(NA(ci)));
        HisActiva  = [HisActiva; Activacion];
        % Incremento = alpha * ( ( Reward + ( t - SALIDA ) ) ) * ( Activacion / a(1));
        Incremento = alpha * ( ( Reward + ( t - SALIDA ) ) ) * ( (1)*Activacion);
        
        % w(NA(ci),accion) = w(NA(ci),accion) + alpha * ( -2 * ( Reward + ( t - SALIDA ) ) * (Activacion));
        w(NA(ci),accion) = w(NA(ci),accion) + Incremento;        
        
    end
       
WAVENET.p = p;
WAVENET.t = t;
WAVENET.a = a;
WAVENET.b = b;
WAVENET.w = w;
WAVENET.Nw = Nw;
WAVENET.S  = SALIDA;
WAVENET.alpha = alpha;
WAVENET.Error = Error;
WAVENET.Activa = G;