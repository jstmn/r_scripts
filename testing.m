Data = [random('norm',4,7,30,1),random('norm',-2,4,30,1)];
X = -25:.2:25;
Y = -25:.2:25;

D = length(Data(1,:));
Mu = mean(Data);
Sigma = cov(Data);
P_Gaussian = zeros(length(X),length(Y));
for i=1:length(X)
   for j=1:length(Y)
       x = [X(i),Y(j)];
       P_Gaussian(i,j) = 1/((2*pi)^(D/2)*sqrt(det(Sigma)))...
                    *exp(-1/2*(x-Mu)*Sigma^-1*(x-Mu)');
   end
end

mesh(P_Gaussian)