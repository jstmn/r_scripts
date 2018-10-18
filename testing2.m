N = 3.0;
x=linspace(-N, N);
y=x;
[X,Y]=meshgrid(x,y);
z=(1000/sqrt(2*pi).*exp(-(X.^2/2)-(Y.^2/2)));
surf(X,Y,z);
shading interp
axis tight