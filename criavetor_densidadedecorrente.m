function [J, J1, J2] = criavetor_densidadedecorrente(A,B,C,D,n1,H,n2,V_tensao)
%CRIAVETOR_DENSIDADEDECORRENTE Esta funcao calcula a densidade de corrente
%do dispositivo de acordo com a expressao semianalitica de Schulman(96),
%mas nao leva em consideracao o parametro alpha de Faria et al.(2018)

     J       = ones(size(V_tensao));     %Pre-aloca vetor de densidade de corrente [A/cm2]
     J1      = ones(size(V_tensao));     %Pre-aloca vetor de densidade de corrente [A/cm2]
     J2      = ones(size(V_tensao));     %Pre-aloca vetor de densidade de corrente [A/cm2]
     itermax = size(V_tensao);           %Calcula o maximo de iteracoes de acordo com o tamanho do vetor de tensoes

     global k echarge T; 

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
          J(contador)  = J1(contador) + J2(contador);
     end
end

