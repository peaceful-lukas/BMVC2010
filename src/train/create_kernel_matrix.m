function [K chi_mean] = create_kernel_matrix(F, config)
    
    dataSize = config.train.dataSize;

    % firstly, calculates chi-square distances for all training data
    repSumF = repmat(sum(F, 2), 1, size(F, 2));
    repSumF(repSumF == 0) = Inf;
    Profiles = F ./ repSumF;

    avgProfiles = sum(Profiles, 1) ./ dataSize;
    repAvgProfiles = repmat(avgProfiles, dataSize, 1);
    repAvgProfiles(repAvgProfiles == 0) = Inf;

    ChiDist = [];
    for n=1:dataSize
        repProfiles = repmat(Profiles(n, :), dataSize, 1);
        ChiDist(n, :) = sum( (((Profiles - repProfiles).^2) ./ repAvgProfiles), 2 );
    end
    ChiDist = sqrt(ChiDist);
    
    numOfDist = dataSize*(dataSize+1)/2;
    chi_mean = sum(sum(tril(ChiDist))) / numOfDist;


    % calculates chi-square kernel matrix
    K = [];
    for n=1:dataSize
        repF = repmat(F(n, :), dataSize, 1);
        
        num = repF - F;
        den = repF + F;
        den(find(den == 0)) = Inf;

        K(n, :) = sum( ((num.^2)./den)' );
    end

    chi_exp = exp(1)^((-1)/(2*chi_mean));
    K = chi_exp.^K;
end