% Overall script
% Designed to be modular: can comment out some parts and run the rest.
% Can select whether to use ergodic, left-right or left-right banded HMM
% models


%% Configuration

useThresholds = 0;

num_statesErgodic = {12,12,11,12,11};
thresholdErgodic = [-16.2793,-52.2395,-20.8451,-29.5146,-50.9367];

num_statesLR = {11,10,11,10,10};
thresholdLR = [-20.9595,-61.6869,-23.8138,-38.5832,-71.1843];

num_statesLRB = {11,11,7,6,12};
thresholdLRB = [-20.0216,-48.2369,-20.8359,-31.5962,-44.4255];
thresholdLRB = [-20.0216,-48.2369,-20.8359,-50.5962,-70.4255];


HMMtype = 'ergodic';
num_states = num_statesErgodic;
thresholds = thresholdErgodic;
% 
HMMtype = 'LR';
num_states = num_statesLR;
thresholds = thresholdLR;
% % % 
HMMtype = 'LRB';
num_states = num_statesLRB;
thresholds = thresholdLRB;



HMMmodelNames = {'L','O','V','Z','M'};
% gesturesData = {dataL,dataO,dataV,dataZ,dataM};
%  Comment as this variable has been created by addGesturesExamples.m

%for the new gestures captured with time fixed steps (to use the old one
%create the extended samples with addGesturesExamples.m)
gesturesData = {newL,newO,newV,newZ,newM};
num_states = {5,8,7,8,8};

% num_states = {5,9,6,8,9}; %Order needs to match the above.

% HMMmodels = {lHMM,oHMM,vHMM,zHMM,mHMM};

untrained_gesture_data = {dataW};
untrained_num_tests = 20;

% Out of the 40 examples that we have per gesture, we select 30 for
% training and 10 for testing. We use the same indices for each gesture
nexamples = 60;
ntraining = 30;


% Autogen from configuration
n_gestures = length(HMMmodelNames);
ntesting = nexamples - ntraining;

%% Split train and test data


%Generate a random sequence of 40 numbers (comment out if these exists and
%need to repeat analysis).
% randomIndexes = randsample(nexamples,nexamples);
% trainingIndexes = randomIndexes(1:ntraining);
% testingIndexes = randomIndexes(ntraining+1:nexamples);



%% Generate test data
% Combine test data of each example with random sequences and examples of
% an untrained gesture.
% Maintain a 'correct' list to compare with the trained ones.

% Generate random sequences
num_random_sequences = 30;
avg_sequence_length = 20;
max_symbol = 16; %max value of observation
% random_sequences = cell(num_random_sequences,1);
% for i=1:num_random_sequences
%     random_sequence_length = floor(20+3*randn);
%     random_sequences{i} = randsample([1:max_symbol],random_sequence_length,true);
% end

% Assemble test sequence and labels
ntests = n_gestures*ntesting + num_random_sequences + untrained_num_tests;
test_sequences = cell(1,ntests);
test_labels = zeros(ntests,1);

% attach real gesture examples
for i=1:n_gestures
    test_sequences((i-1)*ntesting+1:i*ntesting) = gesturesData{i}.discretizedSequence(testingIndexes);
    test_labels((i-1)*ntesting+1:i*ntesting) = i; %so that these tests are associated to this gesture
end

% attach untrained symbol data
test_sequences(n_gestures*ntesting+1:n_gestures*ntesting+untrained_num_tests) = untrained_gesture_data{1}.discretizedSequence(1:untrained_num_tests);
test_labels(n_gestures*ntesting+1:n_gestures*ntesting+untrained_num_tests) = -2; %untrained model.

% attach random sequences
test_sequences(n_gestures*ntesting+untrained_num_tests+1:n_gestures*ntesting+untrained_num_tests+num_random_sequences) = random_sequences(:);
test_labels(n_gestures*ntesting+untrained_num_tests+1:n_gestures*ntesting+untrained_num_tests+num_random_sequences) = -1; %random sequences




%% Cross validation to select the best number of states per gesture
% probably better done offline...


%% Train models using the selected number of states and the train data for
% each gesture

gesturesHMMs = cell(n_gestures,1);
        
