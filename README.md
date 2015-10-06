Code Explanation 
===

### Author: Jiaming Shen 
### Date: July 1st 2015
### Email: mickeysjm@gmail.com
### Course: CS385

Directory Structure
---
* main_svm.m : main function of training in SVM
* main_logistic.m : main function of training in Logistic Regression
* readAudioData.m : read in auido data
* readSegData.m : read in segmentation data in csv format
* feature_extractor1.m : RASTA-PLP feature extractor
* feature_extractor2.m : MFCCs feature extractor
* compressData.m : (optional) compress data based on sample rate 
* rastamat/ : open-source toolbox of MFCCs & RASTA-PLP feature extraction
	* melfcc.m : core of feature_extractor2.m
	* rastaplp.m: core of feature_extractor1.m
	* ...
* liblinear-2.0/ : open-source toolbox of logistic regression
	* matlab/ : matlab interface of liblinear toolbox
	* ...
* libsvm-3.20 : open-source toolbox of SVM
	* matlab/ : matlab interface of libsvm toolbox
	* tools/ 
		* grid.py : cross-validation scripts
		* ...
	* ...
* seg.php : PHP script for using web service of MAUS
* textgrid.py : open-source script for convert .textGrid format to .csv format
* README.md
* result_saving/ : results saving directory
	* plottingResult.m : used to plot results
	* ...
* seg/ : the place store data


Code Contributions
---
1. 'seg.php' is written by my group member Zhaowei Tan, and he should get full credients.
2. 'rastamat' is an open-source toolbox and I don't make any modification on it. 
3. 'liblinear-2.0/' and 'libsvm-3.20' are open-source toolboxs for classic machine learning classification problems. I modified very small amout of codes in them, most of which are just files input/output scripts.
4. All the rest codes are written by myself. 






