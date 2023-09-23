function res=Qx(t)
    if class(t)=="sym"
        res=[[1,0,0;0,cos(t),-sin(t);0,sin(t),cos(t)],[0;0;0];[0,0,0,1]];
    else
        res=[rotx(t*180/pi),[0;0;0];[0,0,0,1]];
    end
end