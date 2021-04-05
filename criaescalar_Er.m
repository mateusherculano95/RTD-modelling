function [C] = criaescalar_Er(Trans_log,E)
%CRIAESCALAR_ER Funcao para encontrar a energia de ressonancia do sistema
%   Esta funcao percorre o vetor do coeficiente de transmissao ate
%   encontrar a posicao de ressonancia e, entao determina no vetor de
%   energias a energia de ressonancia

     m = size(Trans_log);                             %Escalar m com as dimensoes do vetor de coeficiente de transmissao
     ressonancia = findpeaks(Trans_log);              %Encontra o pico de ressonancia
     for posicao = 1:(m(2))                           %Executa o laco ate percorrer todo o vetor do coeficiente de transmissao
          if Trans_log(posicao) == ressonancia(1)     %Verifica se encontrou a posicao de ressonancia
               R = posicao;                           %Se sim, salva a posicao
               break;                                 %Saida forcada do laco
          end                                         %Fim do condicional
     end                                              %Fim do laco
     C = E(R);                                        %A energia de ressonancia e encontrada na posicao R do vetor de energias de incidencia
end

