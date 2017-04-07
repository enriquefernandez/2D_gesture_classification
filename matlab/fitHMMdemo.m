NUM_STATES = 4;
NUM_SYMBOLS = 16;

% motionsL = motions;
% for i=1:length(motionsL)
% motionsL{i} =motionsL{i}'+1;
% end

hmmL.prior = zeros(1,NUM_STATES);
hmmL.prior(1) = 1;
hmmL.transmat = rand(NUM_STATES, NUM_STATES);
for i=1:NUM_STATES
for j=1:NUM_STATES
if i>j
hmmL.transmat(i,j)=0;
end
end
end

hmmL.transmat = mk_stochastic(hmmL.transmat);

hmmL.obsmat = rand(NUM_STATES,NUM_SYMBOLS);
hmmL.obsmat = mk_stochastic(hmmL.obsmat);


fprintf('Fitting HMM with %d states.\n',NUM_STATES);
[LL_L,hmmL.prior,hmmL.transmat, hmmL.obsmat] = dhmm_em(motionsTrain,hmmL.prior,hmmL.transmat,hmmL.obsmat);
% LL_L



for i=1:length(motionsTrain)
loglikeTrain = dhmm_logprob(motionsTrain{i},hmmL.prior,hmmL.transmat,hmmL.obsmat);
fprintf('Observation %d has logprob %.3f.\n',i,loglikeTrain);
end
