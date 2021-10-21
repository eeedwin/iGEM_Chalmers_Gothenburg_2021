function yeast = yeastfunction(n,k,Gflux,Oflux)
%Oflux, Gflux = oxygen, and glucosefluxes

ecYeastGEM_batch = importModel('ecYeastGEM.xml');
model = ecYeastGEM_batch;

enzymeData = readtable('enzymeData.xlsx');
RxnToRemove = readtable('RxnToRemove.xlsx');

rxnsToRemove = RxnToRemove.RxnToRemove'; 

rxnsToAdd.rxns = enzymeData.Rxn;
rxnsToAdd.rxnNames = enzymeData.RxnName;
rxnsToAdd.equations = enzymeData.Reaction;
rxnsToAdd.grRules = enzymeData.Gene;
if n==0
    model = model;
else
    model=removeReactions(model,rxnsToRemove);
end

if k==0
    model = model;
else
    model = addRxns(model, rxnsToAdd, 2, 'c',1,1); %
end
 
model=setParam(model,'ub',{'r_1714_REV'},Gflux); % Glucose exchange

model=setParam(model,'ub',{'r_1992_REV'},Oflux); % oxygen uptake

model=setParam(model,'obj',{'r_2111'},1); % growth& set as obj

solve = solveLP(model);

printFluxes(model,solve.x,true,.5);
end