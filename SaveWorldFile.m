%
clc;
clear;
close all;
%

fid = fopen('trainer.world');

linetextset = {};
tline = fgetl(fid);
linetextset{end+1} = tline;
while ischar(tline)
    disp(tline)
    tline = fgetl(fid);
    linetextset{end+1} = tline;
end
fclose(fid);

tokensset = {};
for i = 1:length(linetextset)
    tokens = {};
    remain = linetextset{i};
    [tk remain] = strtok(remain);
    tokens{end+1} = tk;
    while (~isempty(remain))
        [tk remain] = strtok(remain);
        tokens{end+1} = tk;
    end
    tokensset{end+1} = tokens;
end

categorydimmap = containers.Map();
for i = 1:length(tokensset)
    tokens = tokensset{i};
    for j = 1:length(tokens)
        tk = tokens{j};
        if strcmp(tk, 'define') == 1 && strcmp(tokens{j+2}, 'model') == 1 && strcmp(tokensset{i+2}{1}, 'size') == 1
            dim = [ str2num(tokensset{i+2}{3}), str2num(tokensset{i+2}{4})]; 
            categorydimmap(tokens{j+1}) = dim;
        end
    end
end

idparametermap = containers.Map();
for i = 1:length(tokensset)
    tokens = tokensset{i};
    for j = 1:length(tokens)
        tk = tokens{j};
        if strcmp(tk, 'ranger_return') == 1 
            id  = tokens{j+1};
            id = id(1:end-1);
            name = tokens{10};
            name = name(2:end-1);
            category = tokens{1};
            category = category(1:end-1);
            dim = categorydimmap(category);
            pose = [str2num(tokens{4}) str2num(tokens{5}) str2num(tokens{7})];
            f.name = name;
            f.pose = pose;
            f.dim = dim;
            idparametermap(id) = f;
        end
    end
end

% load long time entites.
lemap = containers.Map();
for i = 1:length(tokensset)
    tokens = tokensset{i};
    for j = 1:length(tokens)
        tk = tokens{j};
        if strcmp(tk, '#-le_name') == 1 
            id = tokens{17};
            name = tokens{2}(2:end);
            pose = [str2num(tokens{5}) str2num(tokens{6}) str2num(tokens{8})];
            dim = [str2num(tokens{12}) str2num(tokens{13}) str2num(tokens{14})];
            le.name = name;
            le.pose = pose;
            le.dim = dim;
            idparametermap(id) = le;
        end
    end
end

save('id_parameter_map.mat', 'idparametermap');















