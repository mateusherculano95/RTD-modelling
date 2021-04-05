function [Trans] = MKI_coef_transmissao(N,m,E,V,z)

% *** Descricao ***
% Esta funcao sera implementada no codigo para calculo da densidade de
% corrente de tunelamento. O codigo base para esta funcao e a versao 7 da
% engine MKVI para contraste de Dresselhaus

% *** Versao ***
% Versao 0: Retirada do calculo do log natural para corrigir o calculo da
% corrente

     j_max     = length(E);      %Escalar com o tamanho do vetor com energias do eletron

     global echarge hbar;
     
     eye       = sqrt(-1);       %Reconfiguracao do parametro eye

     k     = zeros(size(z));     %Cria vetor com o tamanho do vetor de posicoes
     Trans = zeros(size(E));     %Cria vetor com o tamanho do vetor de energias

% ----- Laco para fixar a energia da particula -----
     for j = 1:j_max
          bigP=[1,0;0,1];                                                                         %Valor padrao da matriz de propagacao
     % ----- Laco para calcular o numero de onda ao longo do potencial V(i) -----
          for i = 1:N                                                                             %Roda N iteracoes, sendo N a discretizacao do sistema (inversa do passo da simulacao)
               k(i)=sqrt(2*echarge*m(i)*(E(j)-V(i)))/hbar;                                        %A energia da particula-onda e fixada (indice j) e o laco varia o valor de V(i)
          end                                                                                     %Fim do laco
     % -----
     % ----- Laco para construir a matriz de transferencia bigP ------
          for n=1:(N-1)                                                                           %Roda N-1 iteracoes 
               p(1,1) = 0.5*(1 + ((k(n+1)*m(n))/(k(n)*m(n+1))))*exp(eye*(k(n+1)-k(n))*z(n));
               p(1,2) = 0.5*(1 - ((k(n+1)*m(n))/(k(n)*m(n+1))))*exp(-eye*(k(n+1)+k(n))*z(n));
               p(2,1) = 0.5*(1 - ((k(n+1)*m(n))/(k(n)*m(n+1))))*exp(eye*(k(n+1)+k(n))*z(n));
               p(2,2) = 0.5*(1 + ((k(n+1)*m(n))/(k(n)*m(n+1))))*exp(-eye*(k(n+1)-k(n))*z(n));
               bigP=bigP*p;                                                                       %Multiplica a matriz de propagacao total sequencialmente para coletar todas as informacoes de funcao de onda do sistema
          end                                                                                     %Fim do laco
     % -----
     % ----- Bloco para Calcular o Coeficiente de Transmissao -----
          Trans(j) = 1/(abs(bigP(1))^2);                                                          %Salva na posicao j o coeficiente de transmissao. Dessa forma, os vetores de energia da particula e do tunelamento tem a mesma dimensao.
     % -----
     end
% -----


end

