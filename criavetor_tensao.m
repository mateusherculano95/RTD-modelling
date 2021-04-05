function [V_tensao] = criavetor_tensao(V_max,qte_ponto_tensao)
%CRIAVETOR_TENSAO Esta funcao cria um vetor para armazenar valores de
%tensao DC
%   A funcao recebe um valor de tensao maxima (por exemplo, 2,5V) e a
%   quantidade de pontos desejada no vetor. Dividindo-se um pelo outro, o
%   passo da amostra de tensao e encontrado. Por fim um vetor e construido
%   e retornado ao usuario.

     h_V      = V_max/qte_ponto_tensao;                        %Passo da amostra de tensao
     V_tensao = 0:h_V:V_max;                                   %Vetor com a amostra de tensao

end

