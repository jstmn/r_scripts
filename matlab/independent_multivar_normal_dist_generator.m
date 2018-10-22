clc
clear all
close all


n = 10;

xb = 100;
yb = 200;
yawb = 300;
t_l1 = 400;
t_l2 = 500;
t_r1 = 600;
t_r2 = 700;

q = [xb yb yawb t_r1 t_r2 t_l1 t_l2 ];
variance = [ .1, .1, .1, .01,.01,.01,.01 ];

R = n_ind_normal_distributed_random_vars(q,variance,n)

function R = n_ind_normal_distributed_random_vars(mu_s, variances,n)
    %   input:
    %       mu_s = [mu_1, mu_2, ..., mu_k]
    %       variances = [var_1, var_2, ..., var_k ]
    %       n = scalar
    %    output:
    %       R = (n X k) matrix with col(i) ~ N(mu_1, var_1)
    
    mu_size = size(mu_s);
    num_vars = mu_size(1,2);
    R = [];
    for i=1:num_vars
        col = transpose(normrnd(mu_s(1,i), variances(1,i), 1,n));
        R = [R(:,:),col];
    end
end

