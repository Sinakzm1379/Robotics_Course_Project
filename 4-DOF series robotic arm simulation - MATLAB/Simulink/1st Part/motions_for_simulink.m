clc
close all
%% parametes 
a = 10/1.6;
b = 0;
c = -a;
d = 0;
dd = 0;
e = 0;
ee = 0;
%%
BETA = atan(48/9);

%% initial and final joint angles
theta_i = [0 ; 0 ; 0 ; 0 ] ;
theta_f = [-pi/2 ; pi/3-BETA ; -pi/6+BETA ; -pi/5 ];
%%
tf = 1;
Ts_M = 0.00001;
Ts = 0.001;
T = 0 : Ts_M : tf;
t_n_U = 0.8;
t_n_D = 0.2;
%%
p=0;
for j = 0 : Ts_M : tf
    p = p + 1;
    t_n = j/tf;
    
    if ((t_n >= 0) && (t_n <= t_n_D)) 
        s(p) = (a * t_n^2)/2;
        s_prime(p) = a*t_n;
        s_second(p) = a;
        b = a*t_n;
        d = (a * t_n^2)/2;
    elseif ((t_n > t_n_D) && (t_n <= t_n_U))
        s(p) = d + b * (t_n-t_n_D);
        s_prime(p) = b;
        s_second(p) = 0;
        dd = d + b * (t_n-t_n_D);
    elseif ((t_n > t_n_U) && (t_n <= 1))
        s(p) = dd + b*(t_n-t_n_U)+(c*(t_n-t_n_U)^2)/2;
        s_prime(p) = b + c*(t_n-t_n_U);
        s_second(p) = c;
    end

% % %     
    theta = theta_i + (theta_f - theta_i) * s(p);
    theta = (theta - round( theta /2 / pi ) *2*pi);
    theta_dot = ((theta_f - theta_i) * s_prime(p) / tf);
    theta_ddot = ((theta_f - theta_i) * s_second(p) / tf^2);
%     
    
    theta1_num(p) = theta(1);
    theta2_num(p) = theta(2);
    theta3_num(p) = theta(3);
    theta4_num(p) = theta(4);
    
    theta1_dot_num(p) = theta_dot(1);
    theta2_dot_num(p) = theta_dot(2);
    theta3_dot_num(p) = theta_dot(3);
    theta4_dot_num(p) = theta_dot(4);
    
    theta1_ddot_num(p) = theta_ddot(1);
    theta2_ddot_num(p) = theta_ddot(2);
    theta3_ddot_num(p) = theta_ddot(3);
    theta4_ddot_num(p) = theta_ddot(4);
    
end
%%

theta1_timeseries = timeseries(theta1_num,T);
theta2_timeseries = timeseries(theta2_num,T);
theta3_timeseries = timeseries(theta3_num,T);
theta4_timeseries = timeseries(theta4_num,T);

%%
close all
markers = {'default','-.','--',':'};
figure()
hold on
plot(0 : Ts_M : tf , s ,'LineStyle',markers{1},'LineWidth',2)
plot(0 : Ts_M : tf , s_prime/max(s_prime) ,'LineStyle',markers{3},'LineWidth',2)
plot(0 : Ts_M : tf , s_second/max(s_second) ,'LineStyle',markers{4},'LineWidth',2)
axis( [0 1 -1.5 2])
xlabel( '$t_n$(s)','interpreter','latex')
legend('$s$','$s''/s''_{max}$','$s''''/s''''_{max}$','Interpreter','latex')
