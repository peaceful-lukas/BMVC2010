function [F] = extract_features(D, taglist, config)
    
    numOfWords = config.general.numOfWords;
    dataSize = config.train.dataSize;

    F = {};
    
    F.wc = extract_tag_feature(taglist, 'wordcount', dataSize, numOfWords);
    F.rel = extract_tag_feature(taglist, 'relrank', dataSize, numOfWords);
    F.abs = extract_tag_feature(taglist, 'absrank', dataSize, numOfWords);
    
    [F.gist F.hsv F.bow] = extract_visual_feature('all', dataSize, D);
end