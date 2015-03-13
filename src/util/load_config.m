function [config] = load_config()
    xmlfile = xmlread('config.xml');

    % general configuration
    general = xmlfile.getElementsByTagName('general').item(0);
    rootPath = general.getElementsByTagName('rootPath').item(0).getTextContent;
    numOfWords = general.getElementsByTagName('numOfWords').item(0).getTextContent;
    
    % train data configuration
    train = xmlfile.getElementsByTagName('train').item(0);
    trainDataSize = train.getElementsByTagName('dataSize').item(0).getTextContent;
    
    % test data configuration
    test = xmlfile.getElementsByTagName('test').item(0);
    testDataSize = test.getElementsByTagName('dataSize').item(0).getTextContent;
    numOfRetrieved = test.getElementsByTagName('numOfRetrieved').item(0).getTextContent;
    numOfShown = test.getElementsByTagName('numOfShown').item(0).getTextContent;

    % config object creation
    config = {};
    config.general.rootPath = char(rootPath);
    config.general.numOfWords = str2double(numOfWords);
    config.train.dataSize = str2double(trainDataSize);
    config.test.dataSize = str2double(testDataSize);
    config.test.numOfRetrieved = str2double(numOfRetrieved);
    config.test.numOfShown = str2double(numOfShown);
end