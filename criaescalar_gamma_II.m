function [gamma] = criaescalar_gamma_II(Trans_log,E)
%CRIAESCALAR_GAMMA Esta funcao calcula a largura da primeira ressonancia do
%perfil de transmissao
%   Para encontrar a largura de ressonancia, um primeiro laco e utilizado
%   para encontrar a posicao no vetor de transmissao do pico. Um segundo
%   laco e utilizado para percorrer esse vetor ate o pico e encontrar a
%   posicao em que a transmissao decai em 3dB. O ultimo laco percorre o
%   vetor do pico ate o final para encontrar a segunda posicao em que a
%   transmissao decai em 3dB. As posicoes encontradas sao por fim
%   utilizadas para encontrar a largura de ressonancia do sistema.

     ressonancias = findpeaks(Trans_log);       %Acha os picos do perfil de transmissao
     vales        = -findpeaks(-Trans_log);     %Acha os vales do perfil de transmissao
     db1          = 0;                          %Flag para utilizar o metodo de 1 dB
     db3          = 0;                          %Flag para utilizar o metodo de 3 dB
     
     if vales(1) > (-3)                         %Verifica se o primeiro vale esta acima de -3 dB
         db1 = 1;                               %Se sim, o metodo e de 1 dB
     else                                       %Senao
         db3 = 1;                               %Utiliza o metodo de 3 dB
     end
     
     gamma1 = 0;                                                                 %Inicia variavel onde se guardara a posicao inicial da largura de ressonancia
     gamma2 = 0;                                                                 %Inicia variavel onde se guardara a posicao final da largura de ressonancia
     m      = length(Trans_log);                                                 %Escalar m com as dimensoes do vetor de coeficiente de transmissao
     teste  = size(ressonancias);
     if db1 == 1
         for posicao = 1:(m)                                                     %Executa o laco ate percorrer todo o vetor do coeficiente de transmissao
              if Trans_log(posicao) == ressonancias(1)                           %Verifica se encontrou a posicao de ressonancia
                   R1 = posicao;                                                 %Se sim, salva a posicao
                   if teste(2) == 1
                         break;                                                  %Saida forcada do laco
                   end
               end                                                               %Fim do condicional
               if Trans_log(posicao) == ressonancias(2)                          %Verifica se encontrou a posicao de ressonancia
                   R2 = posicao;                                                 %Se sim, salva a posicao
                   break;                                                        %Saida forcada do laco
               end                                                               %Fim do condicional
          end                                                                    %Fim do laco
     
          for posicao = 1:R1                                                     %Executa o laco ate percorrer o vetor do coeficiente de transmissao ate o pico
               if Trans_log(posicao) > (-1.1) && Trans_log(posicao) < (-0.9)     %Verifica se o coeficiente de transmissao esta dentro do intervalo estabelecido (0.2 dB de tolerancia)
                   gamma1 = posicao;                                             %Se sim, salva a posicao em analise
                   break;                                                        %Saida forcada do laco
               end                                                               %Fim do condicional
          end                                                                    %Fim do laco
     
          for posicao = R1:R2                                                    %Executa o laco ate percorrer todo o vetor do coeficiente de transmissao, a partir do pico
               if Trans_log(posicao) > (-1.1) && Trans_log(posicao) < (-0.9)     %Verifica se o coeficiente de transmissao esta dentro do intervalo estabelecido (0.2 dB de tolerância)  
                    gamma2 = posicao;                                            %Se sim, salva a posicao em analise
                    break;                                                       %Saida forcada do laco
               end                                                               %Fim do condicional
          end                                                                    %Fim do laco
     elseif db3 == 1
         for posicao = 1:(m)                                                     %Executa o laco ate percorrer todo o vetor do coeficiente de transmissao
              if Trans_log(posicao) == ressonancias(1)                           %Verifica se encontrou a posicao de ressonancia
                   R1 = posicao;                                                 %Se sim, salva a posicao
                   if teste(2) == 1
                         break;                                                  %Saida forcada do laco
                   end
               end                                                               %Fim do condicional
               if Trans_log(posicao) == ressonancias(2)                          %Verifica se encontrou a posicao de ressonancia
                   R2 = posicao;                                                 %Se sim, salva a posicao
                   break;                                                        %Saida forcada do laco
               end                                                               %Fim do condicional
          end                                                                    %Fim do laco
     
          for posicao = 1:R1                                                     %Executa o laco ate percorrer o vetor do coeficiente de transmissao ate o pico
               if Trans_log(posicao) > (-3.1) && Trans_log(posicao) < (-2.9)     %Verifica se o coeficiente de transmissao esta dentro do intervalo estabelecido (0.2 dB de tolerancia)
                   gamma1 = posicao;                                             %Se sim, salva a posicao em analise
                   break;                                                        %Saida forcada do laco
               end                                                               %Fim do condicional
          end                                                                    %Fim do laco
     
          for posicao = R1:R2                                                    %Executa o laco ate percorrer todo o vetor do coeficiente de transmissao, a partir do pico
               if Trans_log(posicao) > (-3.1) && Trans_log(posicao) < (-2.9)     %Verifica se o coeficiente de transmissao esta dentro do intervalo estabelecido (0.2 dB de tolerancia)  
                    gamma2 = posicao;                                            %Se sim, salva a posicao em analise
                    break;                                                       %Saida forcada do laco
               end                                                               %Fim do condicional
          end                                                                    %Fim do laco
     end
     
     
     
     gamma = E(gamma2) - E(gamma1);                                              %A largura de ressonancia e a diferenca das energias correspondentes a um descrescimo de 3dB         
end

