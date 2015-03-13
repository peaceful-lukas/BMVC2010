function [R] = retrieve(S, TS, TK, config)
    
    trainDataSize = config.train.dataSize;    
    testDataSize = config.test.dataSize;
    numOfRetrieved = config.test.numOfRetrieved;

    R = {};
    R.visual_only = [];
    R.word_visual = [];
    R.our_semantic = [];

    % VISUAL-ONLY RESULTS

    tic
    mixed = TK.gist + TK.hsv + TK.bow;
    for n=1:testDataSize
        [sorted, rank_list] = sort(mixed(n, :), 'descend');
        R.visual_only = [R.visual_only; rank_list(1:numOfRetrieved)];
    end
    toc

    % WORD+VISUAL BASELINE RESULTS
    
    precalculated_norm = sqrt( sum(S.baseline.visual.^2, 2) );
    
    for n=1:testDataSize
        query = TS.baseline.visual(n, :);
        repQuery = repmat(query, trainDataSize, 1);

        cos_sim = ...
            sum((S.baseline.visual .* repQuery), 2) ./ ...
                 (precalculated_norm .* sqrt( sum(repQuery.^2, 2) ));

        [sorted, rank_list] = sort(cos_sim, 'descend');
        R.word_visual = [R.word_visual; rank_list(1:numOfRetrieved)'];
    end
    toc
    



    % OUR SEMANTIC RESULTS

    precalculated_norm = sqrt( sum(S.ours.visual.^2, 2) );

    for n=1:testDataSize
        query = TS.ours.visual(n, :);
        repQuery = repmat(query, trainDataSize, 1);

        cos_sim = ...
            sum((S.ours.visual .* repQuery), 2) ./ ...
                 (precalculated_norm .* sqrt( sum(repQuery.^2, 2) ));

        [sorted, rank_list] = sort(cos_sim, 'descend');
        R.our_semantic = [R.our_semantic; rank_list(1:numOfRetrieved)'];
    end
    toc
end