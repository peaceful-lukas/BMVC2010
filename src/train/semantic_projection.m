function [S] = semantic_projection(K, ours, baseline)

    S = {};
    S.baseline.visual = [];
    S.ours.visual = [];

    S.baseline.visual = K.visual*baseline.a;
    S.ours.visual = K.visual*ours.a;
end