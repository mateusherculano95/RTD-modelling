function [z, iteracoes] = MKII_posicionamento(dz, Lb, Lw)
%POSICIONAMENTO Constroi um vetor com as posicoes discretizadas do sistemas
%em simulacao
%   Primeiramente, a funcao calcula o comprimento total do sistema e o
%   numero de iteracoes para um laco que completa o vetor de posicoes z.
%   para otimizacao, o vetor z e pre-alocado
     
     L1        = 10;     
     L2        = Lb;
     L3        = Lw;
     L4        = Lb; 
     L5        = 10;
     L_total   = (L1+L2+L3+L4+L5)*1e-10;     %Comprimento total do sistema
     iteracoes = L_total/dz;                 %Calcula a quantidade de iteracoes (e o tamanho dos vetores) a partir da largura total do sistema e do passo da simulacao

     sizeiteracoes = uint64(iteracoes);      %Arredonda o numero de iteracoes 
     z = ones([1 sizeiteracoes]);            %Cria um vetor z com o numero de posicoes igual ao numero de iteracoes
     
     for i = 1:iteracoes                     %Roda a quantidade de iteracoes determinada acima
     
          if i == 1                          %Verifica se e a primeira iteracao 
               z(i) = 0;                     %Primeira posicao de z e 0
          else                               %Senao 
               z(i) = z(i-1) + dz;           %A posicao atual de z vale o valor anterior somado ao passo da simulacao
          end                                %Fim da estrutura condicional
       
     end                                     %Fim do laco
end

