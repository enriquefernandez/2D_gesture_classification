function hmm = fitHMM(trainData,numStates,transitionMatrixType)

% Check that the right type of HMM is specified (either LR or LRB or ergodic)
if strcmp(transitionMatrixType,'LR')~=1&&strcmp(transitionMatrixType,'LRB')~=1&&strcmp(transitionMatrixType,'ergodic')~=1
    error('Need to specify LR or LRB in the transitionMatrixType argument to choose between Left-Right and Left-Right-Banded models');
end


NUM_STATES = numStates;
NUM_SYMBOLS = 16;

% motionsL = motions;
% for i=1:length(motionsL)
% motionsL{i} =motionsL{i}'+1;
% end

% We assume that we always start in the first state with prob 1.
hmm.prior = zeros(1,NUM_STATES);
hmm.prior(1) = 1;



% Build transition matrix depending on whether we are doing Left-Right or
% Left-Right-Banded HMM

if strcmp(transitionMatrixType,'LR')
    %Left-Right model. Only allow transitions from a state to all the
    %following ones.
    hmm.transmat = rand(NUM_STATES, NUM_STATES);
    for i=1:NUM_STATES
        for j=1:NUM_STATES
            if i>j
                hmm.transmat(i,j)=0;
            end
        end
    end
    
elseif strcmp(transitionMatrixType,'LRB')
    hmm.transmat = zeros(NUM_STATES, NUM_STATES);
    % Left-Right banded model. Only allow transitions from a state to the
    % inmediate following one.
    for i=1:NUM_STATES-1
        hmm.transmat(i,i) = rand;
        hmm.transmat(i,i+1) = rand;
    end
    hmm.transmat(NUM_STATES,NUM_STATES) = 1;

elseif strcmp(transitionMatrixType,'ergodic')
    % Any transition is possible
    hmm.transmat = rand(NUM_STATES, NUM_STATES);
else
   error('wrong HMM type'); 
end




% Ensure rows add to one.
hmm.transmat = mk_stochastic(hmm.transmat);

% Initialize observation matrix.
hmm.obsmat = rand(NUM_STATES,NUM_SYMBOLS);
hmm.obsmat = mk_stochastic(hmm.obsmat);


% fprintf('Fitting HMM with %d states.\n',NUM_STATES);
[LL_L,hmm.prior,hmm.transmat, hmm.obsmat] = dhmm_em(trainData,hmm.prior,hmm.transmat,hmm.obsmat,'verbose',0);
% LL_L



for i=1:length(trainData)
loglikeTrain = dhmm_logprob(trainData{i},hmm.prior,hmm.transmat,hmm.obsmat);
% fprintf('Observation %d has logprob %.3f.\n',i,loglikeTrain);
end

