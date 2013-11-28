function [accion] = MySoftmax(Q,temp)
% function [accion] = MySoftmax(Q,temp,Ntile,Ntiling)
% Q - Vector de acciones
% temp - temperatura

    Qt     = Q;
    PR     = exp(Qt/temp);
    if sum(PR) <= 0
        AuxM  = max(Qt);
        PR(1) = AuxM;
        % save ERROR PR Q Qt temp Ntile Ntiling AuxM;
    end
    PR     = PR/sum(PR);  %Calcula las probabilidades de escoger cada una de las acciones
    accion = find( multrnd(1,PR,1) == 1); %Selecciona la accion a partir de las probabilidades