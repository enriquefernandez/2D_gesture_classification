%% Train HMM using cross validation to select the number of states
% Returns the trained hmm model
% trainData is the discrete sequence of observations used to train the
% model. It should be a cell and each member inside an array of variable
% length.
%
% numberOfStatesCandidates are the options that we want to test
% example [2:10] to test between 2, 3, 4,...10 states.
% kfolds is the number of k-folds in which the data is divided.
% For example, if kfolds is 10, the training data is divided in 10 random
% parts and the model is training 10 different times with 9 parts and
% tested with the remaining part to get an score. This score is averaged
% over the 10 different ways in which the model has been trained. We do
% this for every candidate and then select the preferred one.
% For the chosen one we train using the whole data.


function [results, kfold_scores, thresholds] = crossValidationHMMTrain(trainData, nstateCandidates, nkfolds, transitionMatrixType)

% Check that the right type of HMM is specified (either LR or LRB)
if strcmp(transitionMatrixType,'LR')~=1&&strcmp(transitionMatrixType,'LRB')~=1&&strcmp(transitionMatrixType,'ergodic')~=1
    error('Need to specify LR or LRB in the transitionMatrixType argument to choose between Left-Right and Left-Right-Banded models');
end


% Divide the data in the k-folds

l = length(trainData)

% Get random vector of indices from 1:l
randomIndexes = randsample(l,l);
itemsPerKfold = floor(l/nkfolds);
% Assign folds
for k=1:nkfolds
    if k<nkfolds
        kfold{k} = randomIndexes(1+(k-1)*itemsPerKfold:(k)*itemsPerKfold);
    else
        kfold{k} = randomIndexes(1+(k-1)*itemsPerKfold:end);
    end
end


% Iterate over the candidate models
n = length(nstateCandidates) %num of candidates

candidate_scores = zeros([n,1]);

% kfold scores
kfold_scores = cell(n,nkfolds);

for i=1:n
    % Select num of states
    num_states = nstateCandidates(i);
    
    fprintf('Cross validation for %d states.\n',num_states);
    
    % Calculate scores for this candidate
    
    candidateSumScore = 0;
    total_tests_candidate = 0;
    % iterate over kfold configurations
    for k=1:nkfolds
        
        foldSumScore = 0;
        
        [trainIndex, testIndex] = getKFoldIndex(k,kfold);
        trainK = trainData(trainIndex);
        testK = trainData(testIndex);
        
        % Train the model for this configuration-fold
        hmmFold = fitHMM(trainK,num_states, transitionMatrixType);
        
        % Calculate score for each entry in the test data
        num_tests = length(testK);
        tests_considered_fold = 0;
        for t=1:num_tests
            likeli = dhmm_logprob(testK{t},hmmFold.prior,hmmFold.transmat,hmmFold.obsmat);
            if isinf(likeli)==0
                foldSumScore = foldSumScore + likeli;
                tests_considered_fold = tests_considered_fold + 1;
            else
                fprintf('Test removed because of -Inf log prob. Num states %d, k fold config %d, test index %d\n',num_states,k,testIndex(t));
            end                
                
        end
        
        kfold_scores{i,k} = foldSumScore/tests_considered_fold;
        total_tests_candidate = total_tests_candidate + tests_considered_fold;
        
%         candidateSumScore = candidateSumScore + foldSumScore/tests_considered_fold;
        candidateSumScore = candidateSumScore + foldSumScore;

        
    end
    
    % Store results in table
%     candidate_scores(i) = candidateSumScore/nkfolds;
    candidate_scores(i) = candidateSumScore/total_tests_candidate;
    
    
    
    
end

% Sort according to likelihood and show results

[results, sortedIdx] = sortrows([candidate_scores nstateCandidates],-1); %sort according to the likelihood column in descending order.

kfold_scores = cell2mat(kfold_scores);
kfold_scores = kfold_scores(sortedIdx,:);

thresholds = min(kfold_scores')' - std(kfold_scores')';

    
        

end

function [trainIndex, testIndex] = getKFoldIndex(k,kfolds)
        
        trainIndex = [];
        for i=1:length(kfolds)
            if i==k
                continue
            else
                trainIndex = [trainIndex; kfolds{i}];
            end
        end
        
        testIndex = kfolds{k};
        
    end