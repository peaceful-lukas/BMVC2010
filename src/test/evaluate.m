function [NDCG] = evaluate(D, TD, R, config)

    k = config.test.numOfRetrieved;
    trainDataSize = config.train.dataSize;
    testDataSize = config.test.dataSize;

    % object scale
    OS = {};
    OS.train = [];
    OS.test = [];
    for n=1:trainDataSize
        OS.train = [OS.train; D(1, n).objectscale];
    end
    for n=1:testDataSize
        OS.test = [OS.test; TD(1, n).objectscale];
    end

    % object count
    OC = {};
    OC.train = [];
    OC.test = [];
    for n=1:trainDataSize
        OC.train = [OC.train; D(1, n).objectcount];
    end
    for n=1:testDataSize
        OC.test = [OC.test; TD(1, n).objectcount];
    end

    NDCG = {};
    NDCG.visual_only = zeros(testDataSize, k);



    for n=1:testDataSize

        S = {};
        W = {};

        S.q = OS.test(n, :);
        W.q = OC.test(n, :);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % VISUAL ONLY
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        S.p = OS.train(R.visual_only(n, :), :);
        S.val = cosine_similarity(S.p, S.q, k);
        
        W.p = OC.train(R.visual_only(n, :), :);
        W.val = cosine_similarity(W.p, W.q, k);

        NDCG.visual_only(n, :) = getNDCG(S.val, W.val, k);
        

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % WORD + VISUAL
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        S.p = OS.train(R.word_visual(n, :), :);
        S.val = cosine_similarity(S.p, S.q, k);
        
        W.p = OC.train(R.word_visual(n, :), :);
        W.val = cosine_similarity(W.p, W.q, k);

        NDCG.word_visual(n, :) = getNDCG(S.val, W.val, k);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % OUR SEMANTIC
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        S.p = OS.train(R.our_semantic(n, :), :);
        S.val = cosine_similarity(S.p, S.q, k);
        
        W.p = OC.train(R.our_semantic(n, :), :);
        W.val = cosine_similarity(W.p, W.q, k);

        NDCG.our_semantic(n, :) = getNDCG(S.val, W.val, k);
    end

    NDCG.visual_only = sum( NDCG.visual_only, 1 ) / testDataSize;
    NDCG.word_visual = sum( NDCG.word_visual, 1 ) / testDataSize;
    NDCG.our_semantic = sum( NDCG.our_semantic, 1 ) / testDataSize;
end

function [sim] = cosine_similarity(P, query, k)
    repQuery = repmat(query, k, 1);
    innerProd = sum( (P .* repQuery), 2 );
    norm_p = sqrt( sum(P.^2, 2) );
    norm_q = sqrt( sum(repQuery.^2, 2) );
    sim = ( innerProd ./ ( norm_p .* norm_q ) );
end

function [NDCG] = getNDCG(simS, simW, k)
    s = 0.5 * (simS + simW);
    ideal_s = sort(s, 'descend');

    ndcg = (2.^s - 1) ./ log2(1 + (1:k))';
    max_dcg = (2.^ideal_s - 1) ./ log2(1 + (1:k))';
    max_dcg(max_dcg == 0) = Inf;

    for m=2:k
        ndcg(m) = ndcg(m-1) + ndcg(m);
        max_dcg(m) = max_dcg(m-1) + max_dcg(m);
    end

    NDCG = ndcg ./ max_dcg;
end
