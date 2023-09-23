clc
close all
TAUT = TAU';
figure()
%%
% torque
for i=1:4
    subplot(2,2,i);
    plot(torque.time , torque.Data(:,i),'LineStyle',markers{4},'LineWidth',2)
    xlabel('t (s)')
    ylabel('\tau (n.m)')
    hold on
    plot(0:Ts_M:tf , TAUT(:,i),'LineStyle',markers{1},'LineWidth',1)

    leg1 = "tau"+ num2str(i) + "_{sim}";
    leg2 = "tau_"+ num2str(i);
    legend(leg1 ,leg2)
    print('dynamic_model_validation','-depsc')
    titles = "torque "+ num2str(i);
    title(titles)
    xlabel('t')
    ylabel('\tau (N.m)')
end
sgtitle('joints torque using simscape and dynamic model')