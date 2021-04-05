function varargout = interface_ajuste_schulman1996(varargin)
% INTERFACE_AJUSTE MATLAB code for interface_ajuste.fig
%      INTERFACE_AJUSTE, by itself, creates a new INTERFACE_AJUSTE or raises the existing
%      singleton*.
%
%      H = INTERFACE_AJUSTE returns the handle to a new INTERFACE_AJUSTE or the handle to
%      the existing singleton*.
%
%      INTERFACE_AJUSTE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE_AJUSTE.M with the given input arguments.
%
%      INTERFACE_AJUSTE('Property','Value',...) creates a new INTERFACE_AJUSTE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interface_ajuste_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interface_ajuste_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface_ajuste

% Last Modified by GUIDE v2.5 09-Sep-2019 11:12:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_ajuste_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_ajuste_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before interface_ajuste is made visible.
function interface_ajuste_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface_ajuste (see VARARGIN)

     % Carrega os dados para plotar. 
     % *Dados da Referência
     S = load('tensao_ref_schulman1996.txt');                    %Carrega os dados do .txt. MELHORA: botao para carregar o arquivo a partir da interface
     handles.tensao_referencia = S;                         %Salva os dados no objeto tensao_referencia
     S = load('corrente_ref_schulman1996.txt');                  %Carrega os dados do .txt. MELHORA: botao para carregar o arquivo a partir da interface
     handles.corrente_referencia = S;                       %Salva os dados no objeto corrente_referencia.
     % ** PVR da referencia
     corrente_pico = findpeaks(S);                          %Encontra a corrente de máximo
     corrente_vale = -findpeaks(-S);                        %Encontra a corrente de mínimo
     handles.PVR_ref = 16;                                   %Salva a razão pico-vale de corrente no objeto PVR_ref
     set(handles.txtPVRref, 'String', handles.PVR_ref);     %Ajusta a mensagem do objeto txtPVRref
     % *Dados da curva simulada inicial
     S = load('tensao_simu_schulman1996.txt');
     handles.tensao_simulacao0 = S;
     S = load('corrente_simu_schulman1996.txt');
     handles.corrente_simulacao0 = S;
     % ** PVR da curva simulada inicial
     corrente_pico = findpeaks(S);                          %Encontra a corrente de máximo
     corrente_vale = -findpeaks(-S);                        %Encontra a corrente de mínimo
     handles.PVR_simulacao0 = corrente_pico/corrente_vale;         %Salva a razão pico-vale de corrente no objeto PVR_simulacao0
     set(handles.txtPVRsimu, 'String', handles.PVR_simulacao0);     %Ajusta a mensagem do objeto txtPVRref
     
     
     plot(handles.tensao_referencia,handles.corrente_referencia,handles.tensao_simulacao0,handles.corrente_simulacao0);
     legend('Referência','Simulacao','Location','northeast')
     
     % Cálculo da concordância
     valor_concordancia = (handles.PVR_simulacao0/handles.PVR_ref)*100;
     set(handles.txtPVRconcordancia,'String',valor_concordancia);
     
     % Carregamento dos Parâmetros Iniciais
     Er = 0.1165;        %Parâmetro de Energia da Primeira Ressonância salvo no objeto Er
     gamma = 0.0056;     %Parâmetro da Largura da Primeira Ressonância salvo no objeto gamma
     alpha = 1;          %Parâmetro de ajuste da dimensionalidade entre reservatório e canal salvo no objeto alpha
     n1 = 0.115;         %Parâmetro de ajuste da RDN salvo no objeto n1
     n2 = 0.12;          %Parâmetro de ajuste da região diodo no objeto n2
     % *Atualização dos objetos
     set(handles.txtEr,'String',Er);
     set(handles.txtEr,'Value',Er);
     set(handles.txtgamma,'String',gamma);
     set(handles.txtgamma,'Value',gamma);
     set(handles.txtalpha,'String',alpha);
     set(handles.txtalpha,'Value',alpha);
     set(handles.txtn1,'String',n1);
     set(handles.txtn1,'Value',n1);
     set(handles.txtn2,'String',n2);
     set(handles.txtn2,'Value',n2);
     
     
     % Seta o valor dos passos (padrão 10%)
     default_passo = 10;
     set(handles.stepEr,'String',default_passo);
     set(handles.stepgamma,'String',default_passo);
     set(handles.stepalpha,'String',default_passo);
     set(handles.stepn1,'String',default_passo);
     set(handles.stepn2,'String',default_passo);

