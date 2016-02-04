clear;
close all;
clc;

lib = {};
worldstatedirset = dir(sprintf('worldstate/'));
for nn = 3:size(worldstatedirset, 1)
    worldstatedir = worldstatedirset(nn).name;%(nn, 1:length(num2str(n))+6);
    fname = ['worldstate/' worldstatedir];
    data = load(fname);
    bagset = data.bagset;
    for i = 1:length(bagset)
        bag = bagset(i);
        disp([num2str(nn) '   ' worldstatedir]);
        [ni featurebagset labelv keystates] = generate_training_features_from_a_bag(bag);
        lib{end+1} = {ni, featurebagset, labelv, keystates};
    end
end


fname = sprintf('features.mat');
save(fname, 'lib');