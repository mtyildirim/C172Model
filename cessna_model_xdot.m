function [XDOT,DCM] = cessna_model_xdot(x,u,g,rho)  % Muhammet Tarık Yıldırım,Marmara University,2023

x1=x(1);    %u
x2=x(2);    %v
x3=x(3);    %w
x4=x(4);    %p
x5=x(5);    %q
x6=x(6);    %r
x7=x(7);    %phi
x8=x(8);    %theta
x9=x(9);    %psi
x10=x(10);  %x
x11=x(11);  %y
x12=x(12);  %z

u1=u(1);    % Aileron Input (Deflection)
u2=u(2);    % Elevator Input (Deflection)
u3=u(3);    % Rudder Input   (Deflection)
u4=u(4);    % Thrust In Newtons


m = 815 ; % Mass
Inertia = [1285.3154279 0 -161.5 ; 0 1824.9309767 0 ; -161.5 0 2666.893931];
S = 16; % Wing Area
Cbar = 1.45; % Mean Aerodynamic Chord
b = 11; % Winspan

Va = sqrt((x1^2)+(x2^2)+(x3^2)); % Airspeed

alphar = atan2(x3,x1);   %Angle of Attack
alpha=rad2deg(alphar);
betar = asin(x2/Va);     %Angle of Sideslip
beta =rad2deg(betar);
qbar = 0.5*rho*Va^2;    %Dynamic Pressure


C1 = [cos(x9) sin(x9) 0 ; -sin(x9) cos(x9) 0 ; 0 0 1];
C2 = [cos(x8) 0 -sin(x8);0 1 0 ; sin(x8) 0 cos(x8)];  % Direction Cosine Matrix
C3 = [1 0 0 ; 0 cos(x7) sin(x7); 0 -sin(x7) cos(x7)];
Cw_b = C1*C2*C3;
DCM = transpose(Cw_b);


u1max = 10*pi/180;
u1min =-10*pi/180;
u2max = 20*pi/180;    % Control Surface Limits
u2min =-20*pi/180;
u3max = 10*pi/180;
u3min =-10*pi/180;

if(u1>u1max)
    u1=u1max;
elseif(u1<u1min)        % Control Saturations
    u1=u1min;
end
if(u2>u2max)
    u2=u2max;
elseif(u2<u2min)
    u2=u2min;
end
if(u3>u3max)
    u3=u3max;
elseif(u3<u3min)
    u3=u3min;
end

Ct = 0.031;
CD = (0.031+0.13*alpha+0.06*u2);
CL = (5.143*alpha+0.43*u2+0.31+3.9*x5); % Aerodynamic Force And Moment Coefficients , Stability Coefficients
Clm = (0.178*u1+0.0147*u3-0.047*x4);
Cmm = (-0.89*alpha-12.4*x5-1.28*u2);
Cnm = (0.065*beta-0.099*x6-0.0657*u3);

CX = -CD*cos(alpha)+CL*sin(alpha);    
CY = (-0.31*beta+0.187*u3);        % Force Coefficients
CZ = -CD*sin(alpha)-CL*cos(alpha);

%Translational Accelerations On Body
Xab = (CX*qbar*S+Ct*u4)/m;
Yab = (CY*qbar*S)/m;
Zab = (CZ*qbar*S)/m;

x16to18dot=[Xab;Yab;Zab];

%Rotational Accelerations On Body
Lb = Clm*qbar*S*b;
Mb = Cmm*qbar*S*Cbar;
Nb = Cnm*qbar*S*b;
Load_Factor = Zab/g;

% Equations Of Motion
Udot = Xab + (x6*x2-x2*x5)*g*cos(x8);
Vdot = Yab + (x4*x3-x1*x6)*sin(x7)*cos(x8);
Wdot = Zab + (x5*x1-x4*x2)*cos(x7)*cos(x8);
x1to3dot = [Udot;Vdot;Wdot];

Pdot = Lb/1285.3154279 ;
Qdot = (Mb+(2666.893931-1285.3154279)*x4*x6)/1824.9309767;
Rdot = (Nb+(1285.3154279-1824.9309767)*x4*x5)/2666.893931;
x4to6dot=[Pdot;Qdot;Rdot];
Wbe = [x4;x5;x6];
% Euler Angles
x7to9dot=[1 sin(x7)*tan(x8) cos(x7)*tan(x8);0 cos(x7) -sin(x7);0 sin(x7)*cos(x8) cos(x7)*cos(x8)]*Wbe;
V_b = [x1;x2;x3];

% Position  
x10to12dot=DCM*V_b;

% Velocities on Earth Frame
x13to15dot=DCM*V_b;


XDOT=[x1to3dot;x4to6dot;x7to9dot;x10to12dot;x13to15dot;x16to18dot];




