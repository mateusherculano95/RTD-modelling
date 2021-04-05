function [V] = MKII_perfil(V0, F, Lb, Lw, z, iteracoes)
%PERFIL Constroi o perfil de potencial do DBQW

     L1 = 10e-10;
     L2 = Lb*1e-10;
     L3 = Lw*1e-10;
     L4 = Lb*1e-10;


     for i = 1:iteracoes                                     %Roda a quantidade de iteracoes determinada acima

          if     z(i) <= L1                                  %Verifica se a posicao esta no pre-barreira
               V(i) = 0;                                     %Se sim, V(i) recebe 0
          elseif z(i) >  L1       && z(i) <  L2+L1           %Verifica se a posicao z(i) e na primeira barreira
               V(i) = V0 - (F*(z(i)-L1));                    %Se sim, V(i) recebe V0 - F*z
          elseif z(i) >= L2+L1    && z(i) <= L3+L2+L1        %Verifica se a posicao z(i) corresponde ao poço 
               V(i) = 0  - (F*(z(i)-L1));                    %Se sim, V(i) recebe 0 - F*z
          elseif z(i) >  L3+L2+L1 && z(i) <  L4+L3+L2+L1     %Verifica se a posicao z(i) corresponde à segunda barreira
               V(i) = V0 - (F*(z(i)-L1));                    %Se sim, V(i) recebe V0 -F*z
          else                                               %Senao (ou seja, a posicao esta no pos-barreira)
               V(i) = -(F*(L2+L3+L4));                       %V(i) recebe -U
          end                                                %Fim da estrutura condicional
     
     end                                                     %Fim do laco

end

