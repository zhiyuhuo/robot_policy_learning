clc;
clear;
close all;
%

cmdtrialdataset = load('cmd_trial_dataset.mat');
cmdtrialdataset = cmdtrialdataset.cmdtrialdataset;

CMDn = {'non', 'non', 'robot', 'left', 'table'};
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
                name = [feature.nameA '_' feature.nameB];
                nd.nameA = feature.nameA;
                nd.nameB = feature.nameB;

                if (max(feature.outdirw) > 0 && length(feature.outdirw) > 1)
                    nd.outdirw = feature.outdirw / max(feature.outdirw);
                else
                    nd.outdirw = feature.outdirw;
                end
                if (max(feature.indirw) > 0 && length(feature.indirw) > 1)
                    nd.indirw = feature.indirw / max(feature.indirw);
                else
                    nd.indirw = feature.indirw;
                end                   
                if (max(feature.distw) > 0 && length(feature.distw) > 1)
                    nd.distw = feature.distw / max(feature.distw);
                else
                    nd.distw = feature.distw;
                end
                nd.div = 0;

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
            
            keyslist = keys(nodes);
            for j = 1:length(keyslist)
                disp([keyslist{j} ': ' num2str(nodes(keyslist{j}).div)]);
            end
            
            %[scoreset poselist] = score_a_pose(CMDn, nodes, states);
            %draw_score_map(poselist, scoreset);
            
        end

    else
            % no neg samples are counted.
    end
end

