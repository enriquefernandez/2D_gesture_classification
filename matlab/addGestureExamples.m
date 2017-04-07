HMMmodelNames = {'L','O','V','Z','M'};
gesturesData = {dataL,dataO,dataV,dataZ,dataM};

extraData = {extraL,extraO,extraV,extraZ,extraM};


for k=1:length(gesturesData)
    gesturesData{k}.xyt = [gesturesData{k}.xyt(:); extraData{k}.xyt(:)];
    gesturesData{k}.discretizedSequence = [gesturesData{k}.discretizedSequence(:); extraData{k}.discretizedSequence(:)];
end