% Choose default command line output for interface_ajuste
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface_ajuste wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interface_ajuste_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startsimu.
function startsimu_Callback(hObject, eventdata, handles)
% hObject    handle to startsimu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% *Parâmetros de polarização
     V_max                = 2.5;             %Tensão máxima da amostra [V]
     qte_ponto_tensao     = 100e3;           %Quantidade de pontos desejada no vetor de tensão     
% **Construção do vetor de tensão 
     h_V      = V_max/qte_ponto_tensao;                        %Passo da amostra de tensão
     V_tensao = 0:h_V:V_max;                                   %Vetor com a amostra de tensão

% *Carregamento dos parâmetros da etapa anterior
     A = 483410000;      %Parâmetro A
     B = 0.035;       %Parâmetro B
     H = 1469.1;     %Parâmetro H
     
% *Carregamento dos parâmetros setados no GUI
     C = str2num(get(handles.txtEr,'String'));
     %C = 0.1322;
     D = (str2num(get(handles.txtgamma,'String')))/2;
     %D = 4.15e-4;
     alpha = str2num(get(handles.txtalpha,'String'));
     %alpha = 1;
     n1 = str2num(get(handles.txtn1,'String'));
     %n1 = 0.115;
     n2 = str2num(get(handles.txtn2,'String'));
     %n2 = 0.12;
     
% * Carregamento dos parâmetros da referência     
     V_tensao_referencia = load('tensao_ref_schulman1996.txt');     %Carrega um vetor com a tensão da referência
     J_referencia = load('corrente_ref_schulman1996.txt');          %Carrega um vetor com a corrente da referência
     
% * Simulação da Densidade de Corrente pelo Diodo de Tunelamento Ressonante     
     J       = ones(size(V_tensao));     %Pré-aloca vetor de densidade de corrente [A/cm2]
     itermax = size(V_tensao);           %Calcula o máximo de iterações de acordo com o tamanho do vetor de tensões
     J1      = ones(size(V_tensao));     %Pré-aloca vetor de densidade de corrente [A/cm2]
     J2      = ones(size(V_tensao));     %Pré-aloca vetor de densidade de corrente [A/cm2]
     
     k       = 1.38062e-23;          %Constante de Boltzmann [J/K]
     echarge = 1.6021766208E-19;     %Carga elementar segundo o CODATA
     T       = 300;                  %Temperatura de Operação do Dispositivo [T]
     
     %engine
     for contador = 1:itermax(2)
          A1           = B - C + (n1*V_tensao(contador));
          B1           = (A1*echarge)/(k*T);
          C1           = exp(B1);
          D1           = B - C - (n1*V_tensao(contador));
          E1           = (D1*echarge)/(k*T);
          F1           = exp(E1);
          G1           = log((1 + C1)/(1 + F1));
          H1           = A*G1;

          A2           = C - (n1*V_tensao(contador));
          B2           = A2/D;
          C2           = atan(B2);
          D2           = (pi/2) + C2;
          J1(contador) = H1*D2;
          A3           = n2*echarge*V_tensao(contador);
          A4           = A3/(k*T);
          A5           = exp(A4);
          A6           = 1 + A5;
          J2(contador) = H*A6;
          J(contador)  = alpha*J1(contador) + J2(contador);
     end
     
     %mudança 12/11/2020 17:16
     % colocar a área do dispositivo
     
%      Area = 1.6e-11;         %Área [m2]
%      I    = J*Area;     %Corrente [A]
%      Ima  = I*1e3;          %Corrente [mA]
%     

     %mudança 17/11/2020 15:17
     % correção de m2 para cm2
     Jcm2 = J*1e-4;

     plot(V_tensao_referencia,J_referencia,V_tensao,Jcm2);
     legend('Referência','Simulacao','Location','northeast')
     
     % ** PVR da curva simulada inicial
     corrente_pico = findpeaks(Jcm2);                          %Encontra a corrente de máximo
     corrente_vale = -findpeaks(-Jcm2);                        %Encontra a corrente de mínimo
     handles.PVR_simulacao0 = corrente_pico/corrente_vale;         %Salva a razão pico-vale de corrente no objeto PVR_simulacao0
     set(handles.txtPVRsimu, 'String', handles.PVR_simulacao0);     %Ajusta a mensagem do objeto txtPVRref
     
     % Cálculo da concordância
     valor_concordancia = (handles.PVR_simulacao0/handles.PVR_ref)*100;
     set(handles.txtPVRconcordancia,'String',valor_concordancia);
