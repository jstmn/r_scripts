clc
clear all
close all

min_ = -8;
max_ = -min_;

f = figure;
xlabel('X')
ylabel('Y')
zlabel('Z')
grid on
pbaspect([1 1 1])   
ax.XLim = [min_, max_];
ax.YLim = [min_, max_];


view(3)

gran = .1;
mu_endeff_l = [1,1];
Sigma_endeff_l = [ 1.13605, -.13287; ...
                   -.13287, .14913 ];

X = min_:gran:max_;
Y = min_:gran:max_;
[X1_endeff_l,X2_endeff_l] = meshgrid(X,Y);

Z = mvnpdf([X1_endeff_l(:) X2_endeff_l(:)], mu_endeff_l, Sigma_endeff_l);
Z = reshape(Z,length(Y),length(X));

hold on
surf(X,Y,Z);


fitresult = fmgaussfit(X,Y,Z);

mu=fitresult(5:6) 
angle=fitresult(2)%in deg 
sigma= fitresult(3:4) 
hg=fitresult(1) % amplitude ; 