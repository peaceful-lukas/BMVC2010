function [D taglist] = load_data(config, type)

    rootPath = config.general.rootPath;
    trainDataSize = config.train.dataSize;
    testDataSize = config.test.dataSize;

    if strcmp('train', type)
        data_path = strcat(rootPath, 'data/sjhwang_pascal/train.mat');
        load(data_path);

        D = [D1 D2];
        D = D(1, 1:trainDataSize);

        taglist = {};
        for n=1:trainDataSize
            taglist{n} = D(1, n).taglist;
        end

    else % otherwise, load test data set
        data_path = strcat(rootPath, 'data/sjhwang_pascal/test.mat');
        load(data_path);

        D = [D1 D2];
        D = D(1, 1:testDataSize);

        taglist = {};
        for n=1:testDataSize
            taglist{n} = D(1, n).taglist;
        end
    end
end