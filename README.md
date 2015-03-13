# BMVC2010
Implementation of the paper, "Accounting for the Relative Importance of Objects in Image Retrieval, S.J.Hwang, BMVC 2010" by a masters' student of Prof. Hwang


<b>INSTALLATION</b>
> To install, you should download training and test images from THE PASCAL VOC 2007 homepage, http://pascallin.ecs.soton.ac.uk/challenges/VOC/voc2007/

> Download both Training data (http://pascallin.ecs.soton.ac.uk/challenges/VOC/voc2007/#devkit) 
and Test data (http://pascallin.ecs.soton.ac.uk/challenges/VOC/voc2007/#testdata).


> After downloading the data, make sure to copy the downloaded data into each folder;
one for /data/train_images, one for /data/test_images.
Also, /data/all_images must be filled with both train and test images.


<b>EXECUTION</b>
> Before running the code, make sure to modify the project path in the first line in main.m file, 
> as well as modify config.xml file to fit your purpose.
> You can choose how many data should be involved in training phase, and how many queries are given in testing phase by modifying config.xml file.

> maximum number of training data size is 5011, and of testing data size is 4952

> If you are ready to execute the code, just type "main" in the Matlab command window, which will run the script code in the main.m file.

