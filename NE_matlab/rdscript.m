%% recursive dynamics script for 2 and 3 open link
% assumes 
%   symbolic variables and opts exist and are sensible
%   R01 R12 and R23 are correct
if ~exist('opts','var')
    warning('opts are not optional!');
end

%% anonymous helper functions
dvpoint=@(wj_j,dwj_j,dvj_j,pjcog) cross(dwj_j,pjcog)+cross(wj_j,cross(wj_j,pjcog)) + dvj_j; % Craig 6.48 - calculate the acceleration at a point on the spinning frame

if isfield(opts,'exp') && opts.exp==3
    theta_3=0;
end

if isfield(opts,'exp') && opts.exp==1
    theta_1=0;
end

%% Set up other variables

g=[0 g_y 0]'; % g=[g_x; g_y; 0];
if exist('opts','var') && isfield(opts,'gravity') && opts.gravity=="g_x" % opts.gravity=='g_x'
    g=[g_x 0 0]'; %
end
if exist('opts','var') && isfield(opts,'gravity') && opts.gravity=="all" % opts.
    g=[g_x g_y g_z]'; 
end
if exist('opts','var') && isfield(opts,'gravity') && opts.gravity=="g_z" % opts.
    g=[0 0 g_z]'; 
end


p0_1=[0 0 0]';  % vec in {0} to {1}   p0_1=... (they are colocated)
p1_2=[L_1 0 0]'; % vec in {1} to {2} also in {1} to {3}
pcog1=[L_1 0 0]';
p2_3=[L_2 0 0]';
pcog2=p2_3;
pcog3=[L_3 0 0]';    

if exist('opts','var') && isfield(opts,'cog');
    if opts.cog==0; % use an explicit centre of mass
        pcog1=[Lcog1 0 0]';
        pcog2=[Lcog2 0 0]';
        pcog3=[Lcog3 0 0]';
    else
        pcog1=[L_1 0 0]'*opts.cog; % can set to 1 or .5 for example
        pcog2=[L_2 0 0]'*opts.cog;
        pcog3=[L_3 0 0]'*opts.cog;
    end
else
    warning('opts or opts.cog does not exist, setting com at end of link')
end

if isfield(opts,'inertia') && opts.inertia;
    Jc1=diag([Ixx1 Iyy1 Izz1]);  % Jc1=...
    Jc2=diag([Ixx2 Iyy2 Izz2]);  % Jc2=...
    Jc3=diag([Ixx3 Iyy3 Izz3]);
else
    Jc1=zeros(3,3);
    Jc2=zeros(3,3);
    Jc3=zeros(3,3);
end


%% Initial assumptions
% will assume that w0_0 = 0, dw0_0 = 0 and dv0_0 = g
% Set up frame 0 so it does not rotate and use dv_0 = g to handle gravitational forces

w0_0=[0;0;0]; % the world is not revolving
dw0_0=[0;0;0]; % world angular acceleration =0
dv0_0=g; % The world is accelerating upwards (on the back of a cosmic turtle!)
%% Outward propagation of accelerations

% 0 to 1
 [w1_1,dw1_1,dv1_1]=rdoutward(w0_0,dw0_0,dv0_0,R01',p0_1, [0;0;1]*dtheta_1,[0;0;1]*ddtheta_1); % Craig's convention (check R') (note index change on the joint angles
 dvcog1_1=dvpoint(w1_1,dw1_1,dv1_1,pcog1);
 F1_1=m_1*dvcog1_1; % 6.49
 N1_1=Jc1*dw1_1 + cross(w1_1,Jc1*w1_1); % 6.50
% 1 to 2
 [w2_2,dw2_2,dv2_2]=rdoutward(w1_1,dw1_1,dv1_1,R12',p1_2, [0;0;1]*dtheta_2,[0;0;1]*ddtheta_2); % Craig's convention (check R') (note index change on the joint angles
 dv2_2=simplify(combine(expand(dv2_2),'sincos')); % get an expression with s12 and c12 (this line is not necessary, but is here to simplify planar linkages
 dvcog2_2=dvpoint(w2_2,dw2_2,dv2_2,pcog2);
 F2_2=m_2*dvcog2_2; % 6.49
 N2_2=Jc2*dw2_2 + cross(w2_2,Jc2*w2_2); % 6.50
 % 2 to 3
 [w3_3,dw3_3,dv3_3]=rdoutward(w2_2,dw2_2,dv2_2,R23',p2_3, [0;0;1]*dtheta_3,[0;0;1]*ddtheta_3); % Craig's convention (check R') (note index change on the joint angles
 dv3_3=simplify(combine(expand(dv3_3),'sincos')); % get an expression with s12 and c12 (this line is not necessary, but is here to simplify planar linkages
 dvcog3_3=dvpoint(w3_3,dw3_3,dv3_3,pcog3);
 F3_3=m_3*dvcog3_3; % 6.49
 N3_3=Jc3*dw3_3 + cross(w3_3,Jc3*w3_3); % 6.50

%% Inwards/Backwards
%f11=R12*f22+F11;
% forces/torques at joint due to link 3
% link 3
if opts.numlinks==3
    f3_3=F3_3;
    n3_3=cross(pcog3,F3_3) + N3_3;
else
    f3_3=[0;0;0];n3_3=[0;0;0]; % ignore link 3
end


% link 2
f2_2=R23*f3_3 +  F2_2;
n2_2=R23*n3_3 + cross(p2_3,R23*f3_3) + cross(pcog2,F2_2) + N2_2 ; %6.52 Note that p1_2 is used twice vs set p1_3=p1_2;

% link 1
f1_1=R12*f2_2 + F1_1;
n1_1=R12*n2_2 + cross(p1_2,R12*f2_2) + cross(pcog1,F1_1) + N1_1 ; %6.52 Note that p1_2 is used twice vs set p1_3=p1_2;



%% Group results


if opts.numlinks==3
    tau=[n1_1(3);n2_2(3);n3_3(3)];
    faxial=[f1_1(1) f2_2(1) f3_3(1)];
end

if opts.numlinks==2
    tau=[n1_1(3);n2_2(3)];
    faxial=[f1_1(1) f2_2(1)];
    % - currently happening in control files    tau1=expand(tau);
end

disp(sprintf('Success. Now run rdhelper to simplify and write out the results'))
