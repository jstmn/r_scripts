clc
clear all

syms L1 L2 L3
syms t1 t2 t3

T0 = [1 0 0 0; 0 1 0 0; 0 0 1 L1; 0 0 0 1];
T0_1 = [cos(t1) -sin(t1) 0 0; sin(t1) cos(t1) 0 0; 0 0 1 0; 0 0 0 1];
T1_2 = [cos(t2 - pi/2) 0 sin(t2 - pi/2) 0; 0 1 0 0; -sin(t2-pi/2) 0 cos(t2 - pi/2) 0; 0 0 0 1];
T2_3 = [1 0 0 0; 0 1 0 0; 0 0 1 L2; 0 0 0 1];
beta = -t3 + pi;
T3_4 = [cos(beta) 0 sin(beta) 0; 0 1 0 0; -sin(beta) 0 cos(beta) 0; 0 0 0 1];
T4_e = [1 0 0 0; 0 1 0 0; 0 0 1 L3; 0 0 0 1];
T = T0 * T0_1 * T1_2 * T2_3 * T3_4 * T4_e;
T = simplify(T);
latex(T)

% L1 = 1;
% L2 = 1;
% L3 = 1;
% subs(L1);
% subs(L2);
% subs(L3);
% x = latex(simplify(T(1,4)))
% y = T(2,4);
% z = T(3,4);
% roll = T(2,1),T(1,1));
% pitch = atan2(-T(3,1), sqrt(T(3,2)^2 + T(3,3)^2));
% yaw = atan2(T(3,2),T(3,3));



% Ls = [4;4;4];
% thetas = [0.32;.23;.1234];
% q = q_ef(thetas,Ls,T)

syms var1 var2 var3
stddev1 = sqrt(var1);
stddev2 = sqrt(var2);
stddev3 = sqrt(var3);

var = [var1; var2; var3];
stddev = [stddev1; stddev2; stddev3];
mu = [t1; t2; t3];

normrnd(mu, var)



function q = q_ef(thetas, Ls, T)
    t1 = thetas(1,1);
    t2 = thetas(2,1);
    t3 = thetas(3,1);
    L1 = Ls(1,1);
    L2 = Ls(2,1);
    L3 = Ls(3,1);
    subs(t1);
    subs(t2);
    subs(t3);
    subs(L1);
    subs(L2);
    subs(L3);
    x = double(subs(T(1,4)));
    y = double(subs(T(2,4)));
    z = double(subs(T(3,4)));
    roll = double(subs(atan2(T(2,1),T(1,1))));
    pitch = double(subs(atan2(-T(3,1), sqrt(T(3,2)^2 + T(3,3)^2))));
    yaw = double(subs(atan2(T(3,2),T(3,3))));
    q = [x;y;z;roll;pitch;yaw];
end
