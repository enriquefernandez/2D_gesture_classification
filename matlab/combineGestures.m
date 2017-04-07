% Combine Anna's with my Gestures

annaGest = {aL, aO, aV, aZ, aM, aG, aT, aAnd, aGT, aW, aC};
eGest =    {newL, newO, newV, newZ, newM, eG, eT, eAnd, eGT, newW, eC};

L = length(annaGest);
combinedGestures = cell(L,1);

for k=1:L
    combinedGestures{k}.xyt = [annaGest{k}.xyt(:); eGest{k}.xyt(:)];
    combinedGestures{k}.discretizedSequence = [annaGest{k}.discretizedSequence(:); eGest{k}.discretizedSequence(:)];
    combinedGestures{k}.incSequence = [annaGest{k}.incSequence(:); eGest{k}.incSequence(:)];
    combinedGestures{k}.accSequence = [annaGest{k}.accSequence(:); eGest{k}.accSequence(:)];
    combinedGestures{k} = bundleGestureData(combinedGestures{k});
end
