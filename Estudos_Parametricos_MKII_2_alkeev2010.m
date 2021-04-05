%-------------------------------Descrição----------------------------------
% Engine para simular a curva do dispositivo construído em Schulman et al 
% (1996).
%--------------------------------------------------------------------------

%------------------------- Histórico das Versões --------------------------
% MKI_0: Correção da engine-base (parâmetros de simulação [unidades de 
% medida], entradas da simulação [onde vão as informações encontradas na 
% literatura]). Também, por falta de informações, assume-se que o diâmetro
% do dispositivo é o mesmo. Implementada a função 
% DENSIDADE_PORTADORES_INTRINSECOS. Implementada a função
% DENSIDADE_ESTADOS_CONDUCAO. Implementada a função FERMI_OU_DOADORES.
% Implementada a aproximação para a concentração de aceitadores.
% Implementada a função PARAMETRO_H. Implementadas as funções para cálculo
% do coeficiente de transmissão.
% MKII_0: Comparação entre os resultados desta engine com os do artigo de
% Faria et al. São salvos manualmente em excel. Uma dos incrementos
% sustentados na metodologia de Faria et al. é o uso de um calculo
% automático para o parâmetro gamma a partir do coeficiente de transmissão
% sem polarização externa. O problema é que os valores coletados no perfil
% de transmissão não bate com o método de Schulman et al. Uma coisa que
% pode ser feita é estudar o coeficiente de transmissão apenas com uma
% polarização mínima que pode perturbar o sistema DBQW (como sustentado por
% Harrison e Valanis).Pelo jeito, a ordem de grandeza
% MKII_1: Os valores de energia de ressonância e largura de ressonância
% serão substituídos pelos valores do artigo de Faria et al. para averiguar
% se a técnica do parâmetro A está correta. A técnica da matriz de
% transferência está incompleta, porém talvez possa ser utilizada com a
% premissa da sua limitação.
% MKII_2: Agora que sabe-se que meu modelo é limitado pela não inclusão da
% energia transversal, posso prosseguir com o desenvolvimento do trabalho.
% MKII_2_wasige109: A ferramenta está pronta. Este é um teste de aplicação
% ao dispositivo de Wasige et al (2019). 
% MKII_2_wasige109_1: Correção do parâmetro Nd e do parâmetro mh. Correção
% da ordem de grandeza do J e do I e do Ima, também dos coeficientes A e H,
% e do passo dz
% MKII_2_schulman1996: Ajuste das entradas de simulação segundo os
% parâmetros obtidos a partir de schulman 1996. Ajuste da seção Cálculo de
% corrente. Ajuste da função de salvar para a versão 4.
% MKII_2_alkeev2010: Ajuste
%--------------------------------------------------------------------------

% Análise da Estrutura (materiais semicondutores utilizados na manufatura)
% Descrição               % Espessura % Dopagem       % Material
% Contato ohmico superior % 0,2 um    % 2e18          % n+ GaAs
% Espaçador 1             % 2000 A    % 1e17          % GaAs
% Espaçador 2             % 45 A      % intrínseco    % GaAs
% Barreira                % 17 A      % intrínseco    % AlAs
% Poço quântico           % 40 A      % intrínseco    % GaAs
% Barreira                % 17 A      % intrínseco    % AlAs
% Espaçador 2             % 45 A      % intrínseco    % GaAs
% Espaçador 1             % 2000 A    % 1e17          % GaAs
% Contato ohmico inferior % 0,4 um    % 2e18          % n+ GaAs
%--------------------------------------------------------------------------

%----------------------------- Limpa Memória ------------------------------
clear all
clc
%clf
%--------------------------------------------------------------------------

%----------------------- Parâmetros de Simulação --------------------------
global k hbar m0 T echarge;       %Declara os parâmetros como variáveis globais para acesso por todas as funções 
k       = 1.38062e-23;            %Constante de Boltzmann [J/K]
hbar    = 1.0546e-34;             %Constante de Planck  [J*s]
m0      = 9.10938356e-31;         %Massa do elétron livre [kg]
T       = 300;                    %Temperatura de Operação do Dispositivo [K]
echarge = 1.6021766208E-19;       %Carga elementar segundo o CODATA [C]
dz      = 0.01e-9;                 %Passo do comprimento do sistema [m]
qte_ponto_incidencia = 1e5;       %Quantidade desejada de valores para o vetor de energia
qte_ponto_tensao     = 100e3;     %Quantidade de pontos desejada no vetor de tensão
%--------------------------------------------------------------------------

%------------------------ Entradas da Simulação ---------------------------
% *Parâmetros construtivos
% **DBQW
Lb                   = 17;              %Comprimento da Barreira [A]
Lw                   = 40;              %Comprimento do Poço [A]
mb                   = 0.15*m0;         %Massa efetiva da barreira [kg]
mw                   = 0.067*m0;        %Massa efetiva do poço [kg]
V0                   = 1.7;               %Altura do potencial [eV]
% **Emissor
Nd                   = 2e18;            %Dopagem do Emissor [cm-3]
me                   = 0.067*m0;        %Massa efetiva do elétron no reservatório [kg]   
mh                   = 0.51*m0;         %Massa efetiva da lacuna no reservatório [kg]
Eg                   = 1.424;           %Energia de gap no reservatório [eV]
Ef                   = 0;               %Energia de Fermi no reservatório [eV]
Dn                   = 200;             %Coeficiente de difusão dos elétrons [cm2/s]
Dp                   = 9.2;             %Coeficiente de difusão das lacunas [cm2/s]
Ln                   = 10;           %Comprimento de difusão de elétrons [um]
Lp                   = 45;           %Comprimento de difusão de lacunas [um]


