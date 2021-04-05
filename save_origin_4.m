function [ET, Jcm2T, mT, Trans_logT, V_tensaoT, zT, VT] = save_origin_4(E, Jcm2, m, Trans_log, V_tensao, z, V)
% *** Descricao *** 
% SAVE_ORIGIN Funcao com o objetivo de receber os vetores com os
% valores de tunelamento, perfil de potencial e energia para salvar em
% arquivos .txt para serem plotados no Origin 8

% *** Texto sobre a versao *** 
% Salva todos os vetores pertinentes ao MKII_2_schulman1996

% *** Observacoes ***
%Ainda falta receber o perfil e o salvar. Feito isto, dar um jeito de um
%dos argumentos ser o nome do arquivo. Por questoes de organizacao, sempre
%que a funcao for utilizada, os nomes dos .txt devem ser alterados para
%evitar sobreescrita. Os resultados tambem devem ser enviados para a pasta
%resultados manualmente.

% * Transposicao dos vetores
     ET   = E';                           
     Jcm2T   = Jcm2';
     mT   = m';
     Trans_logT = Trans_log';
     V_tensaoT = V_tensao';
     zT = z';                          
     VT = V';

     save energia.txt                  ET           -ascii       %salva o vetor ET em .txt
     save densidadeC_Acm2.txt          Jcm2T        -ascii       %salva o vetor JT em .txt
     save massa.txt                    mT           -ascii       %salva o vetor mT em .txt
     save coef_transmissao.txt         Trans_logT   -ascii       %salva o vetor Trans_logT em .txt
     save V_tensaoT.txt                V_tensaoT    -ascii       %salva o vetor V_tensaoT em .txt
     save zT.txt                       zT           -ascii       %salva o vetor zT em .txt
     save VT.txt                       VT           -ascii       %salva o vetor zT em .txt
end

