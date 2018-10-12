close
clear all
clc

% syms yaw_b x_b y_b t_r1 t_r2 t_l1 t_l2 Lb L1 L2
% 
% Rs_b = [
%     cos(yaw_b)  -sin(yaw_b) x_b; 
%     sin(yaw_b) cos(yaw_b) y_b;
%     0           0           1
%         ];
% Rb_r1 = [ 1  0  Lb/2;
%           0  1   0 
%           0  0    1
%          ];
% Rr1_r1rot = [
%         cos(t_r1 - pi) sin(t_r1 - pi)     0; 
%         -sin(t_r1 - pi) cos(t_r1 - pi)    0;
%         0           0           1
%     ];
%  Rr1rot_r2 = [
%         1 0 L1; 
%         0 1 0;
%         0 0 1
%     ];
% Rr2_r2rot = [
%         cos(pi+t_r2) sin(pi+t_r2)     0; 
%         -sin(pi+t_r2) cos(pi+t_r2)    0;
%         0           0                 1
% ];
% Rr2rot_r_end_eff =[
%         1 0 L2; 
%         0 1 0;
%         0 0 1
%     ];


% Rb_l1 = [ 1  0  -Lb/2;
%           0  1   0 
%           0  0    1
%          ];
% Rl1_l1rot = [
%         cos(2*pi-t_l1)  sin(2*pi-t_l1)     0; 
%         -sin(2*pi-t_l1) cos(2*pi-t_l1)    0;
%         0           0           1
%    ];
% Rl1rot_l2 = [ 1  0  L1;
%               0  1   0 
%               0  0    1
%              ];
% Rl2_l2rot = [ cos(-pi - t_l2)  sin(-pi - t_l2)     0; 
%              -sin(-pi - t_l2) cos(-pi - t_l2)   0 
%               0  0    1
%              ];
% Rrotl2_endeff = [ 1  0  L2;
%                   0  1   0 
%                   0  0   1
%                 ];    
%      
% 
% P2l = Rs_b * Rb_l1 * Rl1_l1rot * Rl1rot_l2;
% P2l = simplify(P2l);      
% latex(P2l)  
% 
% Pl_endeff = Rs_b * Rb_l1 * Rl1_l1rot * Rl1rot_l2 * Rl2_l2rot * Rrotl2_endeff ;
% Pl_endeff = simplify(Pl_endeff);
% latex(Pl_endeff)


%          
% % Rr = Rs_b * Rb_r1 * Rr1_r1rot * Rr1rot_r2 * Rr2_r2rot * Rr2rot_r_end_eff ;
% % Rr = simplify(Rr);
% % latex(Rr)                            % \left(\begin{array}{ccc} \cos\!\left(\theta_{r,1} + \theta_{r,2} - \Psi_b\right) & \sin\!\left(\theta_{r,1} + \theta_{r,2} - \Psi_b\right) & x_{b} + L_2\, \cos\!\left(\theta_{r,1} + \theta_{r,2} - \Psi_b\right) + \frac{L_b\, \cos\!\left(\Psi_b\right)}{2} - L_1\, \cos\!\left(\theta_{r,1} - \Psi_b\right)\\ - \sin\!\left(\theta_{r,1} + \theta_{r,2} - \Psi_b\right) & \cos\!\left(\theta_{r,1} + \theta_{r,2} - \Psi_b\right) & y_{b} - L_2\, \sin\!\left(\theta_{r,1} + \theta_{r,2} - \Psi_b\right) + \frac{L_b\, \sin\!\left(\Psi_b\right)}{2} + L_1\, \sin\!\left(\theta_{r,1} - \Psi_b\right)\\ 0 & 0 & 1 \end{array}\right)
% 
% % P2r = Rs_b * Rb_r1 * Rr1_r1rot * Rr1rot_r2;
% % P2r = simplify(P2r);      
% % latex(P2r)                             % latex: \left(\begin{array}{ccc} - \cos\!\left(\theta_{r,1} - \psi_b\right) & - \sin\!\left(\theta_{r,1} - \psi_b\right) & x_{b} + \frac{\mathrm{L_b}\, \cos\!\left(\psi_b\right)}{2} - \mathrm{L1}\, \cos\!\left(\theta_{r,1} - \psi_b\right)\\ \sin\!\left(\theta_{r,1} - \psi_b\right) & - \cos\!\left(\theta_{r,1} - \psi_b\right) & y_{b} + \frac{\mathrm{L_b}\, \sin\!\left(\psi_b\right)}{2} + \mathrm{L1}\, \sin\!\left(\theta_{r,1} - \psi_b\right)\\ 0 & 0 & 1 \end{array}\right)
% 
% % P1r = Rs_b * Rb_r1;
% % P1r = simplify(P1r);
% % latex(P1r)                               % latex: \left(\begin{array}{ccc} \cos\!\left(\mathrm{yaw}_{b}\right) & - \sin\!\left(\mathrm{yaw}_{b}\right) & x_{b} + \frac{\mathrm{Lb}\, \cos\!\left(\mathrm{yaw}_{b}\right)}{2}\\ \sin\!\left(\mathrm{yaw}_{b}\right) & \cos\!\left(\mathrm{yaw}_{b}\right) & y_{b} + \frac{\mathrm{Lb}\, \sin\!\left(\mathrm{yaw}_{b}\right)}{2}\\ 0 & 0 & 1 \end{array}\right)
    
