
clc
close all 


           
uirunner
function uirunner
    
    Lb = 2;
    L1 = 3;
    L2 = 3;
    Ls = [Lb, L1, L2];
    
       % t_r1_ t_r2_ t_l1_ t_l2_
    q_loop = [1.72   5.7   1.7   3.4 ];
    q_variances = [ .05, .05, .05, .05 ];
    %q_variances = [ .05, .05, .05, .05 ];
    
                      % x0 y0,        yaw 
    contact_surface = [ -5, -5, deg2rad(155)];
    contact_surface_positional_variance = .1;
    
    f = figure('pos',[0 1000 800 600]);
    bgcolor = f.Color;
    ax = axes('position',[0.1 0.25 0.8 0.8]);
    grid on
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    pbaspect([1 1 1])   
    min_x = -10; max_x = 10; min_y = -10; max_y = 10;
    ax.XLim = [min_x, max_x];
    ax.YLim = [min_y, max_y];
    ax.ZLim = [0, 5];
    view(3)
    
    plot_contact_distribution = true;
    draw_gaussians = false;
    draw_histograms = true;
    draw_manipulability_ellipsoid = true;
    
    global t_l1_sym t_l2_sym t_r1_sym t_r2_sym Lb_sym L1_sym L2_sym xc_sym yc_sym yawc_sym theta_sym
    syms t_l1_sym t_l2_sym t_r1_sym t_r2_sym Lb_sym L1_sym L2_sym xc_sym yc_sym yawc_sym theta_sym
    
    offset = .5;
    gran = .15;
    matrix_precision = 5;
    
    global hLines histograms gaussians sigma_label  manipulability_lines lin_reg_lines
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
    lin_reg_lines(1) = line([0,0],[0,0]);
    
    q_sym = [ t_r1_sym t_r2_sym t_l1_sym t_l2_sym];
    %     contact_point_sym = [xc_sym yc_sym yawc_sym];
    
    Pr_endeff_symbolic = [ xc_sym - L2_sym*sin(q_sym(1)+q_sym(2)+q_sym(3)+q_sym(4) - yawc_sym) - Lb_sym*sin(q_sym(3)+q_sym(4)-yawc_sym) + L2_sym*sin(yawc_sym) + L1_sym*sin( q_sym(3)+q_sym(4)+q_sym(1) - yawc_sym)  + L1_sym*sin(q_sym(4)-yawc_sym), ...
                           yc_sym - L2_sym*cos(q_sym(1)+q_sym(2)+q_sym(3)+q_sym(4) - yawc_sym) - Lb_sym*cos(q_sym(3)+q_sym(4)-yawc_sym) - L2_sym*cos(yawc_sym) + L1_sym*cos( q_sym(3)+q_sym(4)+q_sym(1) - yawc_sym)  + L1_sym*cos(q_sym(4)-yawc_sym)  ];
    J_ree_symbolic = simplify(jacobian(Pr_endeff_symbolic, q_sym));
%     latex(J_ree_symbolic)
    