for k=1:n_gestures
    fprintf('Training %s HMM for model %d %s with %d examples and %d states...\n',HMMtype,k,HMMmodelNames{k},ntraining,num_states{k});
    gesturesHMMs{k} = fitHMM(gesturesData{k}.discretizedSequence(trainingIndexes),num_states{k}, HMMtype);
end
fprintf('All gestures trained....\n');


%% Test the big test sequence. Classify all gestures in the sequence
% Identify between the trained gestures and unrecognized. Create tables
% for the results.


if useThresholds==1
    fprintf('Testing %d sequences with the HMM trained gestures using thresholds.\n', ntests);
    [modelSelected, likelihood, likelihoodMatrix] = detectGesture(test_sequences,gesturesHMMs, HMMmodelNames,thresholds)
else
    fprintf('Testing %d sequences with the HMM trained gestures without thresholds.\n', ntests);
    [modelSelected, likelihood, likelihoodMatrix] = detectGesture(test_sequences,gesturesHMMs, HMMmodelNames)
end

fprintf('Test completed.\n');

[modelSelected test_labels]

% Initialize results structures
gestureResults = cell(n_gestures,1);
for k=1:n_gestures
    gestureResults{k}.positiveTests=0;
    gestureResults{k}.correctlyDetected=0;
    gestureResults{k}.falsePositiveOtherGest=0;
    gestureResults{k}.falsePositiveUntrainedGest=0;
    gestureResults{k}.falsePositiveRndSeq=0;
    gestureResults{k}.falseNegatives=0;
    gestureResults{k}.pct_OK=0;
    gestureResults{k}.falsePositives=0;
end

% Generate results tables

total_correct = 0;
for i=1:ntests
    if test_labels(i)>0
        % Example of trained gesture
        gestureResults{test_labels(i)}.positiveTests = gestureResults{test_labels(i)}.positiveTests+1;
        if test_labels(i)== modelSelected(i)
            % Correct detection
            gestureResults{test_labels(i)}.correctlyDetected = gestureResults{test_labels(i)}.correctlyDetected+1;
        elseif modelSelected(i)>0
            % Incorrectly classified as another gesture
            gestureResults{modelSelected(i)}.falsePositiveOtherGest = gestureResults{modelSelected(i)}.falsePositiveOtherGest + 1;
        else
            % unrecognized
        end
        
    elseif test_labels(i) == -2
        % Test was an example of an unrecognized gesture
        if modelSelected(i)>0
           gestureResults{modelSelected(i)}.falsePositiveUntrainedGest = gestureResults{modelSelected(i)}.falsePositiveUntrainedGest + 1;
        else
            %correctly detected
            total_correct = total_correct + 1;
        end
        
        
    elseif test_labels(i) == -1
        % Test was a random sequence
        if modelSelected(i)>0
            gestureResults{modelSelected(i)}.falsePositiveRndSeq = gestureResults{modelSelected(i)}.falsePositiveRndSeq + 1;
        else
            %correctly detected
            total_correct = total_correct + 1;
        end
    end
    
end

% Compile the other statistics

for k=1:n_gestures
    total_correct = total_correct + gestureResults{k}.correctlyDetected;
    gestureResults{k}.falseNegatives = gestureResults{k}.positiveTests - gestureResults{k}.correctlyDetected;
    gestureResults{k}.pct_OK = gestureResults{k}.correctlyDetected / gestureResults{k}.positiveTests;
    
    gestureResults{k}.falsePositives = gestureResults{k}.falsePositiveOtherGest + gestureResults{k}.falsePositiveUntrainedGest + gestureResults{k}.falsePositiveRndSeq;
end


% Create table
fprintf('Accuracy %d/%d (%.3g)\n',total_correct,ntests,100*total_correct/ntests);
fprintf('Gesture name\tPositiveTests\tDetectedOK\tMissed\tPct\tFalsePositives\tFalseOtherGest\tFalseUntrainedGest\tFalseRndSeq\n');

for k=1:n_gestures
    fprintf('%4s %5d %5d %5d %6.2f %5d %5d %5d %5d\n',HMMmodelNames{k},gestureResults{k}.positiveTests,gestureResults{k}.correctlyDetected, gestureResults{k}.falseNegatives,gestureResults{k}.pct_OK*100,gestureResults{k}.falsePositives,gestureResults{k}.falsePositiveOtherGest,gestureResults{k}.falsePositiveUntrainedGest,gestureResults{k}.falsePositiveRndSeq);
end
             
    




