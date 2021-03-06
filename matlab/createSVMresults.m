% Create table results using the predicted data from LibSVM
% predicted data is in gesturesAllSVMresults
% test_labels generated by SVMmultiClassAll


fixedLength = 35; %number of features
maxSymbol = 16;

HMMmodelNames = {'L','O','V','Z','M','G','T','And','GT'};%,'W','C'};
untrainedHMMmodelNames = {'W','Cinv'};%,'W','C'};
% gesturesData = {newL,newO,newV,newZ,newM};
gesturesData = combinedGestures(1:9);
%  Comment as this variable has been created by addGesturesExamples.m


nexamples = 120;
ntraining = 60;

n_gestures = length(HMMmodelNames);
ntesting = nexamples - ntraining;

% Untrained gesture
untrainedGestureData = combinedGestures(10:11); %W and inverse C
% untrainedGestureData = {};

n_untrained = length(untrainedGestureData);

% Random training
avg_sequence_length = 20; 
nrandomtraining = ntraining*n_gestures;
nrandomtesting = ntesting;

nrandom = nrandomtraining+nrandomtesting;


total_correct = 0;
ntests = 0;
correct_within_trained = 0;

gestureResults = cell(n_gestures,1);

for k=1:n_gestures
    t_idx = test_labels==k;
%     pdif = test_labels(t_idx)-gesturesAllSVMresults(t_idx);
    gestureResults{k}.errors = sum(test_labels(t_idx)~=gesturesAllSVMresults(t_idx));
    gestureResults{k}.tests = sum(t_idx);
    gestureResults{k}.correct = gestureResults{k}.tests - gestureResults{k}.errors;
    gestureResults{k}.rate = gestureResults{k}.correct/gestureResults{k}.tests;
    correct_within_trained = correct_within_trained + gestureResults{k}.correct;
    ntests = ntests + gestureResults{k}.tests;
end
total_correct = total_correct + correct_within_trained;

%Unrecognized class
unrec_class = n_gestures+1;

% Results in random seq
idxRandomTests = n_gestures*ntesting+1:n_gestures*ntesting+nrandomtesting;
randomResults.errors = sum(gesturesAllSVMresults(idxRandomTests)~=unrec_class);
randomResults.tests = length(idxRandomTests);
randomResults.correct = randomResults.tests - randomResults.errors;
randomResults.rate = randomResults.correct / randomResults.tests;
total_correct = total_correct + randomResults.correct;
ntests = ntests + randomResults.tests;


% Results in untrained seqs
untrainedResults = cell(n_untrained,1);
for k=1:n_untrained
    untrainedIndex = n_gestures*ntesting+nrandomtesting+(k-1)*ntesting+1:n_gestures*ntesting+nrandomtesting+(k)*ntesting;
    untrainedResults{k}.errors = sum(gesturesAllSVMresults(untrainedIndex)~=unrec_class);
    untrainedResults{k}.tests = length(untrainedIndex);
    untrainedResults{k}.correct = untrainedResults{k}.tests - untrainedResults{k}.errors;
    untrainedResults{k}.rate = untrainedResults{k}.correct/untrainedResults{k}.tests;    
    total_correct = total_correct + untrainedResults{k}.correct;
    ntests = ntests + untrainedResults{k}.tests;
end



% Create table
fprintf('SVM results\n');
fprintf('Accuracy total %d/%d (%.3g)\n',total_correct,ntests,100*total_correct/ntests);
fprintf('Accuracy within trained %d/%d (%.3g)\n',correct_within_trained,ntesting*n_gestures,100*correct_within_trained/(ntesting*n_gestures));
fprintf('Gesture name\tTests\tCorrect\tMissed\tPct\n');

fprintf('Trained:\n');
for k=1:n_gestures
    fprintf('%10s %5d %5d %5d %6.2f\n',HMMmodelNames{k},gestureResults{k}.tests,gestureResults{k}.correct, gestureResults{k}.errors,gestureResults{k}.rate*100);
end
fprintf('Random sequences:\n');
fprintf('%10s %5d %5d %5d %6.2f\n','Random seq',randomResults.tests,randomResults.correct, randomResults.errors,randomResults.rate*100);

fprintf('Untrained gestures:\n');
for k=1:n_untrained
    fprintf('%10s %5d %5d %5d %6.2f\n',untrainedHMMmodelNames{k},untrainedResults{k}.tests,untrainedResults{k}.correct, untrainedResults{k}.errors,untrainedResults{k}.rate*100);
end

