% 
%  !!! THIS VERSION IS NOT PROPERLY WORKING YET.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Accounting for the Relative Importance of Objects in Image Retrieval
%   ( authored by Sung Ju Hwang and Kristen Grauman, BMVC 2010 )
%   
%   Implemented by Tae Woo Kim, a masters student of prof.Hwang
%
%
%   This implementation experiments three approaches on image retrieval for verifying
%   the effect of relative importance of objects among images:
%                                        (visual-only / word + visual / semantic)
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     INITIALIZATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% !!! MODIFY THE CODE ONE LINE BELOW with your directory path
root_path = '~/Desktop/BMVC2010/';
cd(root_path)
config = initialize();
clear root_path;

% load all the training data
[D taglist] = load_data(config, 'train');
disp('training data set are all loaded.');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     FEATURE EXTRACTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

F = extract_features(D, taglist, config);
disp('tag and visual features have been extracted.');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     TRAINING PHASE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

K = create_kernel_matrices(F, config);
disp('kernel matrices have been calculated.');


% Kernelized Canonical Correlation Analysis (KCCA)
kapa.baseline = 100;
kapa.ours = 50;
eta = 0.5;
[baseline ours] = kcca(K, kapa, eta);
disp('KCCA has been done.');


% projection of training dataset onto the semantic space
S = semantic_projection(K, ours, baseline);
disp('semantic projection has been done.');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     TESTING PHASE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[TD test_taglist] = load_data(config, 'test');
TF = test_extract_features(TD, test_taglist, config);
TK = test_create_kernel_matrices(F, TF, K, config);

TS = semantic_projection(TK, ours, baseline);
R = retrieve(S, TS, TK, config);


%-------------------------
% FOR TESTING PURPOSE
%-------------------------
feature_validation = false;

if feature_validation
    for n=1:config.test.dataSize
        
        % RETRIEVE ITEMS BASED ON WORD COUNT SIMILARITY.
        % check whether word count feature is valid or not.
        P = F.wc;
        
        query = TF.wc(n, :);
        repQuery = repmat(query, config.train.dataSize, 1);
        innerProd = sum( (P .* repQuery), 2 );
        norm_p = sqrt( sum(P.^2, 2) );
        norm_q = sqrt( sum(repQuery.^2, 2) );
        norm_p(norm_p == 0) = Inf;
        norm_q(norm_q == 0) = Inf;
        wc_sim = ( innerProd ./ ( norm_p .* norm_q ) );
        [wc_sim wc_sim_idx] = sort(wc_sim, 'descend');
        R.word_visual(n, :) = wc_sim_idx(1:config.test.numOfRetrieved);

        
        % RETRIEVE ITEMS BASED ON RANK SIMILARITY.
        % check whether rank features are valid or not.
        P = F.rel;
        
        query = TF.rel(n, :);
        repQuery = repmat(query, config.train.dataSize, 1);
        innerProd = sum( (P .* repQuery), 2 );
        norm_p = sqrt( sum(P.^2, 2) );
        norm_q = sqrt( sum(repQuery.^2, 2) );
        norm_p(norm_p == 0) = Inf;
        norm_q(norm_q == 0) = Inf;
        rel_sim = ( innerProd ./ ( norm_p .* norm_q ) );

        query = TF.abs(n, :);
        repQuery = repmat(query, config.train.dataSize, 1);
        innerProd = sum( (P .* repQuery), 2 );
        norm_p = sqrt( sum(P.^2, 2) );
        norm_q = sqrt( sum(repQuery.^2, 2) );
        norm_p(norm_p == 0) = Inf;
        norm_q(norm_q == 0) = Inf;
        abs_sim = ( innerProd ./ ( norm_p .* norm_q ) );

        [rank_sim rank_sim_idx] = sort(0.5*(rel_sim+abs_sim), 'descend');
        R.our_semantic(n, :) = rank_sim_idx(1:config.test.numOfRetrieved);
    end
    clear P query repQuery norm_p norm_q wc_sim abs_sim rel_sim wc_sim_idx rank_sim_idx rank_sim innerProd n;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     SHOWING RESULT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


NDCG = evaluate(D, TD, R, config);
draw_ndcg(NDCG);
show_results(D, TD, R, config, 30, 35);

