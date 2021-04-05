function [m] = MKII_massa(z, iteracoes, Lb, Lw, mb, mnb)
% *** Descricao ***
% Esta funcao recebe o perfil de potencial e o numero de iteracoes
% utilizados para o construir e completa um vetor de massas efetivas
% enquanto percorre o perfil

% *** Versoes ***
% Versao 0: Recebe o numero de iteracoes, o vetor de posicoes do sistema, 
% as massas e os L(1 a 5) para construir o vetor de massas efetivas
% Versao 1: Pre alocacao de m

% Conversão das larguras de Angstrom para metro

     L1 = 10e-10;
     L2 = Lb*1e-10;
     L3 = Lw*1e-10;
     L4 = Lb*1e-10;

     m = zeros(size(z));                                        %Cria o vetor m ja com o tamanho correspondente a z

     for i = 1:iteracoes                                        %Laco para completar o vetor
         if z(i) <= L1                                          %Verifica se a posicao e na pre-barreira
             m(i) = mnb;                                        %Se sim, m(i) recebe a massa da nao barreira
         elseif z(i) > L1 && z(i) < (L2+L1)                     %Senao, verifica se a posicao e na primeira barreira
             m(i) = mb;                                         %Se sim, m(i) recebe a massa da barreira
         elseif z(i) >= (L2+L1)    && z(i) <= (L3+L2+L1)        %Senao, verifica se a posicao e no poco
             m(i) = mnb;                                        %Se sim, m(i) recebe a massa da nao barreira 
         elseif z(i) >  (L3+L2+L1) && z(i) <  (L4+L3+L2+L1)     %Senao, verifica se a posicao e na segunda barreira
             m(i) = mb;                                         %Se sim, m(i) recebe a massa da barreira
         else                                                   %Senao, a posicao esta na pos-barreira
             m(i) = mnb;                                        %m(i) recebe a massa da nao barreira
         end                                                    %Fim da estrutura condicional
     end                                                        %Fim do laco
end                                                             

