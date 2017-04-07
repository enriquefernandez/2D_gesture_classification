% remember to add LibSVM path
% addpath('../../../Project material/LibSVM/matlab/')

% Generate labels and training examples

fixedLength = 35;
maxSymbol = 16;

% L versus others
trainGestureData = newL.matrixPaddedW0discretized;
otherGestures = {newO.matrixPaddedW0discretized,newV.matrixPaddedW0discretized,newZ.matrixPaddedW0discretized,newM.matrixPaddedW0discretized};

% O versus others
trainGestureData = newO.matrixPaddedW0discretized;
otherGestures = {newL.matrixPaddedW0discretized,newV.matrixPaddedW0discretized,newZ.matrixPaddedW0discretized,newM.matrixPaddedW0discretized};


n_examples = 60;
n_pos_examples = 30;
n_otherGest_examples = 5;
n_random = 10;

n_otherGest = length(otherGestures);
n = n_pos_examples + n_otherGest*n_otherGest_examples + n_random;

% Generate random indexes
randomIndexesPos = randsample(n_examples,n_examples);
randomIndexesNeg = randsample(n_examples,n_examples);
positive_indexes = randomIndexesPos(1:n_pos_examples);
negative_indexes = randomIndexesNeg(1:n_otherGest_examples);


% Test matrix
indexPosTest = randomIndexesPos(n_pos_examples+1:end);
otherGestIndexTest = randomIndexesNeg(n_otherGest_examples+1:2*n_otherGest_examples);

n_test_positive = n_examples-n_pos_examples;
n_test = n_test_positive + n_otherGest*n_otherGest_examples+n_random;


% Generate data
trainMatrix = zeros(n,fixedLength);
labels = zeros(n,1);

testMatrix = zeros(n,fixedLength);
test_labels = zeros(n,1);


trainMatrix(1:n_pos_examples,:) = trainGestureData(positive_indexes,:);
labels(1:n_pos_examples,:) = 1;

testMatrix(1:n_pos_examples,:) = trainGestureData(indexPosTest,:);
test_labels(1:n_pos_examples,:) = 1;

% for i=1:n_pos_examples
%     trainMatrix(i,:) = trainGestureData{randomIndexesPos(i)};
%     labels(i) = 1;
% end



for k=1:n_otherGest
%     for i=1:n_otherGest_examples    
%         trainMatrix(n_pos_examples+(k-1)*n_otherGest_examples+i,:) = otherGestures{1,k}{randomIndexesNeg(i)};
% %         labels(n_pos_examples+(k-1)*n_otherGest_examples+i) = 0
%     end
    otherM = otherGestures{k};
    trainMatrix(n_pos_examples+(k-1)*n_otherGest_examples+1:n_pos_examples+(k)*n_otherGest_examples,:)= otherM(negative_indexes,:);
    
    %test
    testMatrix(n_pos_examples+(k-1)*n_otherGest_examples+1:n_pos_examples+(k)*n_otherGest_examples,:)= otherM(otherGestIndexTest,:);
    
    
end

for i=n_pos_examples + n_otherGest*n_otherGest_examples+1:n
    trainMatrix(i,:) = randsample([1:max_symbol],35,true);
    testMatrix(i,:) = randsample([1:max_symbol],35,true);
end


% SVM test
model = svmtrain(labels,trainMatrix)
[predict_label, accuracy, dec_values] = svmpredict(labels,trainMatrix,model);
fprintf('Accuracy for training data: %.3f\n',accuracy(1));
[predict_label, accuracy, dec_values] = svmpredict(test_labels,testMatrix,model);
fprintf('Accuracy for test data: %.3f\n',accuracy(1));





