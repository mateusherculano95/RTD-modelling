function [H] = parametro_H(Dn, Na, Ln, Dp, Nd, Lp, ni)
%PARAMETRO_H Recebe os coeficientes e comprimentos de difusao no
%reservatorio e calcula o parametro H do modelo em Schulman, De Los Santos e 
%Chow (1996).
%   A funcao utiliza a Equacao 5 de Faria, da Nobrega e Duarte (2018)

     global echarge;

     H  = echarge*(ni^2)*(((Dn)/(Na*(Ln*1e-4))) + ((Dp)/(Nd*(Lp*1e-4))));    %Calculo do parametro H em A/cm2

end

