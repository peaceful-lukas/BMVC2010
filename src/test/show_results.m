function show_results(D, TD, R, config, from, to)

    if from > config.test.dataSize || to > config.test.dataSize
        printf('test data size : %d\n', config.test.dataSize);
    end

    cd data/all_images

    numOfShown = config.test.numOfShown;

    retrieved = {};
    retrieved.visual_only = {};
    retrieved.word_visual = {};
    retrieved.our_semantic = {};

    fig = figure;

    for n=from:to

        q_image = imread(TD(1, n).filename);

        for m=1:numOfShown
            retrieved.visual_only{m} = imread(D(1, R.visual_only(n, m)).filename);
            retrieved.word_visual{m} = imread(D(1, R.word_visual(n, m)).filename);
            retrieved.our_semantic{m} = imread(D(1, R.our_semantic(n, m)).filename);
        end

        
        
        set(fig, 'Position', [0, 0, 1300, 700]);    
        subplot(3, numOfShown+1, 1)
        imagesc(q_image);
        axis image
        axis off
        title('Query');

        for m=1:numOfShown
            subplot(3, numOfShown+1, 1+m)
            imagesc(retrieved.visual_only{m});
            axis image
            axis off
        end
    

        for m=1:numOfShown
            subplot(3, numOfShown+1, 1+numOfShown+1+m)
            imagesc(retrieved.word_visual{m});
            axis image
            axis off
        end


        for m=1:numOfShown
            subplot(3, numOfShown+1, 1+2*(numOfShown+1)+m)
            imagesc(retrieved.our_semantic{m});
            axis image
            axis off
        end
        

        pause
    end


    cd ../../

end