function mouseMove (object, eventdata)
global mouseDown;
C = get (gca, 'CurrentPoint');
title(gca, ['(X,Y) = (', num2str(C(1,1)), ', ',num2str(C(1,2)), ')']);
if mouseDown==1
    fprintf('down\n');
end

