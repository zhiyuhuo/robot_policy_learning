function [res, poselist] = score_a_pose(ni, detector, states)

res = [];
dctnames = keys(detector);
poselist = [];
[featureset, poselist] = compute_state_set_with_pose_change(ni, states);

for n = 1:length(featureset)
    feature = featureset{n};
    score = 0;
    for i = 1:length(dctnames)
        dct = detector(dctnames{i});
        sc = 0;
        for j = 1:length(feature)
            if strcmp(dct.nameA, feature{j}.nameA) == 1 && strcmp(dct.nameB, feature{j}.nameB) == 1
                if strcmp(dct.nameA, 'rotation') == 1 
                    if abs(feature{j}.outdirw - dct.outdirw) < max([0.1, dct.indirw])
                        sc = 1;
                    else
                        sc = 0;
                    end    
                else
                    sc = sum( (feature{j}.outdirw .* dct.outdirw + feature{j}.indirw .* dct.indirw + feature{j}.distw .* dct.distw) / 2 );
                end
            end
        end
        
        score = score + sc;
    end
    score = score / length(feature);
    res = [res; score];
end

end