%      if valor_concordancia < 105 && valor_concordancia > 95
%          set(handles.txtQualidade,'String','Ótimo!');
%      elseif (valor_concordancia > 105 && valor_concordancia < 115) || (valor_concordancia < 95 && valor_concordancia > 85)
%          set(handles.txtQualidade,'String','Quase');
%      else
%          set(handles.txtQualidade,'String','Tente um novo ajuste');
%      end
     
     %mudança 12/11/2020 17:25
     % Plotar os coeficientes: alpha, A, B, C, D, H, n1 e n2
     % A
     A_atualizado = A*alpha;
     set(handles.txtAatualizado,'String',A_atualizado);
     % B
     set(handles.txtB,'String',B);
     % C
     set(handles.txtCatualizado,'String',C);
     % D
     set(handles.txtDatualizado,'String',D);
     % H
     set(handles.txtHatualizado,'String',H);
     % n1
     set(handles.txtn1atualizado,'String',n1);
     % n2
     set(handles.txtn2atualizado,'String',n2);
     % alpha
     set(handles.txtalphaatualizado,'String',alpha);


     salvar = get(hObject,'Value');
     
     if(salvar)
         VT = V_tensao';
         JT = Jcm2';
         
         save tensao_simulacao.txt   VT -ascii
         save corrente_simulacao.txt JT -ascii
     end
     
     
     
     
     
%      % ** PVR da referencia
%      corrente_pico = findpeaks(J_referencia);                          %Encontra a corrente de máximo
%      corrente_vale = -findpeaks(-J_refereen);                        %Encontra a corrente de mínimo
%      handles.PVR_ref = corrente_pico/corrente_vale;         %Salva a razão pico-vale de corrente no objeto PVR_ref
%      set(handles.txtPVRref, 'String', handles.PVR_ref);     %Ajusta a mensagem do objeto txtPVRref

     


% --- Executes on button press in psh_mais_n1.
function psh_mais_n1_Callback(hObject, eventdata, handles)
% hObject    handle to psh_mais_n1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     n1 = str2num(get(handles.txtn1,'String'));
     dn1 = str2num(get(handles.stepn1,'String'));
     n1_1 = n1 + n1*(dn1/100);
     set(handles.txtn1,'String',n1_1)


% --- Executes on button press in psh_mais_n2.
function psh_mais_n2_Callback(hObject, eventdata, handles)
% hObject    handle to psh_mais_n2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     n2 = str2num(get(handles.txtn2,'String'));
     dn2 = str2num(get(handles.stepn2,'String'));
     n2_1 = n2 + n2*(dn2/100);
     set(handles.txtn2,'String',n2_1)


% --- Executes on button press in psh_mais_alpha.
function psh_mais_alpha_Callback(hObject, eventdata, handles)
% hObject    handle to psh_mais_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     alpha = str2num(get(handles.txtalpha,'String'));
     dalpha = str2num(get(handles.stepalpha,'String'));
     alpha_1 = alpha + alpha*(dalpha/100);
     set(handles.txtalpha,'String',alpha_1)

