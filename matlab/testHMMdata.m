function testHMMdata(hmm, testData)

for i=1:length(testData)
loglikeTrain = dhmm_logprob(testData{i},hmm.prior,hmm.transmat,hmm.obsmat);
fprintf('Observation %d has logprob %.3f.\n',i,loglikeTrain);
end

end
