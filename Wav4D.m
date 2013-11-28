function [z] = Wav4D(w,x,y,z,q)
% WAVELETS EN 4 DIMENSIONES
% function [z] = Wav4D(w,x,y,z,q)
% w - wavelet base
% x - rango eje x
% y - rango eje y
% z - rango eje z
% q - rango eje q
       
switch w
    case 1
        % Primer eje
        z1 = (2 / (sqrt(3*sqrt(pi))) )*(1 - (x).^2);
        z2 = exp( (-(x).^2) / 2); 
        z3 = z1.*z2;
        
        % Segundo eje
        z4 = (2 / (sqrt(3*sqrt(pi))) )*(1 - (y).^2);
        z5 = exp( (-(y).^2) / 2); 
        z6 = z4.*z5;
        
        % Tercer eje
        z7 = (2 / (sqrt(3*sqrt(pi))) )*(1 - (z).^2);
        z8 = exp( (-(z).^2) / 2); 
        z9 = z7.*z8;
        
        % Cuarto eje
        z10 = (2 / (sqrt(3*sqrt(pi))) )*(1 - (q).^2);
        z11 = exp( (-(q).^2) / 2); 
        z12 = z10.*z11;
        
        z  = z3.*z6.*z9.*z12;
        
        %z  = z./4;
    otherwise
        z  = x;
end

% Funciona
% close, clear all
% x = [-1:0.1:1];
% y = [-1:0.1:1];
% z = [-1:0.1:1];
% q = [-1:0.1:1];
% a = [1];    % a = [2....]
% bx = [0];
% by = [0];
% bz = [0];
% bq = [0];
% (2^(a(1)/2)) * Wav4D(1, ( (2^(a(1))*x) - bx(1)), ( (2^(a(1))*y) - by(1)), ( (2^(a(1))*z) - bz(1)) , ( (2^(a(1))*q) - bq(1)) )
% plot((2^(a(1)/2)) * Wav4D(1, ( (2^(a(1))*x) - bx(1)), ( (2^(a(1))*y) - by(1)), ( (2^(a(1))*z) - bz(1)) , ( (2^(a(1))*q) - bq(1)) ))