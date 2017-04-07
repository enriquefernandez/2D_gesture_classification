function [modelSelected, likelihood, likelihoodMatrix] = detectGesture(testData,HMMmodels, HMMmodelNames,thresholds)

if nargin<4
    useDetectThresholds = 0;
else
    useDetectThresholds = 1;
end

% HMM models

% HMMmodels
modelSelected = zeros(length(testData),1);
likelihood = zeros(length(testData),1);
likelihoodMatrix = zeros(length(testData),length(HMMmodels));

for i=1:length(testData)
    maxlike = -inf;
    selectedModel = 0;
    for k=1:length(HMMmodels)
        hmm = HMMmodels{k};
        loglike = dhmm_logprob(testData{i},hmm.prior,hmm.transmat,hmm.obsmat);
        likelihoodMatrix(i,k) = loglike;
        if loglike>maxlike
            % If we use detect thresholds, not only we need the model with
            % the highest prob, but we also need that prob to be higher
            % than the threshold for the model.
            if useDetectThresholds==0 || loglike>thresholds(k)
                maxlike = loglike;
                selectedModel = k;
            else
                fprintf('higher likelihood but below threshold for test %d, model %d %s\n',i,k,HMMmodelNames{k});
            end
        
        end
    end
    
    modelSelected(i) = selectedModel;
    likelihood(i) = maxlike;
    
    if maxlike>-inf
        fprintf('Data %d, select model %d %s with logprob %.3f.\n',i,selectedModel,HMMmodelNames{selectedModel},maxlike);
    else
        fprintf('Data %d, all models -inf prob');
    end

end



end
