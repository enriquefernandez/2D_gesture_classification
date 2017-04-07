% Use LibSVM to differentiate between gestures
% multi-class SVM
%
% Use cross-validation (easy.py libsvm) to choose the parameters


%% Configuration

fieldname = 'matrixPaddedW0discretized'; % 97.33 training, 98 testing
% fieldname = 'matrixPaddedWRSdiscretized'; % 87 training, 93.33 testing
% fieldname = 'matrixPaddedW0inc'; %98, 98
% fieldname = 'matrixPaddedW0acc'; %97.33, 97.33

fixedLength = 35; %number of features
maxSymbol = 16;

HMMmodelNames = {'L','O','V','Z','M','G','T','And','GT','W','C'};
% gesturesData = {newL,newO,newV,newZ,newM};
% gesturesData = combinedGestures(1:9);
gesturesData = combinedGestures(1:11);
%  Comment as this variable has been created by addGesturesExamples.m


nexamples = 120;
ntraining = 60;


% Untrained gesture
% untrainedGestureData = combinedGestures(10:11); %W and inverse C
untrainedGestureData = {};

n_untrained = length(untrainedGestureData);


% Autogen from configuration
n_gestures = length(gesturesData);
ntesting = nexamples - ntraining;

% Random training
avg_sequence_length = 20; 
nrandomtraining = ntraining*n_gestures;
nrandomtesting = ntesting;

nrandomtraining = 0;
nrandomtesting = 0;

nrandom = nrandomtraining+nrandomtesting;


ntotaltraining = ntraining*n_gestures+nrandomtraining + ntraining*n_untrained ;
ntotaltesting = ntesting*n_gestures+nrandomtesting + ntesting*n_untrained;

%% Split train and test data


%Generate a random sequence of 40 numbers (comment out if these exists and
%need to repeat analysis).

% randomIndexes2 = randsample(nexamples,nexamples);
% trainingIndexes = randomIndexes2(1:ntraining);
% testingIndexes = randomIndexes2(ntraining+1:nexamples);


%% Generate random data

max_symbol = 16; %max value of observation


% random_matrix = zeros(nrandom,fixedLength);
% for i=1:nrandom
%     random_sequence_length = floor(20+3*randn);
%     
%     random_matrix(i,1:random_sequence_length) = randsample([1:max_symbol],random_sequence_length,true);
% end



%% Generate train and test matrices and labels

trainMatrix = zeros(ntotaltraining,fixedLength);
testMatrix = zeros(ntotaltesting,fixedLength);

trainLabels = zeros(ntotaltraining,1);
testLabels = zeros(ntotaltesting,1);

for k=1:n_gestures
    matrix = gesturesData{k}.(fieldname);
    trainMatrix((k-1)*ntraining+1:(k)*ntraining,:) = matrix(trainingIndexes,:);
    testMatrix((k-1)*ntesting+1:(k)*ntesting,:) = matrix(testingIndexes,:);
    
    trainLabels((k-1)*ntraining+1:(k)*ntraining) = k;
    testLabels((k-1)*ntraining+1:(k)*ntraining) = k;
end

%Add random data
% trainMatrix(n_gestures*ntraining+1:n_gestures*ntraining+nrandomtraining,:) = random_matrix(1:nrandomtraining,:);
% testMatrix(n_gestures*ntesting+1:n_gestures*ntesting+nrandomtesting,:) = random_matrix(1+nrandomtraining:nrandomtraining+nrandomtesting,:);
% 
% trainLabels(n_gestures*ntraining+1:n_gestures*ntraining+nrandomtraining) = n_gestures+1; %new class
% testLabels(n_gestures*ntesting+1:n_gestures*ntesting+nrandomtesting) = n_gestures+1;


% Add untrained gestures
for k=1:n_untrained
    matrix = untrainedGestureData{k}.(fieldname);
    trainMatrix(n_gestures*ntraining+nrandomtraining+(k-1)*ntraining+1:n_gestures*ntraining+nrandomtraining+(k)*ntraining,:) = matrix(trainingIndexes,:);
    testMatrix(n_gestures*ntesting+nrandomtesting+(k-1)*ntesting+1:n_gestures*ntesting+nrandomtesting+(k)*ntesting,:) = matrix(testingIndexes,:);
    
    trainLabels(n_gestures*ntraining+nrandomtraining+(k-1)*ntraining+1:n_gestures*ntraining+nrandomtraining+(k)*ntraining) = n_gestures+1;
    testLabels(n_gestures*ntesting+nrandomtesting+(k-1)*ntesting+1:n_gestures*ntesting+nrandomtesting+(k)*ntesting) = n_gestures+1;
end
% matrix = untrainedGestureData{1}.(fieldname);
% trainMatrix(n_gestures*ntraining+nrandomtraining+1:n_gestures*ntraining+nrandomtraining+ntraining,:) = matrix(trainingIndexes,:);
% testMatrix(n_gestures*ntesting+nrandomtesting+1:n_gestures*ntesting+nrandomtesting+ntesting,:) = matrix(testingIndexes,:);
% 
% trainLabels(n_gestures*ntraining+nrandomtraining+1:n_gestures*ntraining+nrandomtraining+ntraining) = n_gestures+1; %new class
% testLabels(n_gestures*ntesting+nrandomtesting+1:n_gestures*ntesting+nrandomtesting+ntesting) = n_gestures+1;



% Write to LibSVM format to be able to use easy.py
libsvmwrite('gesturesAllTrain',trainLabels,sparse(trainMatrix))
libsvmwrite('gesturesAllTest',testLabels,sparse(testMatrix))

    
    

