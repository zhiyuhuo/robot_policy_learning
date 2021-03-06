clc;
clear;
close all;
%

cmdtrialdataset = load('cmd_trial_dataset.mat');
cmdtrialdataset = cmdtrialdataset.cmdtrialdataset;

CMDn = {'non', 'non', 'couch', 'right', 'table'};
CMD = [CMDn{1} '_' CMDn{2} '_' CMDn{3} '_' CMDn{4} '_' CMDn{5}];
for i = 1:length(cmdtrialdataset)
    disp(cmdtrialdataset{i}{1});
    if strcmp(cmdtrialdataset{i}{1}, CMD) == 1
        CMDID = i;
    end
end
disp('----------------------');

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
        disp(i)
        disp(featurenames)

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
    
    outdirwdiv = 0;
    indirwdiv = 0;
    distwdiv = 0;
    tt = 0;
    
    outdirwdivmax = 0;
    indirwdivmax = 0;
    distwdivmax = 0;
    
    for j = 1:length(spset)
        for k = 1:length(spset)
            if j > k
                outdirwdiv = outdirwdiv + sum(abs(spset{j}.outdirw - spset{k}.outdirw));
                indirwdiv = indirwdiv + sum(abs(spset{j}.indirw - spset{k}.indirw));
                distwdiv = distwdiv + sum(abs(spset{j}.distw - spset{k}.distw));
                
                if sum(abs(spset{j}.outdirw - spset{k}.outdirw)) > outdirwdivmax
                    outdirwdivmax = sum(abs(spset{j}.outdirw - spset{k}.outdirw)) / 2;
                end
                
                if sum(abs(spset{j}.outdirw - spset{k}.indirw)) > indirwdivmax
                    indirwdivmax = sum(abs(spset{j}.indirw - spset{k}.indirw)) / 2;
                end
                
                if sum(abs(spset{j}.outdirw - spset{k}.distw)) > distwdivmax
                    distwdivmax = sum(abs(spset{j}.distw - spset{k}.distw)) / 2;
                end
                
                tt = tt + 1;
            end
        end
    end
    
    outdirwdiv = outdirwdiv / tt;
    indirwdiv = indirwdiv / tt;
    distwdiv = distwdiv / tt;
    
%     div = (outdirwdiv + indirwdiv + distwdiv) / 2 / 2;
    div = [outdirwdivmax + indirwdivmax, distwdivmax];
    disp(div);
end














