%-------------------------------Descri��o----------------------------------
% Engine para simular a curva do dispositivo constru�do em Schulman et al 
% (1996).
%--------------------------------------------------------------------------

%------------------------- Hist�rico das Vers�es --------------------------
% MKI_0: Corre��o da engine-base (par�metros de simula��o [unidades de 
% medida], entradas da simula��o [onde v�o as informa��es encontradas na 
% literatura]). Tamb�m, por falta de informa��es, assume-se que o di�metro
% do dispositivo � o mesmo. Implementada a fun��o 
% DENSIDADE_PORTADORES_INTRINSECOS. Implementada a fun��o
% DENSIDADE_ESTADOS_CONDUCAO. Implementada a fun��o FERMI_OU_DOADORES.
% Implementada a aproxima��o para a concentra��o de aceitadores.
% Implementada a fun��o PARAMETRO_H. Implementadas as fun��es para c�lculo
% do coeficiente de transmiss�o.
% MKII_0: Compara��o entre os resultados desta engine com os do artigo de
% Faria et al. S�o salvos manualmente em excel. Uma dos incrementos
% sustentados na metodologia de Faria et al. � o uso de um calculo
% autom�tico para o par�metro gamma a partir do coeficiente de transmiss�o
% sem polariza��o externa. O problema � que os valores coletados no perfil
% de transmiss�o n�o bate com o m�todo de Schulman et al. Uma coisa que
% pode ser feita � estudar o coeficiente de transmiss�o apenas com uma
% polariza��o m�nima que pode perturbar o sistema DBQW (como sustentado por
% Harrison e Valanis).Pelo jeito, a ordem de grandeza
% MKII_1: Os valores de energia de resson�ncia e largura de resson�ncia
% ser�o substitu�dos pelos valores do artigo de Faria et al. para averiguar
% se a t�cnica do par�metro A est� correta. A t�cnica da matriz de
% transfer�ncia est� incompleta, por�m talvez possa ser utilizada com a
% premissa da sua limita��o.
% MKII_2: Agora que sabe-se que meu modelo � limitado pela n�o inclus�o da
% energia transversal, posso prosseguir com o desenvolvimento do trabalho.
% MKII_2_wasige109: A ferramenta est� pronta. Este � um teste de aplica��o
% ao dispositivo de Wasige et al (2019). 
% MKII_2_wasige109_1: Corre��o do par�metro Nd e do par�metro mh. Corre��o
% da ordem de grandeza do J e do I e do Ima, tamb�m dos coeficientes A e H,
% e do passo dz
% MKII_2_schulman1996: Ajuste das entradas de simula��o segundo os
% par�metros obtidos a partir de schulman 1996. Ajuste da se��o C�lculo de
% corrente. Ajuste da fun��o de salvar para a vers�o 4.
% MKII_2_alkeev2010: Ajuste
%--------------------------------------------------------------------------

% An�lise da Estrutura (materiais semicondutores utilizados na manufatura)
% Descri��o               % Espessura % Dopagem       % Material
% Contato ohmico superior % 0,2 um    % 2e18          % n+ GaAs
% Espa�ador 1             % 2000 A    % 1e17          % GaAs
% Espa�ador 2             % 45 A      % intr�nseco    % GaAs
% Barreira                % 17 A      % intr�nseco    % AlAs
% Po�o qu�ntico           % 40 A      % intr�nseco    % GaAs
% Barreira                % 17 A      % intr�nseco    % AlAs
% Espa�ador 2             % 45 A      % intr�nseco    % GaAs
% Espa�ador 1             % 2000 A    % 1e17          % GaAs
% Contato ohmico inferior % 0,4 um    % 2e18          % n+ GaAs
%--------------------------------------------------------------------------

%----------------------------- Limpa Mem�ria ------------------------------
clear all
clc
%clf
%--------------------------------------------------------------------------

%----------------------- Par�metros de Simula��o --------------------------
global k hbar m0 T echarge;       %Declara os par�metros como vari�veis globais para acesso por todas as fun��es 
k       = 1.38062e-23;            %Constante de Boltzmann [J/K]
hbar    = 1.0546e-34;             %Constante de Planck  [J*s]
m0      = 9.10938356e-31;         %Massa do el�tron livre [kg]
T       = 300;                    %Temperatura de Opera��o do Dispositivo [K]
echarge = 1.6021766208E-19;       %Carga elementar segundo o CODATA [C]
dz      = 0.01e-9;                 %Passo do comprimento do sistema [m]
qte_ponto_incidencia = 1e5;       %Quantidade desejada de valores para o vetor de energia
qte_ponto_tensao     = 100e3;     %Quantidade de pontos desejada no vetor de tens�o
%--------------------------------------------------------------------------

