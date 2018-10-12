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

n=1000;
hist_bucket_count = 300;

Ls = [5,5,5];
theta_mus = [0, 45, 15];
theta_vars = [6,3,3];

t1_mu = deg2rad(theta_mus(1,1));
t1_var = deg2rad(theta_vars(1,1));
t2_mu = deg2rad(theta_mus(1,2));
t2_var = deg2rad(theta_vars(1,2));
t3_mu = deg2rad(theta_mus(1,3));
t3_var = deg2rad(theta_vars(1,3));


t1_s = normrnd(t1_mu,t1_var,[n,1]);
t2_s = normrnd(t2_mu,t2_var,[n,1]);
t3_s = normrnd(t3_mu,t3_var,[n,1]);

thetas = [t1_s,t2_s,t3_s];
qs = qef_from_thetas(thetas,Ls);
q_exact = qef_from_thetas(deg2rad(theta_mus),Ls);
xs = qs(:,1);
ys = qs(:,2);
zs = qs(:,3);
rolls = qs(:,4);
pitches = qs(:,5);
yaws = qs(:,6);

figure
gran = .005;

xpd = fitdist(xs,'normal');
xrange = min(xs)-1:gran:max(xs)+1;
x_pdf = pdf(xpd,xrange);
ypd = fitdist(ys,'Normal');
yrange = min(ys)-1:gran:max(ys)+1;
y_pdf = pdf(ypd,yrange);
zpd = fitdist(zs,'Normal');
zrange = min(zs)-1:gran:max(zs)+1;
z_pdf = pdf(zpd,zrange);
y = linspace(0,20);

subplot(3,1,1)
histfit(xs,hist_bucket_count)
xpd = fitdist(xs,'Normal');
legend('X distribution.','Location','NorthEast');
legend(strcat('\mu_x: ',sprintf('%.3f',xpd.mu),', \sigma_x:',sprintf('%.3f', xpd.sigma)));
% text( min(xrange)-.1,max(x_pdf)-2,strcat('\mu_x: ',sprintf('%.3f',xpd.mu),', \sigma_x:',sprintf('%f', xpd.sigma)),'Fontsize',12)
% text( .4,15, strcat('x_{exact}: ',sprintf('%.3f',q_exact(1,1))),'Fontsize',12)
x(1:100,1) = q_exact(1,1);
pl = line(x,y);
pl.Color = 'green';
pl.LineStyle = '--';
pl.LineWidth = 3;
x_act(1:100,1) = xpd;
pl_act = line(x,y);
pl_act.Color = 'cyan';
pl_act.LineWidth = 2;

subplot(3,1,2)
histfit(ys,hist_bucket_count)
ypd = fitdist(ys,'Normal');
legend('Y distribution','Location','NorthEast')
legend(strcat('\mu_y: ',sprintf('%.3f',ypd.mu),', \sigma_y:',sprintf('%.3f', ypd.sigma)))
% text(min(yrange)-.1,max(y_pdf),strcat('\mu_y: ',sprintf('%.3f',ypd.mu),', \sigma_y:',sprintf('%f', ypd.sigma)),'Fontsize',12)
% text(min(yrange)-.1,max(y_pdf)-(max(y_pdf)/5),strcat('y_{exact}: ',sprintf('%.3f',q_exact(1,2))),'Fontsize',12)
x(1:100,1) = q_exact(1,2);
pl = line(x,y);
pl.Color = 'green';
pl.LineStyle = '--';
pl.LineWidth = 3;

subplot(3,1,3)
histfit(zs,hist_bucket_count)
zpd = fitdist(zs,'Normal');
legend('Z distribution','Location','NorthEast')
legend(strcat('\mu_z: ',sprintf('%.3f',zpd.mu),', \sigma_z:',sprintf('%.3f', zpd.sigma)))
% text(min(zrange)-.1,max(z_pdf),strcat('\mu_z: ',sprintf('%.3f',zpd.mu),', \sigma_z:',sprintf('%f', zpd.sigma)),'Fontsize',12)
% text(min(zrange)-.1,max(z_pdf)-(max(z_pdf)/5),strcat('z_{exact}: ',sprintf('%.3f',q_exact(1,3))),'Fontsize',12)
x(1:100,1) = q_exact(1,3);
pl = line(x,y);
pl.Color = 'green';
pl.LineStyle = '--';
pl.LineWidth = 3;

function qs = qef_from_thetas(thetas, Ls)
    % input: 
    %   thetas: [ t11 t12 t13
    %             t21 t22 t23
    %                 ...
    %             tn1 tn2 tn3 ]
    % output:
    %     end effector q
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

% function q = q_ef(thetas, Ls, T)
%     t1 = thetas(1,1);
%     t2 = thetas(2,1);
%     t3 = thetas(3,1);
%     L1 = Ls(1,1);
%     L2 = Ls(2,1);
%     L3 = Ls(3,1);
%     subs(t1);
%     subs(t2);
%     subs(t3);
%     subs(L1);
%     subs(L2);
%     subs(L3);
%     x = double(subs(T(1,4)));
%     y = double(subs(T(2,4)));
%     z = double(subs(T(3,4)));
%     roll = double(subs(atan2(T(2,1),T(1,1))));
%     pitch = double(subs(atan2(-T(3,1), sqrt(T(3,2)^2 + T(3,3)^2))));
%     yaw = double(subs(atan2(T(3,2),T(3,3))));
%     q = [x;y;z;roll;pitch;yaw];
% end
