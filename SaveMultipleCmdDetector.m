clc;
clear;
close all;
%

cmdtrialdataset = load('cmd_trial_dataset.mat');
cmdtrialdataset = cmdtrialdataset.cmdtrialdataset;

for CMDID = 1:length(cmdtrialdataset)
% CMDID = 10;

    cmdstr = cmdtrialdataset{CMDID}{1};
    disp(cmdstr);
    cmdtrialdata = cmdtrialdataset{CMDID}{2};
    nodes = containers.Map();

    for i = 1:length(cmdtrialdata)
        featureset = cmdtrialdata{i};
        features = featureset{1};
        lb = featureset{2};
        nodesnames = keys(nodes);
        if lb > 0  
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
                    name = [feature.nameA '_' feature.nameB];
                    nd.nameA = feature.nameA;
                    nd.nameB = feature.nameB;
                    
                    nd.outdirw = feature.outdirw;
                    nd.indirw = feature.indirw;
                    nd.distw = feature.distw;
                    
                    nodes(name) = nd;
                end
            else
                for j = 1:length(features)
                    feature = features{j};
                    name = [feature.nameA '_' feature.nameB];
                    if ~isempty(find(strcmp(nodesnames, name) == 1))
                        nodes(name) = gibbs_add(nodes(name), feature);
                    end
                end
            end

        else
                % no neg samples are counted.
        end
    end

    keyvalues = keys(nodes);
    for j = 1:length(keyvalues)
        nd = nodes(keyvalues{j});
        if (max(nd.outdirw) > 0 && length(nd.outdirw) > 1)
            nd.outdirw = nd.outdirw / max([nd.outdirw nd.indirw]);
        end
        if (max(nd.indirw) > 0 && length(nd.indirw) > 1)
            nd.indirw = nd.indirw / max([nd.outdirw nd.indirw]);
        end                   
        if (max(nd.distw) > 0 && length(nd.distw) > 1)
            nd.distw = nd.distw / max(nd.distw);
        end   
        nodes(keyvalues{j}) = nd;
    end
    
    mkdir(['Mats/' cmdstr]);
    mkdir(['Targets/' cmdstr]);

    for j = 1:length(keyvalues)
        node = nodes(keyvalues{j});
        save_node(cmdstr, keyvalues{j}, node);
        disp(keyvalues{j});
        disp(node);
    end

end