function mouseCaptureCallback(timerObj,event,str_arg)
% this function is executed every time the timer object triggers

% read the coordinates
coords = get(0,'PointerLocation');
C = get (gca, 'CurrentPoint');
title(gca, ['(X,Y) = (', num2str(C(1,1)), ', ',num2str(C(1,2)), ')']);

% print the coordinates to screen
fprintf('x: %4i y: %4i\n',coords)

end % function