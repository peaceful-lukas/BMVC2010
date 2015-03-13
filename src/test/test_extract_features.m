function [F] = test_extract_features(D, taglist, config)

    numOfWords = config.general.numOfWords;
    dataSize = config.test.dataSize;
    
    F = {};
    
    if length(taglist) > 0
        F.wc = extract_tag_feature(taglist, 'wordcount', dataSize, numOfWords);
        F.rel = extract_tag_feature(taglist, 'relrank', dataSize, numOfWords);
        F.abs = extract_tag_feature(taglist, 'absrank', dataSize, numOfWords);
    end

    [F.gist F.hsv F.bow] = extract_visual_feature('all', dataSize, D);
end