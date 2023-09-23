clc
close all
TAUT = TAU';
figure()
%%
% torque
for i=1:4
    subplot(2,2,i);
    plot(out.forcetorque.time , out.forcetorque.Data(:,i),'LineStyle',markers{4},'LineWidth',2)
    hold on
    plot(0:Ts_M:tf , TAUT(:,i),'LineStyle',markers{1},'LineWidth',1)

    if ((i==2) || (i==3))
        leg1 = "tau"+ num2str(i) + "_{sim}";
        leg2 = "tau_"+ num2str(i);
        legend(leg1 ,leg2)
        print('dynamic_model_validation','-depsc')
        titles = "torque "+ num2str(i);
        title(titles)
        xlabel('t')
        ylabel('\tau (N.m)')
    else
        leg1 = "f"+ num2str(i) + "_{sim}";
        leg2 = "f_"+ num2str(i);
        legend(leg1 ,leg2)
        print('dynamic_model_validation','-depsc')
        titles = "force "+ num2str(i);
        title(titles)
        xlabel('t')
        ylabel('f (N)')
    end
end
sgtitle('joints torque and force using simscape and dynamic model')