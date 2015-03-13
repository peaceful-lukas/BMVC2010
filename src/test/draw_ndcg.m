function draw_ndcg(NDCG)
    figure;
    hold on;

    plot(NDCG.visual_only);
    plot(NDCG.word_visual);
    plot(NDCG.our_semantic);

    xlabel('Top k');
    ylabel('NDCG@K');
    legend('visual only', 'word + visual', 'ours', 'Location', 'southeast');
    hold off;
end