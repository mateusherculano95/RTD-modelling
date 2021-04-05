function [E] = criavetor_incidencia(E_max,qte_ponto_incidencia)
%CRIAVETOR_INCIDENCIA Esta funcao cria um vetor para armazenar valores de
%energia de incidencia do eletron na DBQW
%   A funcao recebe um valor de energia maxima (por exemplo, 1 eV) e a
%   quantidade de pontos desejada no vetor. Dividindo-se um pelo outro, o
%   passo da amostra de energia e encontrado. Por fim um vetor e construido
%   e retornado ao usuario.

     h_E = E_max/qte_ponto_incidencia;     %Passo da amostra de tensao
     E   = 0.0001:h_E:E_max;               %Vetor com a amostra de tensao

end

