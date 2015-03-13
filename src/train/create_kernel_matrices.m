function [K] = create_kernel_matrices(F, config)
    
    K = {};

    [K.wc K.wc_mean] = create_kernel_matrix(F.wc, config);
    disp('kernel matrix for wordcount has been created.');
    [K.rel K.rel_mean] = create_kernel_matrix(F.rel, config);
    disp('kernel matrix for relative rank has been created.');
    [K.abs K.abs_mean] = create_kernel_matrix(F.abs, config);
    disp('kernel matrix for absolute rank has been created.');

    [K.gist K.gist_mean] = create_kernel_matrix(F.gist, config);
    disp('kernel matrix for gist has been created.');
    [K.hsv K.hsv_mean] = create_kernel_matrix(F.hsv, config);
    disp('kernel matrix for hsv has been created.');
    [K.bow K.bow_mean] = create_kernel_matrix(F.bow, config);
    disp('kernel matrix for bow has been created.');

    K.wordrank = (K.rel + K.abs)/2;
    K.visual = (K.gist + K.hsv + K.bow)/3;
end