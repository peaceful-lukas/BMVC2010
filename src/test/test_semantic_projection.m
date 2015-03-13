function [TS] = test_semantic_projection(TK, ours, baseline)
    
    TS = {};
    TS.baseline.visual = [];
    TS.ours.visual = [];

    TS.baseline.visual = TK.visual*baseline.a;
    TS.ours.visual = TK.visual*ours.a;
end