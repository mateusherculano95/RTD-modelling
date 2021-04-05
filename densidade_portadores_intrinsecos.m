function [ni] = densidade_portadores_intrinsecos(me, mh, Eg)
%DENSIDADE_PORTADORES_INTRINSECOS A funcao recebe a massa efetiva do 
%eletron no reservatorio (me [kg]), a massa efetiva da lacuna no 
%reservatorio (mh [kg]), a energia de gap no reservatorio (Eg [eV]) e 
%retorna a densidade de portadores intrinsecos (cm-3)
%   O calculo e realizado pela Equacao 6 de Faria, da Nobrega e Duarte 
%   (2018).

%Chamando os parametros da simulacao
     global k T hbar echarge;

     num1    = k.*T;
     den1    = 2*pi*(hbar^2);
     razao1  = (num1./den1).^(3/2); 
     massas  = me*mh;
     massas1 = massas.^(3/4);
     num2    = -Eg*echarge;
     den2    = 2*k.*T;
     razao2  = num2./den2;
     
     ni      = (1e-6)*2.*razao1.*massas1.*exp(razao2);         %Calcula o ni em cm-3 (Eq 6)
end

