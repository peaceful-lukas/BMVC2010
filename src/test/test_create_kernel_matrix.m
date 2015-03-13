function [K] = test_create_kernel_matrix(F, TF, chi_mean, config)
    
    trainDataSize = config.train.dataSize;
    testDataSize = config.test.dataSize;

    K = [];
    for n=1:testDataSize
        repTF = repmat(TF(n, :), trainDataSize, 1);
        
        num = repTF - F;
        den = repTF + F;
        den(find(den == 0)) = Inf;

        K(n, :) = sum( ((num.^2)./den)' );
    end

    % chi_mean = sum(sum(K)) / trainDataSize * testDataSize;
    chi_exp = exp(1)^((-1)/(2*chi_mean));
    K = chi_exp.^K;
end