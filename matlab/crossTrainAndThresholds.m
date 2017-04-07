% determine thresholds
% training indexes generated in trainAndTestGestures.m

% ergodic
HMMmodelNames = {'L','O','V','Z','M'};

% model L
[gs, sci,thres] = crossValidationHMMTrain(dataL.discretizedSequence(trainingIndexes),[3:12]',5,'ergodic')
% results
% -12.2649   12.0000, thresh: -16.2793

%model O
[gs, sci,thres] = crossValidationHMMTrain(dataO.discretizedSequence(trainingIndexes),[3:12]',5,'ergodic')
% -44.2843   12.0000 thr: -52.2395

%model V
[gs, sci,thres] = crossValidationHMMTrain(dataV.discretizedSequence(trainingIndexes),[3:12]',5,'ergodic')
% -16.5433   11.0000 thr: -20.8451


%model Z
[gs, sci,thres] = crossValidationHMMTrain(dataZ.discretizedSequence(trainingIndexes),[3:12]',5,'ergodic')
%-22.8121   12.0000 thr:-29.5146

%model M
[gs, sci,thres] = crossValidationHMMTrain(dataM.discretizedSequence(trainingIndexes),[3:12]',5,'ergodic')
%-40.7474   11.0000 thr:-50.9367


%LR

% model L
[gs, sci,thres] = crossValidationHMMTrain(dataL.discretizedSequence(trainingIndexes),[3:12]',5,'LR')
% results
% -12.1783   11.0000 thr:-20.9595

%model O
[gs, sci,thres] = crossValidationHMMTrain(dataO.discretizedSequence(trainingIndexes),[3:12]',5,'LR')
% -53.9956   10.0000 thr: -61.6869


%model V
[gs, sci,thres] = crossValidationHMMTrain(dataV.discretizedSequence(trainingIndexes),[3:12]',5,'LR')
% -17.9954   11.0000 thr:-23.8138

%model Z
[gs, sci,thres] = crossValidationHMMTrain(dataZ.discretizedSequence(trainingIndexes),[3:12]',5,'LR')
%-25.7478   10.0000 thr:-38.5832

%model M
[gs, sci,thres] = crossValidationHMMTrain(dataM.discretizedSequence(trainingIndexes),[3:12]',5,'LR')
%-48.9822   10.0000 thr:-71.1843



%LRB

% model L
[gs, sci,thres] = crossValidationHMMTrain(dataL.discretizedSequence(trainingIndexes),[3:12]',5,'LRB')
% results
% -12.5245   11.0000 thr:-20.0216

%model O
[gs, sci,thres] = crossValidationHMMTrain(dataO.discretizedSequence(trainingIndexes),[3:12]',5,'LRB')
% -38.5275   11.0000 thres: -48.2369


%model V
[gs, sci,thres] = crossValidationHMMTrain(dataV.discretizedSequence(trainingIndexes),[3:12]',5,'LRB')
% -16.9703    7.0000 thr:-20.8359


%model Z
[gs, sci,thres] = crossValidationHMMTrain(dataZ.discretizedSequence(trainingIndexes),[3:12]',5,'LRB')
%-23.1096    6.0000 thr:-31.5962

%model M
[gs, sci,thres] = crossValidationHMMTrain(dataM.discretizedSequence(trainingIndexes),[3:12]',5,'LRB')
%-37.1593   12.0000 thr:-44.4255


