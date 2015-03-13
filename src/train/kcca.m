function [baseline ours] = kcca(K, kapa, eta)

    baseline = {};
    [baseline.a baseline.b baseline.r]  = kcanonca_reg_ver1(K.visual, K.wc, eta, kapa.baseline);
    baseline.a = baseline.a(:, end-19:end);
    baseline.b = baseline.b(:, end-19:end);
    
    ours = {};
    [ours.a ours.b ours.r]  = kcanonca_reg_ver1(K.visual, K.wordrank, eta, kapa.ours);
    ours.a = ours.a(:, end-19:end);
    ours.b = ours.b(:, end-19:end);
end