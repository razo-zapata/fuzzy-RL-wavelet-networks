%%%%%%%%%%%%%%%%%%%%% V A R I A B L E S   D E L   S I S T E M A %%%%%%%%%%%%%%%%%%%%%
% Continua_RLWAVPendubot    

load Pendubot-DOWN-UP-1000-E5-021006-2308

iteraciones = 1000;
Itera_Max   = 2000; % 20 Segundos

figure

for Iter = 1 : iteraciones
    
    % Estado inicial
    if (mod(Iter,5) == 1)
        % Estado de inicio
        x0 = [0;0;pi;0];
    elseif (mod(Iter,2) == 1)
        % Estado aleatorio
        Signo   = rand;
        if (Signo < 0.5)
            Signo = -1;
        end
        EMinimo = 0.15 * Signo;
        %x0 = [EMinimo*rand; EMinimo*rand; EMinimo*rand; EMinimo*rand];
        x0 = [0;0;pi;0];
    else
        % Estado aleatorio
        Signo   = rand;
        if (Signo < 0.5)
            Signo = -1;
        end        
        EMaximo = 0.1 * Signo;
        %x0 = [EMaximo*rand; EMaximo*rand; EMaximo*rand; EMaximo*rand];
        x0 = [0;0;pi;0];
    end
    Inicial = x0;
    
    r = -1;
            
    % Crear primera neurona
    if (Crea == 0)
       MYWAVENET = Wavenet4DRL([x0'],[rand(1)],a,b,w,Nw,alpha,error,r,2); 
       Crea = 1;
    end
    
    ANGULOS    = [ANGULOS; x0'];
    HIS_REWARD = [HIS_REWARD; r];
    
    % Ciclo para episodios
    FIN        = 0;
    Tiempo_Epi = 0;
    Indtiempo  = 2;    
    
    while ( (r < 100) && (FIN == 0) )
        
        % Guarda estados
        x1  = x0(1);  x1p = x0(2);
        x2  = x0(3);  x2p = x0(4);        
        % ANGULOS = [ANGULOS; x0'];    

        % Seleccionar acci�n
        MYW2   = Wav4DRLSalidas([x1 x1p x2 x2p],MYWAVENET.a,MYWAVENET.b,MYWAVENET.w,Nw);
        Maximo = max(MYW2.S); % Maximo valor de todas las acciones        
        ep        = 0.1;
        p         = (ep/NumAcciones)*ones(1,NumAcciones);
        ind       = min( find( MYW2.S' == max(MYW2.S') ) );
        p(ind(1)) = 1-(NumAcciones-1)*(ep/NumAcciones);
        accion    = find(multrnd(1,p,1)==1);        
        %accion =  MySoftmax(MYW2.S',Temperatura);
        
        % Aplicar acci�n -> ode45
        r       = -1;
        if (CTC == TC)
            tau     = Acciones(accion);
            % Accion continua
            % ACon = FIS2(MYW2.S',Acciones);
            % tau  = ACon;            
            CTC = 0;
        end
        CTC = CTC + 1;
        % [T, Y]  = ode45(@cartpolecitis, [ts*(Indtiempo-2) ts*(Indtiempo-1)], x0, [], tau, P);
        [T, Y]  = ode45(@pendubot, [ts*(Indtiempo-2) ts*(Indtiempo-1)], x0, [], tau, P);        
        x0      = Y(end,:);
        ANGULOS = [ANGULOS; x0(1) x0(2) x0(3) x0(4)];
        
        % Calcular recompensa
        [S,r,Cambio] = Reward_L1(x0(1), x0(2), x0(3), x0(4), Limite);       
        FIN = Cambio;
        
        % Apredender wavenet
            % Calcular salidas de la red para el patron x0
            % determinar el maximo, y aprender sobre la accion elegida.
            MYW2      = Wav4DRLSalidas(x0',MYWAVENET.a,MYWAVENET.b,MYWAVENET.w,Nw);
            Maximo    = max(MYW2.S); % Maximo valor de todas las acciones
            SActual   = MYW2.S(accion);
            
            % Q - Learning --> Q(st, at) = Q(st, at) + alpha [r(t+1) + \gamma max(a)Q(st+1,a) - Q(st,at]
            MYWAVENET = Wavenet4DRL([x1 x1p x2 x2p],[gamma*Maximo],MYW2.a,MYW2.b,MYW2.w,Nw,alpha,error,r,accion);
            % for cac = 1: size(Acciones,2)
                % Q - Learning para cada acci�n
                % Q - Learning --> Q(st, at) = Q(st, at) + alpha [r(t+1) + \gamma max(a)Q(st+1,a) - Q(st,at]
                % MYWAVENET = Wavenet2DRL([Posicion Velocidad],[GAMA*Maximo],MYWAVENET.a,MYWAVENET.b,MYWAVENET.w,Nw,ALPHA2,Error,r,cac);            
            %     MYWAVENET = Wavenet4DRL([x1 x1p x2 x2p],[gamma*Maximo],MYW2.a,MYW2.b,MYW2.w,Nw,alpha,error,r,cac);
            % end
        
        % HISTORIALES
        if (r > 0)
            META    = [x0] 
            r
            CuentaV = CuentaV + 1;
            if (mod(CuentaV,10) == 0)
                save CarPoleFuzzyDatos1;   
            end
        end
        
        if(Tiempo_Epi > Itera_Max)
            FIN = 1;
        end
                       
        Tiempo_Epi = Tiempo_Epi + 1;        
        Tiempo_Total = Tiempo_Total + 1;
        
        HIS_REWARD = [HIS_REWARD; r];        
        HIS_ACCION = [HIS_ACCION; accion];
        HIS_NEURON = [HIS_NEURON; size(MYWAVENET.a,2) - 1];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%% ANIMACI�N %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% Animaci�n
            % Punto a rotar
            xx1 = 0;
            yy1 = -2;
            AN1 = x0(1); % CXD(i,1);
            AN2 = x0(3); % CXD(i,3);
        
            R  = [cos(AN1) -sin(AN1); sin(AN1) cos(AN1)];
            XY = R*[xx1 yy1]';
        
            % Rotamos el segundo brazo a AN2 grados del primero
            xc    = XY(1);
            yc    = XY(2);
            TETA1 = AN2;
        
            % Matriz de rotaci�n sobre el punto xc, yc
            RC = [ cos(TETA1) , -sin(TETA1) , xc*(1 - cos(TETA1)) + yc*sin(TETA1);
                   sin(TETA1) ,  cos(TETA1) , yc*(1 - cos(TETA1)) - xc*sin(TETA1);
                        0     ,      0      ,             1                       ];
        
            % Coordenadas del punto final del segundo brazo
            x2    = XY(1);
            y2    = XY(2)-2;
            % Segundo brazo rotado        
            XY2   = RC*[x2 y2 1]';
        
            plot([0 XY(1)],[0 XY(2)],[0 XY(1)],[0 XY(2)],'o',...
                 [xc XY2(1)],[yc XY2(2)],[xc XY2(1)],[yc XY2(2)],'d')
%            plot([0 XY(1)],[0 XY(2)],[0 XY(1)],[0 XY(2)],'o')
             
            axis([-5 5 -5 5])  
        
            text(-4.1,4.1,['\theta_1    = ',num2str(x0(1))])
            text(-4.1,3.1,['\theta_1^.  = ',num2str(x0(2))])
            text(-4.1,2.1,['\theta_2    = ',num2str(x0(3))])
            text(-4.1,1.1,['\theta_2^.  = ',num2str(x0(4))])
            
            text(1.1,4.1,['\theta_1    = ',num2str(Inicial(1))])
            text(1.1,3.1,['\theta_1^.  = ',num2str(Inicial(2))])
            text(1.1,2.1,['\theta_2    = ',num2str(Inicial(3))])
            text(1.1,1.1,['\theta_2^.  = ',num2str(Inicial(4))])            
            
            text(-4.1,0.1,['Efectivos   = ',num2str(CuentaV)])
            text(-4.1,-1.1,['Episodio   = ',num2str(Iter)])
            text(-4.1,-2.1,['Cuenta     = ',num2str(Tiempo_Epi)])
            text(-4.1,-3.1,['Accion     = ',num2str(tau)])        
            text(-4.1,-4.1,['Recompensa = ',num2str(r)])        
            text(1.1,-2.1,['Tiempo_T    = ',num2str(Tiempo_Total)])        
            text(1.1,-3.1,['No Neuronas = ',num2str(size(MYWAVENET.a,2))])
            text(1.1,-4.1,['Escala      = ',num2str(MYWAVENET.a(1))])        
            drawnow 
            
        %%%% Fin de Animaci�n
        
    end % Fin de while
    
    HIS_NEURONAS(Iter) = size(MYWAVENET.a,2) - 1;
    HIS_PROMEDIO(Iter) = Tiempo_Total / Iter;
    
end % Fin de for Iter

figure
subplot(2,1,1); plot(ANGULOS(:,1),'r');
subplot(2,1,2); plot(ANGULOS(:,2),'b');

figure
subplot(2,1,1); plot(ANGULOS(:,3),'g');
subplot(2,1,2); plot(ANGULOS(:,4),'k');

figure
plot(HIS_NEURONAS);
legend('Neuronas por episodio');
xlabel('Episodios');
ylabel('No. de Neuronas');

figure
plot(HIS_PROMEDIO);
legend('Pasos');
xlabel('Episodios');
ylabel('Pasos por episodio');
