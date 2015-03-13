function [feature] = extract_tag_feature(taglist, type, dataSize, numOfWords)

    if strcmp(type, 'wordcount')
        feature = extract_wordcount(taglist, dataSize, numOfWords);
    
    elseif strcmp(type, 'relrank')
        feature = extract_relative_rank(taglist, dataSize, numOfWords);
    
    elseif strcmp(type, 'absrank')
        feature = extract_absolute_rank(taglist, dataSize, numOfWords);

    else
        disp('type must be one of (wordcount/relrank/absrank).');
        feature = [];

    end
end






function [f] = extract_wordcount(taglist, dataSize, numOfWords)
    wordcount = zeros(dataSize, numOfWords);
    for n=1:dataSize
        if size(taglist{n}, 1) == 0
            continue;
        end

        indices = unique(taglist{n});
        if numel(indices) == 1
            wordcount(n, indices) = numel(taglist{n});
        else
            wordcount(n, indices) = hist(taglist{n}, indices);
        end
    end

    f = wordcount;
end







function [f] = extract_relative_rank(taglist, dataSize, numOfWords)
    

    N = 50;
    taglistBound = 2*N; % This is arbitrary value.
    relRankRef = zeros(numOfWords, taglistBound);

    for n=1:dataSize
        if size(taglist{n}, 1) == 0
            continue;
        end

        taglistSize = min(size(taglist{n}, 2), taglistBound);
        for m=1:taglistSize
            rank = m;
            word = taglist{n}(m);
            relRankRef(word, rank) = relRankRef(word, rank) + 1; 
        end
    end

    sumRelRankRef = sum(relRankRef, 2);
    sumRelRankRef(find(sumRelRankRef == 0)) = Inf;
    relRankRef = relRankRef ./ repmat(sumRelRankRef, 1, taglistBound);

    % add previous values - generate cumulative histogram
    for n=2:taglistBound
        relRankRef(:, n) = relRankRef(:, n-1) + relRankRef(:, n);
    end


    relRank = zeros(dataSize, numOfWords);
    for n=1:dataSize
        if size(taglist{n}, 1) == 0
            continue;
        end

        % calculate average absolute rank in the given image taglist.
        avgAbsRank = [];
        uniq = unique(taglist{n});
        for m=1:size(uniq, 2)
            ranks = find(taglist{n} == uniq(m));
            avgAbsRank(m) = sum(ranks)/size(ranks, 2);

            relRank(n, uniq(m)) = 1- (relRankRef(uniq(m), min(round(avgAbsRank(m)), N)) / relRankRef(uniq(m), N));
        end
    end

    f = relRank;
end







function [f] = extract_absolute_rank(taglist, dataSize, numOfWords)

    absRank = zeros(dataSize, numOfWords);

    for n=1:dataSize
        if size(taglist{n}, 1) == 0
            continue;
        end

        tags = taglist{n};
        for m=numel(tags):-1:1 % substitute each rank with the first appearance of the word in the tag-list
            absRank(n, tags(m)) = m;
        end
    end

    absRank = log2(1+absRank);
    absRank(find(absRank == 0)) = Inf;
    absRank = 1./absRank;

    f = absRank;
end

