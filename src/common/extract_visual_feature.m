
% SHOULD BE RELPLACED WHEN FEATURE EXTRACTION CODE MADE.
function [gist hsv bow] = extract_visual_feature(type, dataSize, D)

    gist = [];
    hsv = [];
    bow = [];
    for n=1:dataSize
        gist = [gist; D(1, n).gist];
        hsv = [hsv; D(1, n).color];
        bow = [bow; D(1, n).bow];
    end    
end






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% THE CODE BELOW IS CURRENTLY NOT USED.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [feature] = extract_visual_feature_real(type, dataSize, D)

    if strcmp(type, 'gist')
        feature = extract_gist(D, dataSize);
    
    elseif strcmp(type, 'hsv')
        feature = extract_hsv(D, dataSize);
    
    elseif strcmp(type, 'bow')
        feature = extract_bow(D, dataSize);

    else
        disp('type must be one of (gist/hsv/bow).');
        feature = [];

    end
end






function [f] = extract_gist(D, dataSize)
    
end




function [f] = extract_hsv(D, dataSize)

end




function [f] = extract_bow(D, dataSize)

end