function [A] = criaescalar_A(mnb,gamma)
%CRIAESCALAR_A Esta funcao cria o coeficiente A
%   Para o calculo de A, sao necessarios: massa efetiva do reservatorio,
%   temperatura de operacao e a largura de ressonancia. Logo, este
%   parametro e diretamente afetado pelo tipo de liga semicondutora
%   utilizada e as caracteristicas fisicas do DBQW do dispositivo
     
     
     % A saida da funcao e em [A/m2]

     global k hbar echarge T;
     gamma1 = gamma*echarge;                                     %Conversao da largura de ressonancia de eV para J
     A       = (echarge*mnb*k*T*gamma1)/(4*(pi^2)*(hbar^3));     %Engloba a massa efetiva, e a largura de ressonancia  
     
end