%------------------------ Entradas da Simula��o ---------------------------
% *Par�metros construtivos
% **DBQW
Lb                   = 17;              %Comprimento da Barreira [A]
Lw                   = 40;              %Comprimento do Po�o [A]
mb                   = 0.15*m0;         %Massa efetiva da barreira [kg]
mw                   = 0.067*m0;        %Massa efetiva do po�o [kg]
V0                   = 1.7;               %Altura do potencial [eV]
% **Emissor
Nd                   = 2e18;            %Dopagem do Emissor [cm-3]
me                   = 0.067*m0;        %Massa efetiva do el�tron no reservat�rio [kg]   
mh                   = 0.51*m0;         %Massa efetiva da lacuna no reservat�rio [kg]
Eg                   = 1.424;           %Energia de gap no reservat�rio [eV]
Ef                   = 0;               %Energia de Fermi no reservat�rio [eV]
Dn                   = 200;             %Coeficiente de difus�o dos el�trons [cm2/s]
Dp                   = 9.2;             %Coeficiente de difus�o das lacunas [cm2/s]
Ln                   = 10;           %Comprimento de difus�o de el�trons [um]
Lp                   = 45;           %Comprimento de difus�o de lacunas [um]


% *Par�metros de polariza��o
V_max                = 3;             %Tens�o m�xima da amostra [V]
E_max                = 1.5*V0;               %Energia m�xima da amostra [eV]

% *Chutes iniciais de n1 e n2
n1                   = 0.115;           %Par�metro de ajuste n1
n2                   = 0.12;            %Par�metro de ajuste n2
%--------------------------------------------------------------------------

%-------------------------------- Engine ----------------------------------
% *C�lculo de par�metros sequ�nciais
[ni]           = densidade_portadores_intrinsecos(me, mh, Eg);                %calcula a densidade de portadores intr�nsecos
[Nc]           = densidade_estados_conducao(me);                              %calcula a densidade efetiva de estados na banda de condu��o 
[Ef,Nd]        = fermi_ou_doadores(Nc, Nd, Ef);                               %verifica se falta Ef ou Nd e calcula de acordo
Na             = ni;                                                          %aproxima��o para a concentra��o de aceitadores [cm-3]
% *C�lculo dos fatores do modelo de Schulman, De Los Santos e Chow (1996).
[H]            = 1e4*parametro_H(Dn, Na, Ln, Dp, Nd, Lp, ni);                     %calcula o par�metro H [A/m2]
% **C�lculo do coeficiente de transmiss�o 
[V_tensao]     = criavetor_tensao(V_max,qte_ponto_tensao);                    %cria vetor de tens�o de acordo com os par�metros de simula��o
[E]            = criavetor_incidencia(E_max,qte_ponto_incidencia);            %cria vetor de energias de incid�ncia de acordo com os par�metros de simula��o
[z, iteracoes] = MKII_posicionamento(dz, Lb, Lw);                             %constr�i as coordenadas na dire��o z do sistema
[m]            = MKII_massa(z, iteracoes, Lb, Lw, mb, mw);                    %cria o vetor de massas
[V]            = MKII_perfil(V0, 0, Lb, Lw, z, iteracoes);                    %cria o perfil de potencial da DBQW
[Trans]        = MKI_coef_transmissao(iteracoes, m, E, V,z);                  %calcula o coeficiente de transmissao    
Trans_log      = log10(Trans);                                                %calcula o o coeficiente de transmiss�o em logar�tmo de base 10
% **
[C]            = criaescalar_Er(Trans_log,E);                                 %calcula a energia de resson�ncia, par�metro C [eV]
%C              = 1.45e-1; %eV
[gamma]        = criaescalar_gamma_II(Trans_log,E);                           %calcula a largura de ressonancia
%gamma          = 1.04e-2; %eV
D              = gamma/2;                                                     %par�metro gamma [eV]
[A]            = criaescalar_A(mw,gamma);                                     %calcula o par�metro A [A/m2]
B              = Ef;
[J, J1, J2]    = criavetor_densidadedecorrente(A,B,C,D,n1,H,n2,V_tensao);     %constr�i o vetor com a densidade de corrente n�o corrigida.
%--------------------------------------------------------------------------

%----------------------------- Figuras ------------------------------------ 
figure(1)
plot(V_tensao,J)
title('Caracter�stica el�trica');
xlabel('Tens�o [V]');
ylabel('Densidade de Corrente A/m2')
%--------------------------------------------------------------------------

%------------------------ Calculo da Corrente -----------------------------
% O formato do dispositivo � quadrado
% O lado do quadrado � de 4um
% A �rea � de 1,6e-11
% Area = 1.6e-11;         %�rea [m2]
% I    = J*Area;     %Corrente [A]
% Ima  = I*1e3;          %Corrente [mA]
Jcm2 = J*1e-4; %Densidade de corrente em A/cm2
%--------------------------------------------------------------------------

%-------------------Salvamento para an�lise no Origin ---------------------
[ET, JT, Jcm2T, mT, Trans_logT, V_tensaoT, zT, VT] = save_origin_4(E, J, Jcm2, m, Trans_log, V_tensao, z, V);
%--------------------------------------------------------------------------

% % --- C�lculo da corrente devido a outras contribui��es
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
% title('Resultado anal�tico para tunelamento em n�veis maiores de ressonancia e excita��o t�rmica sobre a barreira');
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
% legend('Fitting [Schulman(1996)]','Data [Schulman(1996)]', 'Simula��o', 'Location', 'NorthEastOutside');
% grid on
% % ---
% 
% % --- Salvamento do Resultado
% [JzT,UT] = save_origin_4(J,V);
