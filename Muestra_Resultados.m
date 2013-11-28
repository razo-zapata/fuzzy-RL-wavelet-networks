%   Muestra_Resultados
% PROGRAMA PARA MOSTRAR LOS RESULTADOS DEL ENTRENAMIENTO EJECUTADO SOBRE
% LA RED DE WAVENETS, PRESENTA ADEMÁS RESULTADOS DE LA OPERACION DE LA RED
% EN EL SISTEMA.
% 

% ARCHIVO QUE CONTIENE EL RESULTADO DEL ENTRENAMIENTO
load PendubotE5

% Numero de neuronas por espisodio
%  figure
%  plot(HIS_NEURONAS);
%  legend('Neuronas por episodio');
%  xlabel('Episodios');
%  ylabel('No. de Neuronas');

% Promedio de pasos por episodio
% figure
% plot(HIS_PROMEDIO);
% legend('Pasos');
% xlabel('Episodios');
% ylabel('Pasos por episodio');

% Comportamiento de las 4 variables.
% figure
% plot(ANGULOS(:,1),'r');
% legend('Variable x');
% xlabel('Tiempo * 0.01');
% ylabel('x');


% figure
% plot(ANGULOS(:,2),'b');
% legend('Variable \dot{x}');
% xlabel('Tiempo * 0.01');
% ylabel('\dot{x}');

% figure
% plot(ANGULOS(:,3),'g');
% legend('Variable \theta');
% xlabel('Tiempo * 0.01');
% ylabel('\theta');

% figure
% plot(ANGULOS(:,4),'k');
% legend('Variable \dot{\theta}');
% xlabel('Tiempo * 0.01');
% ylabel('\dot{\theta}');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FUNCION APROXIMADA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funcion aproximada para distintos valores de x y x^{.}

% LIMITES DE OPERACION
Maximos = [max(ANGULOS(:,1)) max(ANGULOS(:,3))]
Minimos = [min(ANGULOS(:,1)) min(ANGULOS(:,3))]

%Max2 = [max(ANGULOS(:,2)) max(ANGULOS(:,4))];
%Min2 = [min(ANGULOS(:,2)) min(ANGULOS(:,4))];
%X = [min(Min2):0.1:max(Max2)];

X = [-0.2:0.1:0.2]

L1      = [Minimos(1):0.01:Maximos(1)];
L2      = [Minimos(2):0.01:Maximos(2)];

%VL1     = [pi-0.1:0.01:pi+0.1];
%VL2     = [pi-0.1:0.01:pi+0.1];
VL1 = L1;
VL2 = L2;

[xx yy] = meshgrid(VL1,VL2);

for ci = 1:size(X,2)
    
    FA = xx.*0;
    for cx = 1:size(xx,1)
        for cy = 1:size(xx,2)
            MYW2   = Wav4DRLSalidas([VL1(cy) X(ci) VL2(cx) X(ci)],MYWAVENET.a,MYWAVENET.b,MYWAVENET.w,Nw);
            Maximo = max(MYW2.S); % Maximo valor de todas las acciones        
            FA(cx,cy) = Maximo;        
        end
    end
    figure
    surfc(xx,yy,FA);
%    title('FUNCION APROXIMADA');
%    xlabel('Eje x');
%    ylabel('Eje y');
%    zlabel('Eje z');
%    INGLES
    % ylabel('RR_n','FontName','Times','FontSize',12,'FontAngle','italic')
    title('Q-Function','FontName','Times','FontSize',20,'FontAngle','italic');
    xlabel('\theta','FontName','Times','FontSize',20);
    ylabel('\theta^{.}','FontName','Times','FontSize',20);
    zlabel('Expected rewards','FontName','Times','FontSize',20,'FontAngle','italic');
end


% ARCHIVO QUE CONTIENE EL RESULTADO DE LA FASE DE OPERACION

% Comportamiento de las 4 variables.
% figure
% load Resultados-CP-4-2500-280906-1050
% plot(ANGULOS(1:2000,3))
% axis([-2 2100 -0.2 0.2])