function res=Qz(t)
    if class(t)=="sym"
        res=[[cos(t),-sin(t),0;sin(t),cos(t),0;0,0,1],[0;0;0];[0,0,0,1]];
    else
        res=[rotz(t*180/pi),[0;0;0];[0,0,0,1]];
    end
end