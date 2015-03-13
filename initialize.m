function [config] = initialize
    addpath ./src
    addpath ./src/kcca_package
    addpath ./src/common
    addpath ./src/train
    addpath ./src/test
    addpath ./src/util

    % load configurations
    config = load_config();
    disp('config.xml has been loaded.');
end