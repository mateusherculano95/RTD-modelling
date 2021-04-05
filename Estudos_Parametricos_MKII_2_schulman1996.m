%----------------------------- Limpa Memoria ------------------------------
clear all
clc
%--------------------------------------------------------------------------

%----------------------- Parametros de Simulacao --------------------------
global k hbar m0 T echarge;                    %Declara os parametros como variaveis globais para acesso por todas as funcoes 
k                    = 1.38062e-23;            %Constante de Boltzmann [J/K]
hbar                 = 1.0546e-34;             %Constante de Planck  [J*s]
m0                   = 9.10938356e-31;         %Massa do eletron livre [kg]
T                    = 300;                    %Temperatura de Operacao do Dispositivo [K]
echarge              = 1.6021766208E-19;       %Carga elementar segundo o CODATA [C]
dz                   = 0.01e-9;                %Passo do comprimento do sistema [m]
qte_ponto_incidencia = 1e5;                    %Quantidade desejada de valores para o vetor de energia
qte_ponto_tensao     = 100e3;                  %Quantidade de pontos desejada no vetor de tensao
%--------------------------------------------------------------------------

%------------------------ Entradas da Simulacao ---------------------------
% *Parametros construtivos
% **DBQW
Lb                   = 26;           %Comprimento da Barreira [A]
Lw                   = 48;           %Comprimento do Poco [A]
mb                   = 0.146*m0;     %Massa efetiva da barreira [kg]
mw                   = 0.041*m0;     %Massa efetiva do poco [kg]
V0                   = 0.658144;     %Altura do potencial [eV]
% **Emissor
Nd                   = 0;            %Dopagem do Emissor [cm-3]
me                   = 0.041*m0;     %Massa efetiva do eletron no reservatorio [kg]   
mh                   = 0.45*m0;      %Massa efetiva da lacuna no reservatorio [kg]
Eg                   = 0.74;         %Energia de gap no reservatorio [eV]
Ef                   = 0.035;        %Energia de Fermi no reservatorio [eV]
Dn                   = 300;          %Coeficiente de difusao dos eletrons [cm2/s]
Dp                   = 7.2;          %Coeficiente de difusao das lacunas [cm2/s]
Ln                   = 2.5;          %Comprimento de difusao de eletrons [um]
Lp                   = 100;          %Comprimento de difusao de lacunas [um]

% *Parametros de polarizacao
V_max                = 2.5;          %Tensao maxima da amostra [V]
E_max                = 1.5*V0;       %Energia maxima da amostra [eV]

% *Chutes iniciais de n1 e n2
n1                   = 0.115;        %Parametro de ajuste n1
n2                   = 0.12;         %Parametro de ajuste n2
%--------------------------------------------------------------------------

%-------------------------------- Engine ----------------------------------
% *Calculo de parametros sequenciais
[ni]           = densidade_portadores_intrinsecos(me, mh, Eg);                %calcula a densidade de portadores intrinsecos
[Nc]           = densidade_estados_conducao(me);                              %calcula a densidade efetiva de estados na banda de conducao 
[Ef,Nd]        = fermi_ou_doadores(Nc, Nd, Ef);                               %verifica se falta Ef ou Nd e calcula de acordo
Na             = ni;                                                          %aproximacao para a concentracao de aceitadores [cm-3]
% *
% *Calculo dos fatores do modelo de Schulman, De Los Santos e Chow (1996).
[H]            = 1e4*parametro_H(Dn, Na, Ln, Dp, Nd, Lp, ni);                 %calcula o parametro H [A/m2]
% **Calculo do coeficiente de transmissao 
[V_tensao]     = criavetor_tensao(V_max,qte_ponto_tensao);                    %cria vetor de tensao de acordo com os parametros de simulacao
[E]            = criavetor_incidencia(E_max,qte_ponto_incidencia);            %cria vetor de energias de incidencia de acordo com os parametros de simulacao
[z, iteracoes] = MKII_posicionamento(dz, Lb, Lw);                             %constroi as coordenadas na direcao z do sistema
[m]            = MKII_massa(z, iteracoes, Lb, Lw, mb, mw);                    %cria o vetor de massas
[V]            = MKII_perfil(V0, 0, Lb, Lw, z, iteracoes);                    %cria o perfil de potencial da DBQW
[Trans]        = MKI_coef_transmissao(iteracoes, m, E, V,z);                  %calcula o coeficiente de transmissao    
Trans_log      = log10(Trans);                                                %calcula o o coeficiente de transmissao em logaritmo de base 10
% **
[C]            = criaescalar_Er(Trans_log,E);                                 %calcula a energia de ressonancia, parametro C [eV]
[gamma]        = criaescalar_gamma_II(Trans_log,E);                           %calcula a largura de ressonancia
D              = gamma/2;                                                     %parametro gamma [eV]
[A]            = criaescalar_A(mw,gamma);                                     %calcula o parametro A [A/m2]
B              = Ef;                                                          %define o coeficiente B como a energia de fermi do reservatorio
[J, J1, J2]    = criavetor_densidadedecorrente(A,B,C,D,n1,H,n2,V_tensao);     %constroi o vetor com a densidade de corrente nao corrigida.
% *
%--------------------------------------------------------------------------

%----------------------------- Figuras ------------------------------------ 
figure(1)                                 %abre uma janela de figura
plot(V_tensao,J)                          %desenha o grafico na figura
title('Caracteristica eletrica');         %cria titulo na figura
xlabel('Tensao [V]');                     %cria legenda do eixo x
ylabel('Densidade de Corrente A/m2');     %cria legenda do eixo y
%--------------------------------------------------------------------------

%------------------------ Calculo da Corrente -----------------------------
Jcm2 = J*1e-4;     %Densidade de corrente em A/cm2
%--------------------------------------------------------------------------

%-------------------Salvamento para analise no Origin ---------------------
[ET, JT, Jcm2T, mT, Trans_logT, V_tensaoT, zT, VT] = save_origin_4(E, J, Jcm2, m, Trans_log, V_tensao, z, V);     %Salva o resultado da simulacao em arquivos .txt
%--------------------------------------------------------------------------

