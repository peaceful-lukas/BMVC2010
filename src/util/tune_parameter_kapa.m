function [max_kapa] = tune_parameter_kapa(F, TF, D, TD, K, config)

    k = 10;

    kapa_list = [ 0.1, 1, 10, 50, 100, 500 ];
    % kapa_list = [90 95 100 105 110]
    NDCG_list = zeros( numel(kapa_list), 2, k );
    
    eta = 0.5;
    for n = 1:length(kapa_list)

        kapa.baseline = kapa_list(n);
        kapa.ours = kapa_list(n);

        [baseline ours] = kcca(K, kapa, eta);
        S = semantic_projection(K, ours, baseline);
        
        TD = load_data(config, 'test');
        TF = test_extract_features(TD, [], config);
        TK = test_create_kernel_matrices(F, TF, K, config);
        TS = semantic_projection(TK, ours, baseline);
        R = retrieve(S, TS, TK, config);

        NDCG = evaluate(D, TD, R, config);

        NDCG_list(n, 1, :) = NDCG.word_visual(1:k);
        NDCG_list(n, 2, :) = NDCG.our_semantic(1:k);
    end


    max_NDCG = zeros(2, k);
    max_NDCG(1, :) = NDCG_list(1, 1, :);
    max_NDCG(2, :) = NDCG_list(1, 2, :);
    max_kapa.baseline = 0.1;
    max_kapa.ours = 0.1;

    for n = 2:length(kapa_list)
        if sum( max_NDCG(1, :) > reshape(NDCG_list(n, 1, :), [1, k]) ) > k/2
            max_NDCG(1, :) = NDCG_list(n, 1, :);
            max_kapa.baseline = kapa_list(n);
        end

        if sum( max_NDCG(2, :) > reshape(NDCG_list(n, 2, :), [1, k]) ) > k/2
            max_NDCG(2, :) = NDCG_list(n, 2, :);
            max_kapa.ours = kapa_list(n);
        end
    end

end