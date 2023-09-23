clc
close all
figure()
%%
% torque
for i=1:4
    subplot(2,2,i);
    plot(out.thetaandb1.time , out.thetaandb1.Data(:,i),'LineWidth',2)
    hold on
    plot(out.thetaandb2.time , out.thetaandb2.Data(:,i),'LineWidth',1)

    if ((i==2) || (i==3))
        leg1 = "theta"+ num2str(i) + "_{Scara1}";
        leg2 = "theta"+ num2str(i) + "_{Scara2}";
        legend(leg1 ,leg2)
        print('dynamic_model_validation','-depsc')
        titles = "Theta "+ num2str(i);
        title(titles)
        xlabel('t')
        ylabel('\theta (rad)')
    else
        leg1 = "b"+ num2str(i) + "_{Scara1}";
        leg2 = "b"+ num2str(i) + "_{Scara2}";
        legend(leg1 ,leg2)
        print('dynamic_model_validation','-depsc')
        titles = "length "+ num2str(i);
        title(titles)
        xlabel('t')
        ylabel('l (m)')
    end
    xlim([0,49])
end
sgtitle('joints theta and b using simscape')