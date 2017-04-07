
% TO Generate data
% global motions
% captureGUI
% click the right button and drag the mouse to create motions
% when closing the figure window the variable motions in the workspace will
% have all the motions done.
% To train models do
%    myHMM = fitHMM(motions, numStates)
% To test data do
%  testHMMdata(hmm, motions)


% Need to add the HMM library to the path
% addpath(genpath('/Users/efernan/Downloads/HMMall'))

HMMmodels = {lHMM,cHMM,rHMM,vHMM,zHMM};
HMMmodelNames = {'L','circle','right','V','Z'};
%                 1,  2 ,      3 ,    4 , 5

expectedResults = [ 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 2, 1, 2, 3, 5, 3, 4, 2, 4, 1, 1];


[modelSelected, maxLike, likeMatrix] = detectGesture(testData,HMMmodels, HMMmodelNames);
% 
% results
% expectedResults
[modelSelected expectedResults']

likeMatrix