
clc
close all 
clear all


           
uirunner
function uirunner
    
    Lb = 2;
    L1 = 3;
    L2 = 5;
    Ls = [Lb, L1, L2];
    
       % xb_ yb_ yawb_ t_r1_ t_r2_ t_l1_ t_l2_
    q = [ 0   3   0     2.6   5.6   2.6   5.6 ];
    
    variances = [.01, .01, .1, .025, .025, .025, .025 ];
  
    f = figure;
    bgcolor = f.Color;
    ax = axes('position',[0.1 0.25 0.8 0.8]);
    grid on
    pbaspect([1 1 1])   
    min_x = -10; max_x = 10; min_y = -10; max_y = 10;
    ax.XLim = [min_x, max_y];
    ax.YLim = [min_y, max_y];
    ax.ZLim = [0, 5];
    view(3)
    
    draw_gaussians = false;
    draw_histograms = false;
    draw_manipulability_ellipsoid = true;
    
    global xb_sym yb_sym yawb_sym t_l1_sym t_l2_sym t_r1_sym t_r2_sym Lb_sym L1_sym L2_sym
    syms xb_sym yb_sym yawb_sym t_l1_sym t_l2_sym t_r1_sym t_r2_sym Lb_sym L1_sym L2_sym
    
    offset = .5;
    gran = .15;
    matrix_precision = 5;
    
    global hLines histograms gaussians sigma_label left_endeff_last_vals right_endeff_last_vals manipulability_lines
    hLines(1) = line([0,0],[0,0]);
    hLines(2) = line([0,0],[0,0]);
    hLines(3) = line([0,0],[0,0]);
    hLines(4) = line([0,0],[0,0]);
    hLines(5) = line([0,0],[0,0]);
    histograms(1) = line([0,0],[0,0]);
    histograms(2) = line([0,0],[0,0]);
    gaussians(1) = line([0,0],[0,0]);
    gaussians(2) = line([0,0],[0,0]);
    sigma_label(1) = line([0,0],[0,0]);
    sigma_label(2) = line([0,0],[0,0]);
    manipulability_lines(1) = line([0,0],[0,0]);
    manipulability_lines(2) = line([0,0],[0,0]);
    left_endeff_last_vals = [0,0,0,0,0];
    right_endeff_last_vals = [0,0,0,0,0];
    
    q_sym = [xb_sym yb_sym yawb_sym t_r1_sym t_r2_sym t_l1_sym t_l2_sym];
    
    Rs_b = [cos(yawb_sym), - sin(yawb_sym), xb_sym;
            sin(yawb_sym), cos(yawb_sym),   yb_sym;
            0 0 1];
        
    Rb_r1 = [1 0 Lb_sym / 2;
            0 1 0
            0 0 1]* [cos(t_r1_sym - pi), sin(t_r1_sym - pi) 0;
                   - sin(t_r1_sym - pi), cos(t_r1_sym - pi) 0;
                     0 0 1];
            
    Rr1_r2 = [1 0 L1_sym;
              0 1 0;
              0 0 1]* [ cos(pi + t_r2_sym), sin(pi + t_r2_sym), 0;
                      - sin(pi + t_r2_sym), cos(pi + t_r2_sym), 0;
                        0 0 1 ];
    Rr2_ree = [ 1 0 L2_sym;
                0 1 0;
                0 0 1 ];

    Rb_l1 = [ 1 0, - Lb_sym/2;
              0 1 0
              0 0 1 ]*[ cos(2 * pi - t_l1_sym), sin(2 * pi - t_l1_sym), 0;
                - sin(2 * pi - t_l1_sym), cos(2 * pi - t_l1_sym), 0;
                  0 0 1 ];
              
    Rl1_l2 = [1 0 L1_sym;
                0 1 0
                0 0 1 ]*[ cos(- pi - t_l2_sym), sin(- pi - t_l2_sym), 0;
                        - sin(- pi - t_l2_sym), cos(- pi - t_l2_sym), 0
                            0 0 1 ];
             
    Rl2_lee = [1 0 L2_sym;
               0 1 0
               0 0 1
    ]; 
    Rs_lee = simplify(Rs_b * Rb_l1 * Rl1_l2 * Rl2_lee);
    Rr_lee = simplify(Rs_b * Rb_r1 * Rr1_r2 * Rr2_ree);

    q_left_symbolic = [xb_sym yb_sym yawb_sym t_l1_sym t_l2_sym];
    Pl_endeff_symbolic = [ xb_sym - (Lb/2)*cos(yawb_sym) + L1*cos(t_l1_sym + yawb_sym) - L2*cos(t_l1_sym + t_l2_sym + yawb_sym),...
                          yb_sym - (Lb/2)*sin(yawb_sym) + L1*sin(t_l1_sym + yawb_sym) - L2*sin(t_l1_sym + t_l2_sym + yawb_sym)];
    J_left_symbolic = jacobian(Pl_endeff_symbolic, q_left_symbolic);                  
    
    draw_sliders
    update_robot
    plot_joint_position_densities
    
    function draw_sliders
        body_x = uicontrol('Parent',f,'Style','slider','Position',[75,100,600,25],'value',q(1), 'min',min_x, 'max',max_x);                  % [position: [left bottom width height]
        annotation(f,'textbox','String','X_b','units','pix', 'Position', [25,100,45,25],'Interpreter','Tex');
        body_x_val = uicontrol('Parent',f,'Style','text','Position',[695,100,45,25],'String',q(1),'BackgroundColor',bgcolor);
        body_x.Callback = @(es,ed) update_ui(1, body_x, body_x_val); 

        body_y = uicontrol('Parent',f,'Style','slider','Position',[75,75,600,25],'value',q(2), 'min',min_y, 'max',max_y);                  % [position: [left bottom width height]
        annotation(f,'textbox','String','Y_b','units','pix', 'Position', [25,75,45,25],'Interpreter','Tex');
        body_y_val = uicontrol('Parent',f,'Style','text','Position',[695,75,45,25],'String',q(2),'BackgroundColor',bgcolor);
        body_y.Callback = @(es,ed) update_ui(2, body_y, body_y_val); 

        body_yaw = uicontrol('Parent',f,'Style','slider','Position',[75,50,600,25],'value',q(3), 'min',0, 'max',2*pi);                  % [position: [left bottom width height]
        annotation(f,'textbox','String','\Psi_b','units','pix', 'Position', [25,50,45,25],'Interpreter','Tex');
        body_yaw_val = uicontrol('Parent',f,'Style','text','Position',[695,50,45,25],'String',q(3),'BackgroundColor',bgcolor);
        body_yaw.Callback = @(es,ed) update_ui(3, body_yaw, body_yaw_val); 

        tr1 = uicontrol('Parent',f,'Style','slider','Position',[800,100,600,25],'value',q(4), 'min',0, 'max',2*pi);                  % [position: [left bottom width height]
        annotation(f,'textbox','String','\theta_{r,1}','units','pix', 'Position', [750,100,45,25],'Interpreter','Tex');
        tr1_val = uicontrol('Parent',f,'Style','text','Position',[1425,100,45,25],'String',q(4),'BackgroundColor',bgcolor);
        tr1.Callback = @(es,ed) update_ui(4, tr1, tr1_val); 

        tr2 = uicontrol('Parent',f,'Style','slider','Position',[800,75,600,25],'value',q(5), 'min',0, 'max',2*pi);                  % [position: [left bottom width height]
        annotation(f,'textbox','String','\theta_{r,2}','units','pix', 'Position', [750,75,45,25],'Interpreter','Tex');
        tr2_val = uicontrol('Parent',f,'Style','text','Position',[1425,75,45,25],'String',q(5),'BackgroundColor',bgcolor);
        tr2.Callback = @(es,ed) update_ui(5, tr2, tr2_val); 

        tl1 = uicontrol('Parent',f,'Style','slider','Position',[800,50,600,25],'value',q(6), 'min',0, 'max',2*pi);                  % [position: [left bottom width height]
        annotation(f,'textbox','String','\theta_{l,1}','units','pix', 'Position', [750,50,45,25],'Interpreter','Tex');
        tl1_val = uicontrol('Parent',f,'Style','text','Position',[1425,50,45,25],'String',q(6),'BackgroundColor',bgcolor);
        tl1.Callback = @(es,ed) update_ui(6, tl1, tl1_val); 

        tl2 = uicontrol('Parent',f,'Style','slider','Position',[800,25,600,25],'value',q(7), 'min',0, 'max',2*pi);                  % [position: [left bottom width height]
        annotation(f,'textbox','String','\theta_{l,2}','units','pix', 'Position', [750,25,45,25],'Interpreter','Tex');
        tl2_val = uicontrol('Parent',f,'Style','text','Position',[1425,25,45,25],'String',q(7),'BackgroundColor',bgcolor);
        tl2.Callback = @(es,ed) update_ui(7, tl2, tl2_val); 
    end
    
    function update_ui(id, slider, disp)
        disp.String = slider.Value;
        q(1,id) = slider.Value;
        update_robot
        plot_joint_position_densities 
    end

    function plot_joint_position_densities
        
        if draw_gaussians || draw_histograms
            n = 1000;
            nbins = 25;
            R = n_ind_normal_distributed_random_vars(q, variances, n);
            joint_positions = joint_positions_from_qs(R);
            left_end_effector_xys = [joint_positions(:,1,1),joint_positions(:,1,2)];
            right_end_effector_xys = [joint_positions(:,6,1),joint_positions(:,6,2)];
        end
        
        % 2d histograms
        if draw_histograms
            delete(histograms(1))
            delete(histograms(2))
            hold on
            histograms(1) = histogram2(joint_positions(:,1,1),joint_positions(:,1,2),nbins,'FaceColor','red');
            histograms(2) = histogram2(joint_positions(:,6,1),joint_positions(:,6,2),nbins,'FaceColor','red');
        end
        
        if draw_manipulability_ellipsoid
            
            X0 = endeff_left(q(1,1),q(1,2),q(1,3),q(1,4),q(1,5),q(1,6),q(1,7));
            
            % [x, y]
            J_left_real = double(subs(J_left_symbolic, q_left_symbolic, [q(1,1:3),q(6),q(7)]));
            [U,D,V]=svd(J_left_real*transpose(J_left_real));
            
            c = .075;
            u1 = U(1,:);
            u2 = U(2,:);
            sigma1 = D(1,1);
            sigma2 = D(2,2);
            
            Xs_1 = X0 - c*(u1*sigma1);
            Xf_1 = X0 + c*(u1*sigma1);
            Xs_2 = X0 - c*(u2*sigma2);
            Xf_2 = X0 + c*(u2*sigma2);
            
            hold on
            delete(manipulability_lines(1))
            delete(manipulability_lines(2))
            manipulability_lines(1) = line([Xs_1(1,1), Xf_1(1,1)],[Xs_1(1,2), Xf_1(1,2)],'LineWidth',1.5,'Color','Black');
            manipulability_lines(2) = line([Xs_2(1,1), Xf_2(1,1)],[Xs_2(1,2), Xf_2(1,2)],'LineWidth',1.5,'Color','Black');
            
        end
        
        
        if draw_gaussians
            
            left_vals = [q(1,1:3),q(6),q(7)];
            right_vals = q(1,1:5);

            % end effector left
            if isequal(left_vals,left_endeff_last_vals) == 0
                
                mu_endeff_l = mean(left_end_effector_xys);
                Sigma_endeff_l = cov(left_end_effector_xys);
                x1_endeff_l = min(left_end_effector_xys(:,1))-offset:gran:max(left_end_effector_xys(:,1))+offset;
                x2_endeff_l = min(left_end_effector_xys(:,2))-offset:gran:max(left_end_effector_xys(:,2))+offset;
                [X1_endeff_l,X2_endeff_l] = meshgrid(x1_endeff_l,x2_endeff_l);
                F_endeff_l = mvnpdf([X1_endeff_l(:) X2_endeff_l(:)],mu_endeff_l,Sigma_endeff_l);
                F_endeff_l = reshape(F_endeff_l,length(x2_endeff_l),length(x1_endeff_l));
                
                endeff_l_angle = fit_2dgaussian_rotation_deg(x1_endeff_l,x2_endeff_l,F_endeff_l);
                latex_endeff_l = strcat(['$ \Sigma_{\textrm{endeff,left}}=',latex(vpa(sym(Sigma_endeff_l),matrix_precision))]);
                line_2_l = strcat([  '\mu_{\textrm{endeff,left}}:',  latex(vpa(sym(mu_endeff_l),matrix_precision)), '\textrm{ angle}:', sprintf('%.1f',endeff_l_angle),' $']);
                
                delete(gaussians(1))
                delete(sigma_label(1))
                
                
                hold on
                gaussians(1) = surf(x1_endeff_l,x2_endeff_l,F_endeff_l);
                sigma_label(1) = annotation(f,'textbox','String',[latex_endeff_l,line_2_l],'units','pix', 'Position', [0,250,200,75],'interpreter','latex','FontSize',11);
                
                left_endeff_last_vals = left_vals;
            end
            
            % end effector right
            if isequal(right_vals,right_endeff_last_vals) == 0 
                mu_endeff_r = mean(right_end_effector_xys);
                Sigma_endeff_r = cov(right_end_effector_xys);
                x1_endeff_r = min(right_end_effector_xys(:,1))-offset:gran:max(right_end_effector_xys(:,1))+offset;
                x2_endeff_r = min(right_end_effector_xys(:,2))-offset:gran:max(right_end_effector_xys(:,2))+offset;
                [X1_endeff_r,X2_endeff_r] = meshgrid(x1_endeff_r,x2_endeff_r);
                F_endeff_r = mvnpdf([X1_endeff_r(:) X2_endeff_r(:)],mu_endeff_r,Sigma_endeff_r);
                F_endeff_r = reshape(F_endeff_r,length(x2_endeff_r),length(x1_endeff_r));

                endeff_r_angle = fit_2dgaussian_rotation_deg(x1_endeff_r,x2_endeff_r,F_endeff_r);

                latex_endeff_r = strcat(['$ \Sigma_{\textrm{endeff,r}}=',latex(vpa(sym(Sigma_endeff_r),matrix_precision))]);
                line_2_r = strcat([  '\mu_{\textrm{endeff,r}}:',  latex(vpa(sym(mu_endeff_r),matrix_precision)), '\textrm{ angle}:', sprintf('%.1f',endeff_r_angle),' $']);

                delete(gaussians(2))
                delete(sigma_label(2))      
                gaussians(2) = surf(x1_endeff_r,x2_endeff_r,F_endeff_r);
                sigma_label(2) = annotation(f,'textbox','String',[latex_endeff_r,line_2_r],'units','pix', 'Position', [0,325,200,75],'interpreter','latex','FontSize',11);
            
                right_endeff_last_vals = right_vals;
                
            end
        end
    end

    function angle = fit_2dgaussian_rotation_deg(X,Y,Z)
        fitresult = fmgaussfit(X,Y,Z);
        angle=fitresult(2); %in deg 
    end

    function Pl_j1 = j1_left(xb,yb,yawb,t_r1,t_r2,t_l1,t_l2)
        Pl_j1 = [xb - (Lb/2)*cos(yawb), yb-(Lb/2)*sin(yawb) ];
    end

    function Pl_j2 = j2_left(xb,yb,yawb,t_r1,t_r2,t_l1,t_l2)
        Pl_j2 = [ xb - (Lb/2)*cos(yawb) + L1*cos(t_l1 + yawb),...
                 yb-(Lb/2)*sin(yawb) + L1*sin(t_l1 + yawb) ];
    end
    
    function Pl_endeff = endeff_left(xb,yb,yawb,t_r1,t_r2,t_l1,t_l2)
%             disp(' ------------------ ')
%             latex(simplify(XY_sym))
%             XY_real = subs(XY_sym, [q_sym, Lb_sym, L1_sym, L2_sym], [q,Ls]);
%             Pl_endeff = [double(XY_real(1,1)),double(XY_real(2,1))];
            
            Pl_endeff = [     xb - (Lb/2)*cos(yawb) + L1*cos(t_l1 + yawb) - L2*cos(t_l1 + t_l2 + yawb),...
                              yb - (Lb/2)*sin(yawb) + L1*sin(t_l1 + yawb) - L2*sin(t_l1 + t_l2 + yawb) ];
    end

    function Pr_j1 = j1_right(xb,yb,yawb,t_r1,t_r2,t_l1,t_l2)
        Pr_j1 = [xb + (Lb/2)*cos(yawb), yb+(Lb/2)*sin(yawb) ];
    end

    function Pr_j2 = j2_right(xb,yb,yawb,t_r1,t_r2,t_l1,t_l2)
        Pr_j2 = [ xb + (Lb/2)*cos(yawb) - L1*cos(t_r1 - yawb), ...
                  yb + (Lb/2)*sin(yawb)   + L1*sin(t_r1 - yawb) ];
    end
    
    function Pr_endeff = endeff_right(xb,yb,yawb,t_r1,t_r2,t_l1,t_l2)
       Pr_endeff = [ xb + (Lb/2)*cos(yawb) - L1*cos(t_r1 - yawb) + L2*cos(t_r1+t_r2 - yawb) ,...
                        yb + (Lb/2)*sin(yawb)   + L1*sin(t_r1 - yawb) - L2*sin(t_r1+t_r2 - yawb) ];
    end

    function update_robot
        xb_ = q(1,1);
        yb_ = q(1,2);
        yawb_ = q(1,3);
        t_r1_ = q(1,4);
        t_r2_ = q(1,5);
        t_l1_ = q(1,6);
        t_l2_ = q(1,7);

        delete(hLines(1))
        delete(hLines(2))
        delete(hLines(3))
        delete(hLines(4))
        delete(hLines(5))
             
        Pl_j1 = j1_left(xb_,yb_,yawb_,t_r1_,t_r2_,t_l1_,t_l2_);
        Pl_j2 = j2_left(xb_,yb_,yawb_,t_r1_,t_r2_,t_l1_,t_l2_);
        Pl_endeff = endeff_left(xb_,yb_,yawb_,t_r1_,t_r2_,t_l1_,t_l2_);
        Pr_j1 = j1_right(xb_,yb_,yawb_,t_r1_,t_r2_,t_l1_,t_l2_);
        Pr_j2 = j2_right(xb_,yb_,yawb_,t_r1_,t_r2_,t_l1_,t_l2_);
        Pr_end_eff = endeff_right(xb_,yb_,yawb_,t_r1_,t_r2_,t_l1_,t_l2_);
        
        hLines(1) = line([ Pl_j1(1,1), Pr_j1(1,1) ],[ Pl_j1(1,2), Pr_j1(1,2)],'LineWidth',5);
        hLines(2) = line([ Pr_j1(1,1), Pr_j2(1,1) ],[ Pr_j1(1,2), Pr_j2(1,2)],'LineWidth',3);
        hLines(3) = line([ Pr_j2(1,1), Pr_end_eff(1,1) ],[ Pr_j2(1,2), Pr_end_eff(1,2)],'LineWidth',3);
        hLines(4) = line([Pl_j1(1,1),Pl_j2(1,1) ],[ Pl_j1(1,2), Pl_j2(1,2) ],'LineWidth',3);
        hLines(5) = line([Pl_j2(1,1),Pl_endeff(1,1) ],[ Pl_j2(1,2), Pl_endeff(1,2) ],'LineWidth',3);
    end

    function joint_positions = joint_positions_from_qs(qs)
    % input: 
    %   thetas: [ q1
    %             q2
    %                 ...
    %             qn ]
    % output:
    %     POS = [ Pl_endeff_1, Pl_j2_1, Pl_j1_1, Pr_j1_1, Pr_j2_1, Pr_endeff_1
    %               
    %                ...
    %
    %             Pl_endeff_n, Pl_j2_n, Pl_j1_n, Pr_j1_n, Pr_j2_n, Pr_endeff_n
    %            ]                                                           
    %           
    q_size = size(qs);
    joint_positions = zeros(q_size(1,1), 6, 2);
    
    for i=1:q_size(1,1)
        
        xb_ = qs(i,1);
        yb_ = qs(i,2);
        yawb_ = qs(i,3);
        t_r1_ = qs(i,4);
        t_r2_ = qs(i,5);
        t_l1_ = qs(i,6);
        t_l2_ = qs(i,7);
        Pl_j1 = j1_left(xb_,yb_,yawb_,t_r1_,t_r2_,t_l1_,t_l2_);
        Pl_j2 = j2_left(xb_,yb_,yawb_,t_r1_,t_r2_,t_l1_,t_l2_);
        Pl_endeff = endeff_left(xb_,yb_,yawb_,t_r1_,t_r2_,t_l1_,t_l2_);
        Pr_j1 = j1_right(xb_,yb_,yawb_,t_r1_,t_r2_,t_l1_,t_l2_);
        Pr_j2 = j2_right(xb_,yb_,yawb_,t_r1_,t_r2_,t_l1_,t_l2_);
        Pr_end_eff = endeff_right(xb_,yb_,yawb_,t_r1_,t_r2_,t_l1_,t_l2_);
        
        joint_positions(i,1,1) = Pl_endeff(1,1);
        joint_positions(i,1,2) = Pl_endeff(1,2);

        joint_positions(i,2,1) = Pl_j2(1,1);
        joint_positions(i,2,2) = Pl_j2(1,2);
        
        joint_positions(i,3,1) = Pl_j1(1,1);
        joint_positions(i,3,2) = Pl_j1(1,2);
        
        joint_positions(i,4,1) = Pr_j1(1,1);
        joint_positions(i,4,2) = Pr_j1(1,2);
        
        joint_positions(i,5,1) = Pr_j2(1,1);
        joint_positions(i,5,2) = Pr_j2(1,2);
        
        joint_positions(i,6,1) = Pr_end_eff(1,1);
        joint_positions(i,6,2) = Pr_end_eff(1,2);
    end
        
    end

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

end

function tranformation_matrices

syms yaw_b x_b y_b t_r1 t_r2 t_l1 t_l2 Lb L1 L2

    

% 
% 
%     Rs_b = [cos(yaw_b) - sin(yaw_b) x_b;
%             sin(yaw_b) cos(yaw_b) y_b;
%             0 0 1];
%         
%     Rb_r1 = [1 0 Lb / 2;
%             0 1 0
%             0 0 1];
%         
%     Rr1_r1rot = [cos(t_r1 - pi) sin(t_r1 - pi) 0;
%                  - sin(t_r1 - pi) cos(t_r1 - pi) 0;
%                 0 0 1];
%             
%     Rr1rot_r2 = [1 0 L1;
%                 0 1 0;
%                 0 0 1];
%             
%     Rr2_r2rot = [ cos(pi + t_r2) sin(pi + t_r2) 0;
%                  - sin(pi + t_r2) cos(pi + t_r2) 0;
%                 0 0 1 ];
%             
%     Rr2rot_r_end_eff = [ 1 0 L2;
%                          0 1 0;
%                          0 0 1 ];
% 
%     Rb_l1 = [ 1 0 - Lb / 2;
%               0 1 0
%               0 0 1 ];
%           
%     Rl1_l1rot = [ cos(2 * pi - t_l1) sin(2 * pi - t_l1) 0;
%                 - sin(2 * pi - t_l1) cos(2 * pi - t_l1) 0;
%                   0 0 1 ];
%               
%     Rl1rot_l2 = [1 0 L1;
%                 0 1 0
%                 0 0 1 ];
%             
%     Rl2_l2rot = [cos(- pi - t_l2) sin(- pi - t_l2) 0;
%                - sin(- pi - t_l2) cos(- pi - t_l2) 0
%                  0 0 1 ];
%              
%     Rrotl2_endeff = [1 0 L2;
%                     0 1 0
%                     0 0 1
%     ]; 


% P2l = Rs_b * Rb_l1 * Rl1_l1rot * Rl1rot_l2;
% P2l = simplify(P2l);      
% latex(P2l);  
% 
% Pl_endeff = Rs_b * Rb_l1 * Rl1_l1rot * Rl1rot_l2 * Rl2_l2rot * Rrotl2_endeff ;
% Pl_endeff = simplify(Pl_endeff);
% yaw = simplify(atan2(Pl_endeff(2,1),Pl_endeff(1,1)));
% latex(Pl_endeff);
% latex(yaw)

% Rr = Rs_b * Rb_r1 * Rr1_r1rot * Rr1rot_r2 * Rr2_r2rot * Rr2rot_r_end_eff ;
% Rr = simplify(Rr);
% latex(Rr)                            % \left(\begin{array}{ccc} \cos\!\left(\theta_{r,1} + \theta_{r,2} - \Psi_b\right) & \sin\!\left(\theta_{r,1} + \theta_{r,2} - \Psi_b\right) & x_{b} + L_2\, \cos\!\left(\theta_{r,1} + \theta_{r,2} - \Psi_b\right) + \frac{L_b\, \cos\!\left(\Psi_b\right)}{2} - L_1\, \cos\!\left(\theta_{r,1} - \Psi_b\right)\\ - \sin\!\left(\theta_{r,1} + \theta_{r,2} - \Psi_b\right) & \cos\!\left(\theta_{r,1} + \theta_{r,2} - \Psi_b\right) & y_{b} - L_2\, \sin\!\left(\theta_{r,1} + \theta_{r,2} - \Psi_b\right) + \frac{L_b\, \sin\!\left(\Psi_b\right)}{2} + L_1\, \sin\!\left(\theta_{r,1} - \Psi_b\right)\\ 0 & 0 & 1 \end{array}\right)
% 
% P2r = Rs_b * Rb_r1 * Rr1_r1rot * Rr1rot_r2;
% P2r = simplify(P2r);      
% latex(P2r)                             % latex: \left(\begin{array}{ccc} - \cos\!\left(\theta_{r,1} - \psi_b\right) & - \sin\!\left(\theta_{r,1} - \psi_b\right) & x_{b} + \frac{\mathrm{L_b}\, \cos\!\left(\psi_b\right)}{2} - \mathrm{L1}\, \cos\!\left(\theta_{r,1} - \psi_b\right)\\ \sin\!\left(\theta_{r,1} - \psi_b\right) & - \cos\!\left(\theta_{r,1} - \psi_b\right) & y_{b} + \frac{\mathrm{L_b}\, \sin\!\left(\psi_b\right)}{2} + \mathrm{L1}\, \sin\!\left(\theta_{r,1} - \psi_b\right)\\ 0 & 0 & 1 \end{array}\right)
% 
% P1r = Rs_b * Rb_r1;
% P1r = simplify(P1r);
% latex(P1r)                               % latex: \left(\begin{array}{ccc} \cos\!\left(\mathrm{yaw}_{b}\right) & - \sin\!\left(\mathrm{yaw}_{b}\right) & x_{b} + \frac{\mathrm{Lb}\, \cos\!\left(\mathrm{yaw}_{b}\right)}{2}\\ \sin\!\left(\mathrm{yaw}_{b}\right) & \cos\!\left(\mathrm{yaw}_{b}\right) & y_{b} + \frac{\mathrm{Lb}\, \sin\!\left(\mathrm{yaw}_{b}\right)}{2}\\ 0 & 0 & 1 \end{array}\right)
%     




               % [x, y, yaw]
%             Pl_endeff = [ xb_sym - (Lb/2)*cos(yawb_sym) + L1*cos(t_l1_sym + yawb_sym) - L2*cos(t_l1_sym + t_l2_sym + yawb_sym),...
%                           yb_sym - (Lb/2)*sin(yawb_sym) + L1*sin(t_l1_sym + yawb_sym) - L2*sin(t_l1_sym + t_l2_sym + yawb_sym),...
%                           atan2(-sin(t_l1_sym + t_l2_sym + yawb_sym), -cos(t_l1_sym + t_l2_sym + yawb_sym) )];



end