%     correlate_lin_gaussian_fit_w_manipulability_ellipsoid_ang;
    draw_sliders
    update_robot
    draw_contact_surface(contact_surface)
	plot_joint_position_densities
    
    function draw_sliders
        slider_width = 600; 
        label_width = 45;
        tr1 = uicontrol('Parent',f,'Style','slider','Position',[label_width,100,600,25],'value',q_loop(1), 'min',0, 'max',2*pi);                  % [position: [left bottom width height]
        annotation(f,'textbox','String','\theta_{r,1}','units','pix', 'Position', [0,100,label_width,25],'Interpreter','Tex');
        tr1_val = uicontrol('Parent',f,'Style','text','Position',[label_width+slider_width,100,label_width,25],'String',q_loop(1),'BackgroundColor',bgcolor);
        tr1.Callback = @(es,ed) update_ui(1, tr1, tr1_val); 

        tr2 = uicontrol('Parent',f,'Style','slider','Position',[label_width,75,600,25],'value',q_loop(2), 'min',0, 'max',2*pi);                  % [position: [left bottom width height]
        annotation(f,'textbox','String','\theta_{r,2}','units','pix', 'Position', [0,75,label_width,25],'Interpreter','Tex');
        tr2_val = uicontrol('Parent',f,'Style','text','Position',[label_width+slider_width,75,label_width,25],'String',q_loop(2),'BackgroundColor',bgcolor);
        tr2.Callback = @(es,ed) update_ui(2, tr2, tr2_val); 

        tl1 = uicontrol('Parent',f,'Style','slider','Position',[label_width,50,600,25],'value',q_loop(3), 'min',0, 'max',2*pi);                  % [position: [left bottom width height]
        annotation(f,'textbox','String','\theta_{l,1}','units','pix', 'Position', [0,50,label_width,25],'Interpreter','Tex');
        tl1_val = uicontrol('Parent',f,'Style','text','Position',[label_width+slider_width,50,label_width,25],'String',q_loop(3),'BackgroundColor',bgcolor);
        tl1.Callback = @(es,ed) update_ui(3, tl1, tl1_val); 

        tl2 = uicontrol('Parent',f,'Style','slider','Position',[label_width,25,600,25],'value',q_loop(4), 'min',0, 'max',2*pi);                  % [position: [left bottom width height]
        annotation(f,'textbox','String','\theta_{l,2}','units','pix', 'Position', [0,25,45,25],'Interpreter','Tex');
        tl2_val = uicontrol('Parent',f,'Style','text','Position',[label_width+slider_width,25,label_width,25],'String',q_loop(4),'BackgroundColor',bgcolor);
        tl2.Callback = @(es,ed) update_ui(4, tl2, tl2_val); 
                
    end

    function draw_contact_surface(contact_surface)
        x0 = contact_surface(1);
        y0 = contact_surface(2);
        ang = contact_surface(3);
        c = 10;
        X0 = [ x0 + c*cos(ang), y0 + c*sin(ang)];
        Xf = [ x0 - c*cos(ang), y0 - c*sin(ang)];
        line([X0(1,1), Xf(1,1)],[X0(1,2), Xf(1,2)],'LineWidth',2.5,'Color','Red');
    end

    function update_ui(id, slider, disp)
        disp.String = slider.Value;
        q_loop(1,id) = slider.Value;
        update_robot
        plot_joint_position_densities 
    end

    function corr_ = correlate_lin_gaussian_fit_w_manipulability_ellipsoid_ang
                
            % Errors when ellipsoid line approaches vertical
            
            trials = 500;
            n = 50;
            angles = zeros(trials,3);
            random_q0s = rand(trials,4)*2*pi;% n_ind_normal_distributed_random_vars([1.57, 1.57, 1.57, 1.57], q_variances, trials);
            random_contact_surf0s = [(rand(trials,2)*20)-10,rand(trials,1)*2*pi];
            for i=1:trials
                q_loop = random_q0s(i,:);
                contact_surf_loop =  random_contact_surf0s(i,:);
                
                R = n_ind_normal_distributed_random_vars(q_loop, q_variances, n);
                random_contact_surfs = get_n_normdist_endeff_contact_points(contact_surf_loop, 0, n, .0001);
                joint_positions = joint_positions_from_qs(R, random_contact_surfs);
                
                ree_xs = joint_positions(:,6,1);
                ree_ys = joint_positions(:,6,2);
               
                ellipsoid_ang = manipulablilty_ellipsoid_angle(q_loop, contact_surf_loop);
                lin_fit_ang = get_distribution_ang_from_linreg(ree_xs, ree_ys, 0);
                
                angles(i,1) = mod(ellipsoid_ang,365);
                angles(i,2) = mod(lin_fit_ang,365);
%                 angles(i,3) = mod(analytic_ang,365);
            end
            assignin('base','angles',angles)
            corr_12 = corr(angles(:,1),angles(:,2))
            corr_13 = corr(angles(:,1),angles(:,3))
            corr_23 = corr(angles(:,2),angles(:,3))
    end

    function ang_deg = get_distribution_ang_from_linreg(xs,ys, plot)
         %         ree_corr = corr(xs, ys);
         
         x_std =std(xs);
         y_std =std(ys);
         verticality = y_std/x_std; % Handle div/0 cases
         isVertical = verticality > 2.0; %#adjust based on situation (could be 2.0 or more)

        if(isVertical)
           [p_inverted,~] = polyfit(ys, xs,1);   % First order polynomial
           slope = 1/p_inverted(1);
           intercept = -p_inverted(2) / p_inverted(1);
        else 
            [p,~] = polyfit(xs, ys,1);   % First order polynomial
            slope = p(1);
            intercept = p(2);
         
        end
        ang_deg = rad2deg(tan(slope));   

        if plot
            delete(lin_reg_lines(1))
            x0 = mean(xs);
            xl = x0 - 10;
            xr = x0 + 10;
            yl = slope*xl + intercept;
            yr = slope*xr + intercept;
            hold on
            lin_reg_lines(1) = line([xl,xr],[yl,yr],'color','Green');
        end
    end

    function ang_deg = manipulablilty_ellipsoid_angle(q_in, contact_surface)            
            % [x, y]
            q_right_symbolic = [ t_r1_sym t_r2_sym t_l1_sym t_l2_sym xc_sym yc_sym yawc_sym Lb_sym L1_sym L2_sym];
            q_right_vals = [q_in, contact_surface, Ls];
            J_right_real = double(subs(J_ree_symbolic, q_right_symbolic, q_right_vals));
            [U,D,~]=svd(J_right_real*transpose(J_right_real));
            
            c = .05;
            u1 = U(1,:);
            u2 = U(2,:);
            sigma1 = D(1,1);
            sigma2 = D(2,2);
            
            Xs_2 = - c*(u2*sigma2);
            Xf_2 = c*(u2*sigma2);
            
            ang_deg = rad2deg(tan( (Xf_2(1,2)-Xs_2(1,2)) / (Xs_2(1,1)-Xf_2(1,1)) ));
    end

    function plot_joint_position_densities
        disp(' -------------- ')
        if draw_gaussians || draw_histograms
            n = 150;
            nbins = 50;
            eps_ = .01;
            R = n_ind_normal_distributed_random_vars(q_loop, q_variances, n);
            contact_surfaces = get_n_normdist_endeff_contact_points(contact_surface, contact_surface_positional_variance, n, eps_, plot_contact_distribution);
            joint_positions = joint_positions_from_qs(R,contact_surfaces);
            ree_xs = joint_positions(:,6,1);
            ree_ys = joint_positions(:,6,2);
            right_end_effector_xys = [ree_xs, ree_ys];
            get_distribution_ang_from_linreg(ree_xs, ree_ys, true);
                         
        end
        
        % 2d histograms
        if draw_histograms

            delete(histograms(2))
            hold on
            
            xs = joint_positions(:,6,1);
            ys = joint_positions(:,6,2);
            %histograms(1) = histogram2(joint_positions(:,1,1),joint_positions(:,1,2),nbins,'FaceColor','red');
            histograms(2) = histogram2(xs,ys,nbins,'FaceColor','red');
            
            figure(2);
%             figure('pos',[600 1000 519 500])
            cla(2);
            subplot(1,2,1);
            histogram(xs,nbins);
            xlabel('end effector x values');
            ylabel('#');
            
            subplot(1,2,2);
            histogram(ys,nbins);
            xlabel('end effector y values');
            ylabel('#');
            
            figure(1);
            
%             figure(3);
%             figure('pos',[1119 1000 519 500])
%             cla(3);
%             [D, PD] = allfitdist([joint_positions(:,6,1),joint_positions(:,6,2)], 'PDF');
%             D(1)
%             figure(1);
        end
        
        if draw_manipulability_ellipsoid
            
            X0 = endeff_right(q_loop, contact_surface);
            
            % [x, y]
            q_right_symbolic = [ t_r1_sym t_r2_sym t_l1_sym t_l2_sym xc_sym yc_sym yawc_sym Lb_sym L1_sym L2_sym];
            q_right_vals = [q_loop,contact_surface, Ls];
            J_right_real = double(subs(J_ree_symbolic, q_right_symbolic, q_right_vals));
            [U,D,~]=svd(J_right_real*transpose(J_right_real));
            
            c = .075;
            u1 = U(1,:);
            u2 = U(2,:);
            sigma1 = D(1,1);
            sigma2 = D(2,2);
            
            Xs_1 = X0 - c*(u1*sigma1);
            Xf_1 = X0 + c*(u1*sigma1);
            Xs_2 = X0 - c*(u2*sigma2);
            Xf_2 = X0 + c*(u2*sigma2);
            
            ang_deg_manip_ellipsoid = rad2deg(tan( (Xf_2(1,2)-Xs_2(1,2)) / (Xs_2(1,1)-Xf_2(1,1)) ));
            
            hold on
            delete(manipulability_lines(1))
            delete(manipulability_lines(2))
            manipulability_lines(1) = line([Xs_1(1,1), Xf_1(1,1)],[Xs_1(1,2), Xf_1(1,2)],'LineWidth',1.5,'Color','Black');
            manipulability_lines(2) = line([Xs_2(1,1), Xf_2(1,1)],[Xs_2(1,2), Xf_2(1,2)],'LineWidth',1.5,'Color','Black');
            
        end
        
        
        if draw_gaussians

            % end effector right
            mu = mean(right_end_effector_xys);
            sigma = cov(right_end_effector_xys)
            x1 = min(right_end_effector_xys(:,1))-offset:gran:max(right_end_effector_xys(:,1))+offset;
            x2 = min(right_end_effector_xys(:,2))-offset:gran:max(right_end_effector_xys(:,2))+offset;
            [X1,X2] = meshgrid(x1,x2);
            F = mvnpdf([X1(:) X2(:)],mu,sigma);
            F = reshape(F,length(x2),length(x1));

            sigma_x = sqrt(sigma(1,1));
            sigma_y = sqrt(sigma(2,2));
%             row_xy = corr(ree_xs, ree_ys)/(sigma_x*sigma_y);
%             A = (2*row_xy*sigma_x*sigma_y)/(sigma_x^2-sigma_y^2);
%             theta_deg = rad2deg((1/2)*atan(A));
            
%             sol = solve(sigma_x == (cos(theta_sym)^2)/double(2*sigma_x^2) + (sin(theta_sym)^2)/double(2*sigma_y^2) );
%             theta_deg = rad2deg(double(sol(1)))

            
            endeff_r_angle = 23; %fit_2dgaussian_rotation_deg(x1_endeff_r,x2_endeff_r,F_endeff_r);

            latex_endeff_r = strcat(['$ \Sigma_{\textrm{endeff,r}}=',latex(vpa(sym(sigma),matrix_precision))]);
            line_2_r = strcat([  '\mu_{\textrm{endeff,r}}:',  latex(vpa(sym(mu),matrix_precision)), '\textrm{ angle}:', sprintf('%.1f',endeff_r_angle),' $']);

            delete(gaussians(1))
            delete(sigma_label(1))      
            hold on

            gaussians(1) = surf(x1,x2,F);
            sigma_label(1) = annotation(f,'textbox','String',[latex_endeff_r,line_2_r],'units','pix', 'Position', [0,325,200,75],'interpreter','latex','FontSize',11);
                            
        end
    end

    function angle = fit_2dgaussian_rotation_deg(X,Y,Z)
        fitresult = fmgaussfit(X,Y,Z);
        angle=fitresult(2); %in deg 
    end
    
    % --------------- End Effector Positions
    % q = [t_r1_ t_r2_ t_l1_ t_l2_]
    function Pl_endeff = endeff_left(q, contact_surface)
            Pl_endeff = [contact_surface(1), contact_surface(2)];
    end

    function Pl_j2 = j2_left(q, contact_surface)
        x_c = contact_surface(1);
        y_c = contact_surface(1);
        yaw_c = contact_surface(3);
        Pl_j2 = [ x_c + L2*sin(yaw_c),...
                  y_c - L2*cos(yaw_c) ];
    end
    
    function Pl_j1 = j1_left(q, contact_surface)
        x_c = contact_surface(1);
        y_c = contact_surface(1);
        yaw_c = contact_surface(3);
        Pl_j1 = [ x_c + L2*sin(yaw_c) + L1*sin(q(4)-yaw_c), ...
                  y_c - L2*cos(yaw_c)+ L1*cos(q(4)-yaw_c) ];
    end

    function Pr_j1 = j1_right(q, contact_surface)
        x_c = contact_surface(1);
        y_c = contact_surface(1);
        yaw_c = contact_surface(3);
        Pr_j1 = [ x_c + L2*sin(yaw_c) + L1*sin(q(4)-yaw_c) - Lb*sin(q(3)+q(4)-yaw_c), ...
                  y_c - L2*cos(yaw_c)+ L1*cos(q(4)-yaw_c) - Lb*cos(q(3)+q(4)-yaw_c) ];
    end

    function Pr_j2 = j2_right(q, contact_surface)
        x_c = contact_surface(1);
        y_c = contact_surface(1);
        yaw_c = contact_surface(3);
        
        Pr_j2 = [ x_c - Lb*sin(q(3)+q(4)-yaw_c) + L2*sin(yaw_c) + L1*sin( q(3)+q(4)+q(1) - yaw_c)  + L1*sin(q(4)-yaw_c), ...
                  y_c - Lb*cos(q(3)+q(4)-yaw_c) - L2*cos(yaw_c) + L1*cos( q(3)+q(4)+q(1) - yaw_c) + L1*cos(q(4)-yaw_c)  ];

    end
    
    function Pr_endeff = endeff_right(q, contact_surface)
        x_c = contact_surface(1);
        y_c = contact_surface(1);
        yaw_c = contact_surface(3);
        Pr_endeff = [ x_c - L2*sin(q(1)+q(2)+q(3)+q(4) - yaw_c) - Lb*sin(q(3)+q(4)-yaw_c) + L2*sin(yaw_c) + L1*sin( q(3)+q(4)+q(1) - yaw_c)  + L1*sin(q(4)-yaw_c), ...
                      y_c - L2*cos(q(1)+q(2)+q(3)+q(4) - yaw_c) - Lb*cos(q(3)+q(4)-yaw_c) - L2*cos(yaw_c) + L1*cos( q(3)+q(4)+q(1) - yaw_c)  + L1*cos(q(4)-yaw_c)  ];
    end

    function update_robot

        delete(hLines(1))
        delete(hLines(2))
        delete(hLines(3))
        delete(hLines(4))
        delete(hLines(5))
             
        Pl_j1 = j1_left(q_loop, contact_surface);
        Pl_j2 = j2_left(q_loop, contact_surface);
        Pl_endeff = endeff_left(q_loop, contact_surface);
        
        Pr_j1 = j1_right(q_loop, contact_surface);
        Pr_j2 = j2_right(q_loop, contact_surface);
        Pr_end_eff = endeff_right(q_loop, contact_surface);
        
        hLines(1) = line([ Pl_j1(1,1), Pr_j1(1,1) ],[ Pl_j1(1,2), Pr_j1(1,2)],'LineWidth',5);
        hLines(2) = line([ Pr_j1(1,1), Pr_j2(1,1) ],[ Pr_j1(1,2), Pr_j2(1,2)],'LineWidth',3);
        hLines(3) = line([ Pr_j2(1,1), Pr_end_eff(1,1) ],[ Pr_j2(1,2), Pr_end_eff(1,2)],'LineWidth',3);
        hLines(4) = line([Pl_j1(1,1),Pl_j2(1,1) ],[ Pl_j1(1,2), Pl_j2(1,2) ],'LineWidth',3);
        hLines(5) = line([Pl_j2(1,1),Pl_endeff(1,1) ],[ Pl_j2(1,2), Pl_endeff(1,2) ],'LineWidth',3);
    end

    function contacts =  get_n_normdist_endeff_contact_points(contact_surface, variance, n, eps_, plot)
        plot = false;
        s_vals = n_ind_normal_distributed_random_vars(0,variance,n);
        %random_offset_vals = n_ind_normal_distributed_random_vars([0,0,0],[eps_,eps_,0],n);
        x = contact_surface(1) + s_vals * cos(contact_surface(1));
        y = contact_surface(2) + s_vals * sin(contact_surface(2));
        yaws = ones(n,1)*contact_surface(3);
        contacts = [x,y,yaws]; %+ random_offset_vals;
        
        if plot
            offset = .5;
            xys = [x,y]; 
            mu = mean(xys)
            sigma = cov(xys)
            x1_range = min(xys(:,1))-offset:gran:max(xys(:,1))+offset;
            x2_range = min(xys(:,2))-offset:gran:max(xys(:,2))+offset;
            [X1,X2] = meshgrid(x1_range,x2_range);
            F = mvnpdf([X1(:) X2(:)],mu,sigma);
            F = reshape(F,length(x2_range),length(x1_range));

            endeff_r_angle = 23 %fit_2dgaussian_rotation_deg(x1_endeff_r,x2_endeff_r,F_endeff_r);

            latex_endeff_r = strcat(['$ \Sigma_{\textrm{endeff,r}}=',latex(vpa(sym(sigma),matrix_precision))]);
            line_2_r = strcat([  '\mu_{\textrm{endeff,r}}:',  latex(vpa(sym(mu),matrix_precision)), '\textrm{ angle}:', sprintf('%.1f',endeff_r_angle),' $']);

            delete(gaussians(2))
            delete(sigma_label(2))      
            hold on
            gaussians(2) = surf(x1_range,x2_range,F);                
            sigma_label(2) = annotation(f,'textbox','String',[latex_endeff_r,line_2_r],'units','pix', 'Position', [0,325,200,75],'interpreter','latex','FontSize',11);
        end
    end
    
    function joint_positions = joint_positions_from_qs(qs, contact_surfaces)
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
        joint_positions = zeros(q_size(1,1), 4, 2);

        for i=1:q_size(1,1)

            Pl_j1 = j1_left(qs(i,:), contact_surfaces(i,:));
            Pl_j2 = j2_left(qs(i,:), contact_surfaces(i,:));
            Pl_endeff = endeff_left(qs(i,:), contact_surfaces(i,:));
            Pr_j1 = j1_right(qs(i,:), contact_surfaces(i,:));
            Pr_j2 = j2_right(qs(i,:), contact_surfaces(i,:));
            Pr_end_eff = endeff_right(qs(i,:), contact_surfaces(i,:));


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





function rotation_matrixes
%     
%     se2 = @(theta,x,y) [
%             cos(theta) sin(theta) x
%            -sin(theta) cos(theta) y
%             0          0          1
%         ];
%     
%     T2 = @(x,y) [
%             1 0 x
%             0 1 y
%             0 0 1
%     ];
%     
%     % --- Right side
%     Rr_rj1 = [1 0 Lb_sym / 2;
%                 0 1 0
%                 0 0 1]* [cos(t_r1_sym - pi), sin(t_r1_sym - pi) 0;
%                        - sin(t_r1_sym - pi), cos(t_r1_sym - pi) 0;
%                          0 0 1];
%             
%     Rrj1_rj2 = [1 0 L1_sym;
%               0 1 0;
%               0 0 1]* [ cos(pi + t_r2_sym), sin(pi + t_r2_sym), 0;
%                       - sin(pi + t_r2_sym), cos(pi + t_r2_sym), 0;
%                         0 0 1 ];
%     Rrj2_ree = [ 1 0 L2_sym;
%                 0 1 0;
%                 0 0 1 ];
%     
%     % --- Left side
%     Rr_lj1 = [ 1 0, - Lb_sym/2;
%               0 1 0
%               0 0 1 ]*[ cos( -t_l1_sym), sin( -t_l1_sym), 0;
%                       - sin( -t_l1_sym), cos( -t_l1_sym), 0;
%                         0                       0                       1 ];
%     Rlj1_r = inv(Rr_lj1);
%               
%     Rlj1_lj2 = [1 0 L1_sym;
%                 0 1 0
%                 0 0 1 ]*[ cos(- pi - t_l2_sym), sin(- pi - t_l2_sym), 0;
%                         - sin(- pi - t_l2_sym), cos(- pi - t_l2_sym), 0
%                             0 0 1 ];
%     Rlj2_lj1 = inv(Rlj1_lj2);
%     Rlj1_rj1 = Rlj1_r * Rr_rj1;
%     
%     Rlee_lj2 = T2(-L2_sym, 0);
%     Rw_lee = se2( (3*pi)/2 - yawc_sym , xc_sym, yc_sym);
%     
%     Rw_lj2 = Rw_lee * Rlee_lj2;
%     Rw_lj1 = Rw_lee * Rlee_lj2 * Rlj2_lj1;
%     Rw_rj1 =  Rw_lee * Rlee_lj2 * Rlj2_lj1 * Rlj1_rj1;
%     Rw_rj2 =  Rw_lee * Rlee_lj2 * Rlj2_lj1 * Rlj1_rj1 * Rrj1_rj2;
%     Rw_ree =  Rw_lee * Rlee_lj2 * Rlj2_lj1 * Rlj1_rj1 * Rrj1_rj2*Rrj2_ree;
%     Rw_ree*[0;0;1];
% 
%     % ang = atan2(A21,A11)
%     ree = latex(simplify(   Rw_ree*[0;0;1]     ));

end