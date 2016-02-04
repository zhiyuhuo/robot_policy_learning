clc;
clear;
close all;
%

cmdtrialdataset = load('cmd_trial_dataset.mat');
cmdtrialdataset = cmdtrialdataset.cmdtrialdataset;

CMDn = {'non', 'non', 'wall', 'front', 'non'};
CMD = [CMDn{1} '_' CMDn{2} '_' CMDn{3} '_' CMDn{4} '_' CMDn{5}];
for i = 1:length(cmdtrialdataset)
    disp(cmdtrialdataset{i}{1});
    if strcmp(cmdtrialdataset{i}{1}, CMD) == 1
        CMDID = i;
    end
end

cmdstr = cmdtrialdataset{CMDID}{1};
disp(cmdstr);
cmdtrialdata = cmdtrialdataset{CMDID}{2};
nodes = containers.Map();

for i = 1:length(cmdtrialdata)
    featureset = cmdtrialdata{i};
    features = featureset{1};
    lb = featureset{2};
    state = featureset{3};
    nodesnames = keys(nodes);
    if lb > 0  
        
        states = {cmdtrialdata{i-1}{3}, cmdtrialdata{i}{3}};
        
        featurenames = {};
        for j = 1:length(features)
            feature = features{j};
            name = [feature.nameA '_' feature.nameB];
            featurenames{end+1} = name;
        end

        intersectnames = intersect(nodesnames, featurenames);
        erasenodesnames = setdiff(nodesnames, intersectnames);
        for j = 1:length(erasenodesnames)
            remove(nodes, erasenodesnames{j});
        end

        if isempty(nodesnames)
            for j = 1:length(features)
                feature = features{j};
                startempty = {feature};
                name = [feature.nameA '_' feature.nameB];
                nodes(name)= startempty;
            end
            
%             namesss = keys(nodes);
%             for j = 1:length(keys(nodes))
%                 disp(namesss{j});
%                 disp(nodes(namesss{j}));
%             end
        else
            for j = 1:length(features)
                feature = features{j};
                name = [feature.nameA '_' feature.nameB];
                if ~isempty(find(strcmp(nodesnames, name) == 1))
                    feature = features{j};
                    nodeset = nodes(name);
                    nodeset{end+1}= feature;
                    nodes(name) = nodeset;
                end
            end
            
%             namesss = keys(nodes);
%             for j = 1:length(keys(nodes))
%                 disp(namesss{j});
%                 disp(nodes(namesss{j}));
%             end
        end

    else
            % no neg samples are counted.
    end
end

nodenames = keys(nodes);
for i = 1:length(nodenames)
    disp(nodenames{i});
    spset = nodes(nodenames{i});
    outdirwmean = spset{1}.outdirw;
    indirwmean = spset{1}.indirw;
    distwmean = spset{1}.distw;
    for j = 2:length(spset)
        outdirwmean = outdirwmean + spset{j}.outdirw;
        indirwmean = indirwmean + spset{j}.indirw;
        distwmean = distwmean + spset{j}.distw;
    end
    
    outdirwmean = outdirwmean / length(spset);
    indirwmean = indirwmean / length(spset);
    distwmean = distwmean / length(spset);
    
    outdirwdiv = 0;
    indirwdiv = 0;
    distwdiv = 0;
    for j = 1:length(spset)
        outdirwdiv = outdirwdiv + norm(spset{j}.outdirw - outdirwmean);
        indirwdiv = indirwdiv + norm(spset{j}.indirw - indirwmean);
        distwdiv = distwdiv + norm(spset{j}.distw - distwmean);
    end
    
    outdirwdiv = outdirwdiv / length(spset);
    indirwdiv = indirwdiv / length(spset);
    distwdiv = distwdiv / length(spset);
    
    div = (outdirwdiv + indirwdiv + distwdiv) / 2;
    disp(div);
end