% *Parâmetros de polarização
V_max                = 3;             %Tensão máxima da amostra [V]
E_max                = 1.5*V0;               %Energia máxima da amostra [eV]

% *Chutes iniciais de n1 e n2
n1                   = 0.115;           %Parâmetro de ajuste n1
n2                   = 0.12;            %Parâmetro de ajuste n2
%--------------------------------------------------------------------------

%-------------------------------- Engine ----------------------------------
% *Cálculo de parâmetros sequênciais
[ni]           = densidade_portadores_intrinsecos(me, mh, Eg);                %calcula a densidade de portadores intrínsecos
[Nc]           = densidade_estados_conducao(me);                              %calcula a densidade efetiva de estados na banda de condução 
[Ef,Nd]        = fermi_ou_doadores(Nc, Nd, Ef);                               %verifica se falta Ef ou Nd e calcula de acordo
Na             = ni;                                                          %aproximação para a concentração de aceitadores [cm-3]
% *Cálculo dos fatores do modelo de Schulman, De Los Santos e Chow (1996).
[H]            = 1e4*parametro_H(Dn, Na, Ln, Dp, Nd, Lp, ni);                     %calcula o parâmetro H [A/m2]
% **Cálculo do coeficiente de transmissão 
[V_tensao]     = criavetor_tensao(V_max,qte_ponto_tensao);                    %cria vetor de tensão de acordo com os parâmetros de simulação
[E]            = criavetor_incidencia(E_max,qte_ponto_incidencia);            %cria vetor de energias de incidência de acordo com os parâmetros de simulação
[z, iteracoes] = MKII_posicionamento(dz, Lb, Lw);                             %constrói as coordenadas na direção z do sistema
[m]            = MKII_massa(z, iteracoes, Lb, Lw, mb, mw);                    %cria o vetor de massas
[V]            = MKII_perfil(V0, 0, Lb, Lw, z, iteracoes);                    %cria o perfil de potencial da DBQW
[Trans]        = MKI_coef_transmissao(iteracoes, m, E, V,z);                  %calcula o coeficiente de transmissao    
Trans_log      = log10(Trans);                                                %calcula o o coeficiente de transmissão em logarítmo de base 10
% **
[C]            = criaescalar_Er(Trans_log,E);                                 %calcula a energia de ressonância, parâmetro C [eV]
%C              = 1.45e-1; %eV
[gamma]        = criaescalar_gamma_II(Trans_log,E);                           %calcula a largura de ressonancia
%gamma          = 1.04e-2; %eV
D              = gamma/2;                                                     %parâmetro gamma [eV]
[A]            = criaescalar_A(mw,gamma);                                     %calcula o parâmetro A [A/m2]
B              = Ef;
[J, J1, J2]    = criavetor_densidadedecorrente(A,B,C,D,n1,H,n2,V_tensao);     %constrói o vetor com a densidade de corrente não corrigida.
%--------------------------------------------------------------------------

%----------------------------- Figuras ------------------------------------ 
figure(1)
plot(V_tensao,J)
title('Característica elétrica');
xlabel('Tensão [V]');
ylabel('Densidade de Corrente A/m2')
%--------------------------------------------------------------------------

%------------------------ Calculo da Corrente -----------------------------
% O formato do dispositivo é quadrado
% O lado do quadrado é de 4um
% A área é de 1,6e-11
% Area = 1.6e-11;         %Área [m2]
% I    = J*Area;     %Corrente [A]
% Ima  = I*1e3;          %Corrente [mA]
Jcm2 = J*1e-4; %Densidade de corrente em A/cm2
%--------------------------------------------------------------------------

%-------------------Salvamento para análise no Origin ---------------------
[ET, JT, Jcm2T, mT, Trans_logT, V_tensaoT, zT, VT] = save_origin_4(E, J, Jcm2, m, Trans_log, V_tensao, z, V);
%--------------------------------------------------------------------------

% % --- Cálculo da corrente devido a outras contribuições
% A3 = n2.*echarge.*V;
% A4 = A3./(k.*T);
% A5 = exp(A4);
% A6 = 1 + A5;
% J2 = H.*A6;
% 
% J = J1 + J2;
% 
% figure(2)
% plot(V,J2);
% title('Resultado analítico para tunelamento em níveis maiores de ressonancia e excitação térmica sobre a barreira');
% % ---
% 
% % --- Contrastes --
% 
% M = csvread('data_schulman.csv');
% V_ref = M(:, 1);
% J_ref = M(:, 2);
% 
% M = csvread('fit_schulman.csv');
% V_fit = M(:, 1);
% J_fit = M(:, 2);
% 
% figure(6)
% plot(V_fit,J_fit,'k', V_ref,J_ref,'g', V,J,'r')
% title('Contraste Preliminar com o fitting e os dados de Schulman(1996)')
% legend('Fitting [Schulman(1996)]','Data [Schulman(1996)]', 'Simulação', 'Location', 'NorthEastOutside');
% grid on
% % ---
% 
% % --- Salvamento do Resultado
% [JzT,UT] = save_origin_4(J,V);
