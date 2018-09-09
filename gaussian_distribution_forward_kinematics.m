clc
close all
clear all

% syms L1 L2 L3
% syms t1 t2 t3
% 
% T0 = [1 0 0 0; 0 1 0 0; 0 0 1 L1; 0 0 0 1];
% T0_1 = [cos(t1) -sin(t1) 0 0; sin(t1) cos(t1) 0 0; 0 0 1 0; 0 0 0 1];
% T1_2 = [cos(t2 - pi/2) 0 sin(t2 - pi/2) 0; 0 1 0 0; -sin(t2-pi/2) 0 cos(t2 - pi/2) 0; 0 0 0 1];
% T2_3 = [1 0 0 0; 0 1 0 0; 0 0 1 L2; 0 0 0 1];
% beta = -t3 + pi;
% T3_4 = [cos(beta) 0 sin(beta) 0; 0 1 0 0; -sin(beta) 0 cos(beta) 0; 0 0 0 1];
% T4_e = [1 0 0 0; 0 1 0 0; 0 0 1 L3; 0 0 0 1];
% T = T0 * T0_1 * T1_2 * T2_3 * T3_4 * T4_e;
% T = simplify(T);
% 
% x = latex(simplify(T(1,4)))
% y = latex(T(2,4))
% z = latex(T(3,4))
% roll = latex(atan2(T(2,1),T(1,1)))
% pitch = latex(atan2(-T(3,1), sqrt(T(3,2)^2 + T(3,3)^2)))
% yaw = latex(atan2(T(3,2),T(3,3)))

% syms var1 var2 var3
% stddev1 = sqrt(var1);
% stddev2 = sqrt(var2);
% stddev3 = sqrt(var3);
% var = [var1; var2; var3];
% stddev = [stddev1; stddev2; stddev3];
% mu = [t1; t2; t3];





%// Plot curve
% x = (-5 * t0_var:0.01:5 * t0_var) + t0_mu;  %// Plotting range
% y = exp(- 0.5 * ((x - t0_mu) / t0_var) .^ 2) / (t0_var * sqrt(2 * pi));
% plot(x, y)
Ls = [5,5,5];

t1_mu = 90;
t1_var = 1;

t2_mu = 45;
t2_var = 1;

t3_mu = 15;
t3_var = 1;

n=200;
t1_s = normrnd(t1_mu,t1_var,[n,1]);
t2_s = normrnd(t2_mu,t2_var,[n,1]);
t3_s = normrnd(t3_mu,t3_var,[n,1]);

thetas = [t1_s,t2_s,t3_s];
qs = qef_from_thetas(thetas,Ls)
xs = qs(:,1);
ys = qs(:,2);
zs = qs(:,1);
rolls = qs(:,2);
pitches = qs(:,1);
yaws = qs(:,2);

data = rolls;
xpd = fitdist(data,'Normal');
x_values = 1.25*min(data):.1:1.25*max(data);
x_pdf = pdf(xpd,x_values);
plot(x_values,x_pdf)

function qs = qef_from_thetas(thetas, Ls)
    % input: 
    %   thetas: [ t11 t12 t13
    %             t21 t22 t23
    %                 ...
    %             tn1 tn2 tn3 ]
    % output:
    %           [ x11, y11, z11, a11, b11, c11
    %             x21, y21, z21, a21, b21, c21
    %                          ...
    %             xn1, yn1, zn1, an1, bn1, cn1 ]

    L1 = Ls(1,1);
    L2 = Ls(1,2);
    L3 = Ls(1,2);
    

    theta_size = size(thetas);
    qs = zeros(theta_size(1,1), 6);
    
    for i=1:theta_size(1,1)
        t1 = thetas(i,1);
        t2 = thetas(i,2);
        t3 = thetas(i,3);
        x = -cos(t1) * (L2*cos(t2) - L3*cos(t2-t3));
        y = -sin(t1) * (L2*cos(t2) - L3*cos(t2-t3));
        z = L1 + L2*sin(t2) - L3*sin(t2-t3);
        roll = atan2(-sin(t2-t3)*sin(t1), -sin(t2-t3)*cos(t1));
        pitch = atan2(cos(t2-t3),sqrt(sin(t2-t3)^2));
        yaw = (pi/2)*sign(sin(t2-t3))*(sign(sin(t2-t3))+1);
        qs(i,1) = x;
        qs(i,2) = y;
        qs(i,3) = z;
        qs(i,4) = roll;
        qs(i,5) = pitch;
        qs(i,6) = yaw;
    end
end

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
