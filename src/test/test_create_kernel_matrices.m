function [TK] = test_create_kernel_matrices(F, TF, K, config)

    TK = {};

    % in the testing phase, I only consider image queries and exclude tag queries.

    TK.gist = test_create_kernel_matrix(F.gist, TF.gist, K.gist_mean, config);
    TK.hsv = test_create_kernel_matrix(F.hsv, TF.hsv, K.hsv_mean, config);
    TK.bow = test_create_kernel_matrix(F.bow, TF.bow, K.bow_mean, config);

    TK.visual = (TK.gist + TK.hsv + TK.bow)/3;
end