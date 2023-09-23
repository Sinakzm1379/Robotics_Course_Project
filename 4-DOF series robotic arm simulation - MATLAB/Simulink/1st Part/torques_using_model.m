%%
  
Ts_M = 0.01;
tf = 1;
beta = atan(128/24);
bias = [ 0 ; beta ; -beta; 0 ] ;
theta_i_m = theta_i + bias;
theta_f_m = theta_f + bias;
p = 0;
TAU = zeros(4, round(1 + tf / Ts_M));
for j = 0 : Ts_M : tf
    p = p + 1;
    t_n = j/tf;
    
    if ((t_n >= 0) && (t_n <= t_n_D)) 
        s = (a * t_n^2)/2;
        s_prime = a*t_n;
        s_second = a;
        b = a*t_n;
        d = (a * t_n^2)/2;
    elseif ((t_n > t_n_D) && (t_n <= t_n_U))
        s = d + b * (t_n-t_n_D);
        s_prime = b;
        s_second = 0;
        dd = d + b * (t_n-t_n_D);
    elseif ((t_n > t_n_U) && (t_n <= 1))
        s = dd + b*(t_n-t_n_U)+(c*(t_n-t_n_U)^2)/2;
        s_prime = b + c*(t_n-t_n_U);
        s_second = c;
    end 
    
    theta = theta_i_m + (theta_f_m - theta_i_m) * s;
    theta = theta - round( theta /2 / pi ) *2*pi;

    theta_dot = (theta_f_m - theta_i_m) * s_prime / tf;
    theta_ddot = (theta_f_m - theta_i_m) * s_second / tf^2; 
    
    theta1 = theta(1);
    theta2 = theta(2);
    theta3 = theta(3);
    theta4 = theta(4);

    
    theta1_dot = theta_dot(1);
    theta2_dot = theta_dot(2);
    theta3_dot = theta_dot(3);
    theta4_dot = theta_dot(4);

    theta1_ddot = theta_ddot(1);
    theta2_ddot = theta_ddot(2);
    theta3_ddot = theta_ddot(3);
    theta4_ddot = theta_ddot(4);

    TAU(:,p) = OpenMan_torques(theta1,...
       theta2,theta3,theta4,...
       theta1_dot,theta2_dot,theta3_dot,...
       theta4_dot,theta1_ddot,theta2_ddot,...
       theta3_ddot,theta4_ddot);
    
end
%%
close all
figure
plot(0:Ts_M:tf , TAU','LineStyle',markers{1},'LineWidth',2)
hold on
plot(torque.time , torque.Data,'LineStyle',markers{4},'LineWidth',2)

% ylim([-0.6 1])
legend('tau_1' , 'tau_2','tau_3','tau_4','tau1_{sim}' , 'tau2_{sim}','tau3_{sim}','tau4_{sim}')
print('dynamic_model_validation','-depsc')
title('joints torque using simscape and dynamic model')
xlabel('t')
ylabel('\tau (N.m)')
