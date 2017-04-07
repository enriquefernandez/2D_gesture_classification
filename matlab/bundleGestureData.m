function gestureData = bundleGestureData(recordedData)

fixedLength = 35;
max_symbol = 16;
N = length(recordedData.discretizedSequence);

minL=500;
maxL = 0;
L = 0;

for i=1:N
    l = length(recordedData.discretizedSequence{i});
    L = L + l;
    if l>maxL
        maxL = l;
    end
    if l<minL
        minL = l;
    end
    
    if l<fixedLength
        % Create padded sequences
        recordedData.paddedW0discretizedSequence{i} = [recordedData.discretizedSequence{i} zeros(1,fixedLength-l)];
        randomSeq = randsample([1:max_symbol],fixedLength-l,true);
        recordedData.paddedWRSdiscretizedSequence{i} = [recordedData.discretizedSequence{i} randomSeq];
        
        %inc seq
        recordedData.paddedW0incSequence{i} = [recordedData.incSequence{i} zeros(1,fixedLength-l)];
        
        %acc seq
        recordedData.paddedW0accSequence{i} = [recordedData.accSequence{i} zeros(1,fixedLength-l)];
    end
    
end

L = L / N;

% create matrices

matrixPaddedW0discretized = zeros(N,fixedLength);
matrixPaddedWRSdiscretized = zeros(N,fixedLength);
matrixPaddedW0inc = zeros(N,fixedLength);
matrixPaddedW0acc = zeros(N,fixedLength);


for i=1:N
    matrixPaddedW0discretized(i,:) = recordedData.paddedW0discretizedSequence{i};
    matrixPaddedWRSdiscretized(i,:) = recordedData.paddedWRSdiscretizedSequence{i};
    matrixPaddedW0inc(i,:) = recordedData.paddedW0incSequence{i};
    matrixPaddedW0acc(i,:) = recordedData.paddedW0accSequence{i};
end
    


gestureData = recordedData;
gestureData.averageLength = L;
gestureData.maxLength = maxL;
gestureData.minLength = minL;
gestureData.matrixPaddedW0discretized = matrixPaddedW0discretized;
gestureData.matrixPaddedWRSdiscretized = matrixPaddedWRSdiscretized;
gestureData.matrixPaddedW0inc = matrixPaddedW0inc;
gestureData.matrixPaddedW0acc = matrixPaddedW0acc;