% --- Executes on button press in psh_mais_Er.
function psh_mais_Er_Callback(hObject, eventdata, handles)
% hObject    handle to psh_mais_Er (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     Er = str2num(get(handles.txtEr,'String'));
     dEr = str2num(get(handles.stepEr,'String'));
     Er_1 = Er + Er*(dEr/100);
     set(handles.txtEr,'String',Er_1)

% guidata(hObject, handles);
% handles.Er = handles.Er + (handles.Er*(handles.stepEr));
% set(handles.txtEr,'String',handles.Er);




% --- Executes on button press in psh_mais_gamma.
function psh_mais_gamma_Callback(hObject, eventdata, handles)
% hObject    handle to psh_mais_gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     gamma = str2num(get(handles.txtgamma,'String'));
     dgamma = str2num(get(handles.stepgamma,'String'));
     gamma_1 = gamma + gamma*(dgamma/100);
     set(handles.txtgamma,'String',gamma_1)


% --- Executes on button press in psh_menos_n1.
function psh_menos_n1_Callback(hObject, eventdata, handles)
% hObject    handle to psh_menos_n1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     n1 = str2num(get(handles.txtn1,'String'));
     dn1 = str2num(get(handles.stepn1,'String'));
     n1_1 = n1 - n1*(dn1/100);
     set(handles.txtn1,'String',n1_1)

% --- Executes on button press in psh_menos_n2.
function psh_menos_n2_Callback(hObject, eventdata, handles)
% hObject    handle to psh_menos_n2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     n2 = str2num(get(handles.txtn2,'String'));
     dn2 = str2num(get(handles.stepn2,'String'));
     n2_1 = n2 - n2*(dn2/100);
     set(handles.txtn2,'String',n2_1)


% --- Executes on button press in psh_menos_alpha.
function psh_menos_alpha_Callback(hObject, eventdata, handles)
% hObject    handle to psh_menos_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     alpha = str2num(get(handles.txtalpha,'String'));
     dalpha = str2num(get(handles.stepalpha,'String'));
     alpha_1 = alpha - alpha*(dalpha/100);
     set(handles.txtalpha,'String',alpha_1)

% --- Executes on button press in psh_menos_Er.
function psh_menos_Er_Callback(hObject, eventdata, handles)
% hObject    handle to psh_menos_Er (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     Er = str2num(get(handles.txtEr,'String'));
     dEr = str2num(get(handles.stepEr,'String'));
     Er_1 = Er - Er*(dEr/100);
     set(handles.txtEr,'String',Er_1)

% --- Executes on button press in psh_menos_gamma.
function psh_menos_gamma_Callback(hObject, eventdata, handles)
% hObject    handle to psh_menos_gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     gamma = str2num(get(handles.txtgamma,'String'));
     dgamma = str2num(get(handles.stepgamma,'String'));
     gamma_1 = gamma - gamma*(dgamma/100);
     set(handles.txtgamma,'String',gamma_1)



function stepEr_Callback(hObject, eventdata, handles)
% hObject    handle to stepEr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stepEr as text
%        str2double(get(hObject,'String')) returns contents of stepEr as a double


% --- Executes during object creation, after setting all properties.
function stepEr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepEr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stepgamma_Callback(hObject, eventdata, handles)
% hObject    handle to stepgamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stepgamma as text
%        str2double(get(hObject,'String')) returns contents of stepgamma as a double


% --- Executes during object creation, after setting all properties.
function stepgamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepgamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stepn1_Callback(hObject, eventdata, handles)
% hObject    handle to stepn1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stepn1 as text
%        str2double(get(hObject,'String')) returns contents of stepn1 as a double


% --- Executes during object creation, after setting all properties.
function stepn1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepn1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stepalpha_Callback(hObject, eventdata, handles)
% hObject    handle to stepalpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stepalpha as text
%        str2double(get(hObject,'String')) returns contents of stepalpha as a double


% --- Executes during object creation, after setting all properties.
function stepalpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepalpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stepn2_Callback(hObject, eventdata, handles)
% hObject    handle to stepn2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stepn2 as text
%        str2double(get(hObject,'String')) returns contents of stepn2 as a double


% --- Executes during object creation, after setting all properties.
function stepn2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepn2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% % --- Executes on button press in pushbutton_save.
% function pushbutton_save_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton_save (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% V_tensao = handles.tensao_simulacao;
% J = handles.corrente_simulacao;
% VT = V_tensao';
% JT = J';
% 
% save tensao_simulacao.txt      VT -ascii     %salva o vetor VT em .txt 
% save corrente_simulacao.txt     JT -ascii     %salva o vetor zT em .txt
% 
% % VT = ';                           %Completa um vetor transposto de E


% --- Executes on button press in chkSave.
function chkSave_Callback(hObject, eventdata, handles)
% hObject    handle to chkSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.save = get(hObject,'Value');
%set(handles.estado_save,'String',handles.save)

% Hint: get(hObject,'Value') returns toggle state of chkSave
