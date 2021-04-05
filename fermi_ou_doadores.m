function [Ef,Nd] = fermi_ou_doadores(Nc, Nd, Ef)
%FERMI_OU_DOADORES A funcao recebe a densidade de estados efetivos na banda
%de conducao no reservatorio (Nc [cm-3]), a concentracao de doadores no
%reservatorio (Nd [cm-3]), a energia de Fermi (Ef [eV]) e retorna o valor
%que faltar
%   Verifica-se qual entrada tem valor nulo (Nd ou Ef) e procede calculando
%   um ou outro de acordo com a Equacao 7 de Faria, da Nobrega e Duarte 
%   (2018).

     global k T echarge;

     k_eV = k/echarge;
     
     if Ef == 0
     
         Ef = -k_eV*T*log(Nc/Nd);               %Calculo da Energia de Fermi com referencia no limite inferior da banda de conducao [eV] (Eq 7)
     
     elseif Nd == 0
         
         Nd = (Nc)/(exp((-Ef)/(k_eV*T)));
         
     end

end

