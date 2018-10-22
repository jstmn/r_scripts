clc
close all

mu = [2,2];

var_x = 10;
var_y = .001;

Sigma = [var_x 0; 
         0     var_y];
     
Scale = [1 0;
         0 1];
     
theta = pi/4;
m = makehgtform('zrotate',theta);
m = m(1:2,1:2);
Sigma = m*(Sigma*Scale)*m.';

x1 = -10:.5:10; 
x2 = -10:.5:10;
[X1,X2] = meshgrid(x1,x2);

F = mvnpdf([X1(:) X2(:)],mu,Sigma);
F = reshape(F,length(x2),length(x1));

surf(X1,X2,F);
xlabel('x');
ylabel('y');
% imshow(F*255)