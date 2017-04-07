% This version captures data points at fixed time steps (configurable)

function motions2 = captureGUI(HMMmodels, HMMmodelNames)

samplingRate = 30; %Hz, samples per second

motions2=0
figure;
xlim([0,1]);
ylim([0,1]);
hold on;
mouseDown = 0;
set (gcf, 'WindowButtonMotionFcn', @mouseMoveCallback);
% set (gcf, 'WindowButtonDownFcn', @mouseDownCallback);
% set (gcf, 'WindowButtonUpFcn', @mouseUpCallback);
set (gcf, 'KeyPressFcn', @keyDown);
set (gcf, 'KeyReleaseFcn', @keyUp);

timerObj = timer('TimerFcn',@timerCallback,'Period',1/samplingRate,'ExecutionMode','fixedRate');
% start(timerObj);


if nargin<2
    detectGest = 0
else
    detectGest = 1
end



mouseCapture = [];

timeCapture = [];

% bin properties
nbins = 16;
bins = 360/nbins;
hbins = bins/2;


% Motions
% global motions;
% motions = cell(1,1);
% i = 1;

% Recorded motions to pass to MATLAB
% remember to declare this variable in MATLAB's workspace first as othewise
% we won't receive it.
global recordedMotions;
recordedMotions = struct;

recordedMotions.xyt = cell(1,1);
recordedMotions.discretizedSequence = cell(1,1);
i=1;

    function timerCallback(timerObj,event,str_arg)
%         C = get (gca, 'CurrentPoint');
%         title(gca, ['(X,Y) = (', num2str(C(1,1)), ', ',num2str(C(1,2)), ')']);
        if isempty(timeCapture)
            tic;
            recordedTime = 0;
        else
            recordedTime = toc;
        end
        C = get (gca, 'CurrentPoint');
        point = C(1,1:2);
        mouseCapture = [mouseCapture;point];
        timeCapture = [timeCapture; recordedTime];
%         tic;
        plot(point(1),point(2),'dr');
       
        
    end

    function mouseDownCallback(object, eventdata)
       mouseDown=1;
        cla;
       mouseCapture = [];
       timeCapture = [];
       title(gca,'new input gesture');
       
       

%        fprintf('mouse pressed\n');
        
    end

    function mouseUpCallback(object, eventdata)
        mouseDown=0;
        
        %end timer here
        stop(timerObj);
        
%         fprintf('mouse up\n');
       
%         disp('capture sequence:')
%         disp(mouseCapture)
        
        if ~isempty(mouseCapture)
%             disp('angle seq');
%             disp(computeSequenceAngles(mouseCapture));
            quantSeq = getQuantSeq(mouseCapture);
%             motions{i} = quantSeq;
            recordedMotions.discretizedSequence{i} = quantSeq;
            recordedMotions.xyt{i} = [mouseCapture, timeCapture];
            recordedMotions.incSequence{i} = getIncrementalSequence(quantSeq);
            recordedMotions.accSequence{i} = getAccumulatedSequence(recordedMotions.incSequence{i});
            
            disp(i);
            i = i+1;
%             disp(quantSeq);
            
        end
        
        if detectGest
            %detect gesture
            myData{1} = quantSeq;
            [modelSelected, likelihood, likelihoodMatrix] = detectGesture(myData,HMMmodels, HMMmodelNames);
            if modelSelected>0
                title(gca, sprintf('Gesture %d, %s, log likeli:%.3f',modelSelected(1),HMMmodelNames{modelSelected(1)},likelihood(1)));
            else
                title(gca, 'No gesture recognized.');
            end

            
        end
        
        
        
    end

    function mouseMoveCallback(object, eventdata)
        if mouseDown
            
%             if isempty(timeCapture)
%                 tic;
%                 recordedTime = 0;
%             else
%                 recordedTime = toc;
%             end
%             
%             C = get (gca, 'CurrentPoint');
%             point = C(1,1:2);
%             mouseCapture = [mouseCapture;point];
%             timeCapture = [timeCapture; recordedTime];
%             plot(point(1),point(2),'dr');
            
            if isempty(timeCapture)
                %First point
%                 C = get (gca, 'CurrentPoint');
%                 point = C(1,1:2);
%                 mouseCapture = [mouseCapture;point];
%                 timeCapture = [timeCapture; 0];
%                 % start timer
%                 tic;
                start(timerObj);
                
                 
            end


        end   
            
    end

    function keyDown(object, eventdata)
%         disp('down');
        mouseDown=1;
        cla;
       mouseCapture = [];
       timeCapture = [];
       title(gca,'new input gesture');
    end

    function keyUp(object, eventdata)
%         disp('up');
  mouseDown=0;
        
        %end timer here
        stop(timerObj);
        
%         fprintf('mouse up\n');
       
%         disp('capture sequence:')
%         disp(mouseCapture)
        
        if ~isempty(mouseCapture)
%             disp('angle seq');
%             disp(computeSequenceAngles(mouseCapture));
            quantSeq = getQuantSeq(mouseCapture);
%             motions{i} = quantSeq;
            recordedMotions.discretizedSequence{i} = quantSeq;
            recordedMotions.xyt{i} = [mouseCapture, timeCapture];
            recordedMotions.incSequence{i} = getIncrementalSequence(quantSeq);
            recordedMotions.accSequence{i} = getAccumulatedSequence(recordedMotions.incSequence{i});
            
            disp(i);
            i = i+1;
%             disp(quantSeq);
            
        end
        
        if detectGest
            %detect gesture
            myData{1} = quantSeq;
            [modelSelected, likelihood, likelihoodMatrix] = detectGesture(myData,HMMmodels, HMMmodelNames);
            if modelSelected>0
                title(gca, sprintf('Gesture %d, %s, log likeli:%.3f',modelSelected(1),HMMmodelNames{modelSelected(1)},likelihood(1)));
            else
                title(gca, 'No gesture recognized.');
            end

            
        end
        
        
    end


    function angleSeq = computeSequenceAngles(captureSequence)
        difference = diff(mouseCapture);
        angleSeq = atan2d(difference(:,2),difference(:,1));
        angleSeq(angleSeq<0) = angleSeq(angleSeq<0)+360;
%         angleSeq = rad2deg(atan(difference(:,2)./difference(:,1)))
        
    end

    function quantizeSeq = quantizeSeq(angleSeq)
        procAngleSeq = angleSeq + hbins;
        procAngleSeq(procAngleSeq>360) = procAngleSeq(procAngleSeq>360)-360;
        quantizeSeq = floor(procAngleSeq/bins);
        
        % Bins start at 1 instead of 0 and vectors are rows instead of
        % columns
        quantizeSeq = quantizeSeq' + 1;
    end

    function seq = getQuantSeq(captureSequence)
        seq = quantizeSeq(computeSequenceAngles(captureSequence));
        
    end

    function incSeq = getIncrementalSequence(angleSequence)
        incSeq = diff(angleSequence);
        incSeq(incSeq<-8) = incSeq(incSeq<-8)+16;
        incSeq(incSeq>8) = incSeq(incSeq>8)-16;
        % Include initial direction
        incSeq = [angleSequence(1) incSeq];
    end

    function accSeq = getAccumulatedSequence(incSeq)
        accSeq = cumsum(incSeq);
    end










end