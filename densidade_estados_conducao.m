function [Nc] = densidade_estados_conducao(me)
%DENSIDADE_ESTADOS_CONDUCAO A funcao recebe a massa efetiva do eletron no
%reservatorio (me [kg]) e retorna a densidade efetiva de estados na banda
%de conducao (cm-3)
%   O calculo e realizado pela Equacao 8 de Faria, da Nobrega e Duarte 
%   (2018).

     global k T hbar

     Nc = (1e-6)*2*(((me*k*T)/(2*pi*(hbar^2)))^(3/2));     %Calcula o Nc em cm-3 (Eq 8)

end

