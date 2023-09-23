function res=Qy(t)
    if class(t)=="sym"
        res=[[cos(t),0,sin(t);0,1,0;-sin(t),0,cos(t)],[0;0;0];[0,0,0,1]];
    else
        res=[roty(t*180/pi),[0;0;0];[0,0,0,1]];
    end
end