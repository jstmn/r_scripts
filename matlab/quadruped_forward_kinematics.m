clc


L1 = 5;
L2 = 5;
L3 = 5;

%thetas = [pi/2 0 0];

t0 = thetas(1);
t1 = thetas(2);
t2 = thetas(3);

syms L1 L2 L3
syms t0 t1 t2

T0 = [1 0 0 0; 0 1 0 0; 0 0 1 L1; 0 0 0 1];
T0_1 = [cos(t0) -sin(t0) 0 0; sin(t0) cos(t0) 0 0; 0 0 1 0; 0 0 0 1];
T1_2 = [cos(t1 - pi/2) 0 sin(t1 - pi/2) 0; 0 1 0 0; -sin(t1-pi/2) 0 cos(t1 - pi/2) 0; 0 0 0 1];
T2_3 = [1 0 0 0; 0 1 0 0; 0 0 1 L2; 0 0 0 1];

beta = - t2 + pi;
T3_4 = [cos(beta) 0 sin(beta) 0; 0 1 0 0; -sin(beta) 0 cos(beta) 0; 0 0 0 1];
T4_e = [1 0 0 0; 0 1 0 0; 0 0 1 L3; 0 0 0 1];

T = T0 * T0_1 * T1_2 * T2_3 * T3_4 * T4_e;
R = T(1:3, 1:3);
t = [T(1,4), T(2,4), T(3,4)];
J = jacobian(t,[t0, t1, t2])










function myui

    L1 = 5;
    L2 = 5;
    L3 = 5;
    thetas = [0,0,0];

    f = figure('Visible','off');
    ax = axes('Units','pixels');
    
    %figure
    quiverL1 = quiver3(0,0,0,0,0,L1);
    quiverL2 = quiver3(0,0,L1,L1,0,L1);

    
    theta1_txt = uicontrol('Style','text',...
        'Position',[400 45 120 20],...
        'String','Vertical Exaggeration');
    
    theta1 = uicontrol('Style', 'slider',...
        'Min',0,'Max',6.28,'Value',0,...
        'Position', [400 20 250 30],...
        'Callback', @cback_t0); 

    function cback_t0(source, event)
        thetas(1)= source.Value;
        update_hs;
    end
    
    function update_hs()
        
        r0 = [0,0,0];
        r1 = [0,0,L1];
        r2 = [ L2*cos(thetas(1))*sin(thetas(2)),...
               L2*sin(thetas(1))*sin(thetas(2)),...
               L1 - L2*cos(thetas(2))
             ];
        r10_v = r1-r0;
        r21_v = r2-r1;
        
        quiverL2.XData = 0;
        quiverL2.YData = 0;
        quiverL2.ZData = L1;
        quiverL2.UData = r21_v(1);
        quiverL2.VData = r21_v(2);
        quiverL2.WData = r21_v(3);
        
        %l1 = quiver3( r10_v(1), r10_v(2), r10_v(3), r21_v(1), r21_v(2), r21_v(3)); 
    end

end