uirunner
function uirunner
    
    min_x = -10;
    max_x = 10;
    min_y = -10;
    max_y = 10;

    xb = 2;
    yb = 4;
    yawb = deg2rad(0);
    t_l1 = 2.6;
    t_l2 = 5.2;
    
    t_r1 = 2.6;
    t_r2 = 5.2;
    Lb = 2;
    L1 = 3;
    L2 = 5;

    q = [xb yb yawb t_r1 t_r2 t_l1 t_l2 ];
  
    f = figure;
    bgcolor = f.Color;
    %axis([min_x max_x min_y max_y])
    ax = axes('position',[0.1 0.25 0.8 0.8]);
    grid on
    pbaspect([1 1 1])   
    ax.XLim = [min_x, max_x];
    ax.YLim = [min_y, max_y];
    
%     setoptions(f,'XLim',[0,10],'YLim',[0,2]);

    body_x = uicontrol('Parent',f,'Style','slider','Position',[75,100,600,25],'value',xb, 'min',min_x, 'max',max_x);                  % [position: [left bottom width height]
    annotation(f,'textbox','String','X_b','units','pix', 'Position', [25,100,45,25],'Interpreter','Tex');
    body_x_val = uicontrol('Parent',f,'Style','text','Position',[695,100,45,25],'String',xb,'BackgroundColor',bgcolor);
    body_x.Callback = @(es,ed) update_ui(1, body_x, body_x_val); 
    
    body_y = uicontrol('Parent',f,'Style','slider','Position',[75,75,600,25],'value',yb, 'min',min_y, 'max',max_y);                  % [position: [left bottom width height]
    annotation(f,'textbox','String','Y_b','units','pix', 'Position', [25,75,45,25],'Interpreter','Tex');
    body_y_val = uicontrol('Parent',f,'Style','text','Position',[695,75,45,25],'String',yb,'BackgroundColor',bgcolor);
    body_y.Callback = @(es,ed) update_ui(2, body_y, body_y_val); 
    
    body_yaw = uicontrol('Parent',f,'Style','slider','Position',[75,50,600,25],'value',yawb, 'min',0, 'max',2*pi);                  % [position: [left bottom width height]
    annotation(f,'textbox','String','\Psi_b','units','pix', 'Position', [25,50,45,25],'Interpreter','Tex');
    body_yaw_val = uicontrol('Parent',f,'Style','text','Position',[695,50,45,25],'String',yawb,'BackgroundColor',bgcolor);
    body_yaw.Callback = @(es,ed) update_ui(3, body_yaw, body_yaw_val); 
    
    tr1 = uicontrol('Parent',f,'Style','slider','Position',[800,100,600,25],'value',t_r1, 'min',0, 'max',2*pi);                  % [position: [left bottom width height]
    annotation(f,'textbox','String','\theta_{r,1}','units','pix', 'Position', [750,100,45,25],'Interpreter','Tex');
    tr1_val = uicontrol('Parent',f,'Style','text','Position',[1425,100,45,25],'String',t_r1,'BackgroundColor',bgcolor);
    tr1.Callback = @(es,ed) update_ui(4, tr1, tr1_val); 
    
    tr2 = uicontrol('Parent',f,'Style','slider','Position',[800,75,600,25],'value',t_r2, 'min',0, 'max',2*pi);                  % [position: [left bottom width height]
    annotation(f,'textbox','String','\theta_{r,2}','units','pix', 'Position', [750,75,45,25],'Interpreter','Tex');
    tr2_val = uicontrol('Parent',f,'Style','text','Position',[1425,75,45,25],'String',t_r2,'BackgroundColor',bgcolor);
    tr2.Callback = @(es,ed) update_ui(5, tr2, tr2_val); 
    
    tl1 = uicontrol('Parent',f,'Style','slider','Position',[800,50,600,25],'value',t_l1, 'min',0, 'max',2*pi);                  % [position: [left bottom width height]
    annotation(f,'textbox','String','\theta_{l,1}','units','pix', 'Position', [750,50,45,25],'Interpreter','Tex');
    tl1_val = uicontrol('Parent',f,'Style','text','Position',[1425,50,45,25],'String',t_l1,'BackgroundColor',bgcolor);
    tl1.Callback = @(es,ed) update_ui(6, tl1, tl1_val); 
    
    tl2 = uicontrol('Parent',f,'Style','slider','Position',[800,25,600,25],'value',t_l2, 'min',0, 'max',2*pi);                  % [position: [left bottom width height]
    annotation(f,'textbox','String','\theta_{l,2}','units','pix', 'Position', [750,25,45,25],'Interpreter','Tex');
    tl2_val = uicontrol('Parent',f,'Style','text','Position',[1425,25,45,25],'String',t_l2,'BackgroundColor',bgcolor);
    tl2.Callback = @(es,ed) update_ui(7, tl2, tl2_val); 
    
    
    global hLines
    hLines(1) = line([0,0],[0,0]);
    hLines(2) = line([0,0],[0,0]);
    hLines(3) = line([0,0],[0,0]);
    hLines(4) = line([0,0],[0,0]);
    hLines(5) = line([0,0],[0,0]);
    update_robot

    function update_ui(id, slider, disp)
        disp.String = slider.Value;
        q(1,id) = slider.Value;
        update_robot
    end

    function update_robot
        xb = q(1,1);
        yb = q(1,2);
        yawb = q(1,3);
        t_r1 = q(1,4);
        t_r2 = q(1,5);
        t_l1 = q(1,6);
        t_l2 = q(1,7);

        delete(hLines(1))
        delete(hLines(2))
        delete(hLines(3))
        delete(hLines(4))
        delete(hLines(5))
        
        
        
        
                Pl_j1 = [xb - (Lb/2)*cos(yawb), yb-(Lb/2)*sin(yawb) ];
                Pl_j2 = [
                         xb - (Lb/2)*cos(yawb) + L1*cos(t_l1 + yawb),...
                         yb-(Lb/2)*sin(yawb) + L1*sin(t_l1 + yawb)
                        ];
                Pl_endeff = [
                         xb - (Lb/2)*cos(yawb) + L1*cos(t_l1 + yawb) - L2*cos(t_l1 + t_l2 + yawb),...
                         yb - (Lb/2)*sin(yawb) + L1*sin(t_l1 + yawb) - L2*sin(t_l1 + t_l2 + yawb)
                        ];
        
                    
        
        
        Pr_j1 = [xb + (Lb/2)*cos(yawb), yb+(Lb/2)*sin(yawb) ];
        
        Pr_j2 = [ xb + (Lb/2)*cos(yawb) - L1*cos(t_r1 - yawb), ...
                  yb + (Lb/2)*sin(yawb)   + L1*sin(t_r1 - yawb)
                 ];

        Pr_end_eff =  [ xb + (Lb/2)*cos(yawb) - L1*cos(t_r1 - yawb) + L2*cos(t_r1+t_r2 - yawb) ,...
                        yb + (Lb/2)*sin(yawb)   + L1*sin(t_r1 - yawb) - L2*sin(t_r1+t_r2 - yawb)
                 ];
        
        
        hLines(1) = line([ Pl_j1(1,1), Pr_j1(1,1) ],[ Pl_j1(1,2), Pr_j1(1,2)],'LineWidth',5);
        hLines(2) = line([ Pr_j1(1,1), Pr_j2(1,1) ],[ Pr_j1(1,2), Pr_j2(1,2)],'LineWidth',3,'LineStyle','-.');
        hLines(3) = line([ Pr_j2(1,1), Pr_end_eff(1,1) ],[ Pr_j2(1,2), Pr_end_eff(1,2)],'LineWidth',3);
        
        hLines(4) = line([Pl_j1(1,1),Pl_j2(1,1) ],[ Pl_j1(1,2), Pl_j2(1,2) ],'LineWidth',3);
        hLines(5) = line([Pl_j2(1,1),Pl_endeff(1,1) ],[ Pl_j2(1,2), Pl_endeff(1,2) ],'LineWidth',3,'Color','red' );
        
    end

end






