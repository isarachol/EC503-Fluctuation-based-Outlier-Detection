# EC503 Fluctuation-based-Outlier-Detection
This repositiory is used to store source code used for a project in EC503 at BU. 
Contributors: Isara Cholaseuk, Jinyu Huang, Shuhao Jiang
Link to our repository: https://github.com/isarachol/EC503-Fluctuation-based-Outlier-Detection

Most of our study is conducted in combine_classification_demo.m script file, which requires modification of workspace on the first few lines. To replicate our studies, change the directory for datasets in the combine_classification_demo.m and change the directory for random graphs in both combine_classification_demo.m and GG_RandomLink.m.

## Original source code and algorithm
This repository is forked from https://github.com/FluctuationOD/Fluctuation-based-Outlier-Detection, which was presented in the paper https://doi.org/10.1038/s41598-023-29549-1

Key insights from the paper
The FBOD method is an outlier detection method that calculates the value called "Outlier Factors" which are calculated from a value called "Fluctuation." The step starts by creating T number of random graphs that can be used to connect data points to k number of random neighbors in the same dataset. Fluctuation values are calculated for each graph, and the sum of fluctuations from all graphs. The higher the k and T, the higher the accuracy (based on the paper). The fluctuation value of each data point is then compared with its neighbors' selected from one of the random graphs. The sum of the differences is called outlier factors. Higher outlier factors means higher differences from neighbors, which means the value can predict outliers.

- Fluctuation of a data point is a ratio of the sum of its feature values divided by the sum of its neighbors' feature values. This means that if the neighbors are very close by, the fluctuation would be close to 1/(1+k) when k is the number of neighbors while it would be much different if it is far away from its neighbors.

## Our Modifications
- demo.m: (PNDB) added our path, perform FBOD on our dataset
- GG_Randomlink.m: added out path and changed the txt file for storing the random graphs
- FVP.m: added our path and changed the txt file for storing the random graphs
- Measure_AUC.m: none
- Label_wine.txt: none
- Normalization_wine.txt: none
- The saved variable.mat: none

## Our additional scripts
- EvaluatePerformance: sectioned out of FVP.m. This part calculates performances used in the paper. But we don't need it, so we save it some where else for future use.
- classification_demo.m: (PNDB) performs FBOD on separate classes and train SVM (Did not work out very well)
- combine_classification_demo.m: (PNDB) performs FBOD on both classes and treat the class as another feature
- extract_dataset_csv.m: (PNDB) preprocess PNDB dataset by substituting (String) features with integer labels. Extract dataset and labels separately.
- extract_dataset_csv_breast_cancer.m: same as the other one but for another dataset (different Strings). This function was not completed in time and can be improved in the future.
- FBOD.m: calls GG_Randomlink.m and FVP.m
- filter_outliers: separate outliers from normal dataset using outlier factor threshold.
- Train_SSGD_SVM.m: performs stochastic sub-gradient descent to implement SVM and find the best hyperplane that classify two classes
- Test_SSGD_SVM.m: Implement the theta of the training model to our pair-labels SVM classifier to predict the label of the test dataset and calculate the corresponding CCR.

## Datasets
- PNDB (7 features, 2 classes): https://www.kaggle.com/datasets/slmsshk/pndm-prediction-dataset

Processed dataset: https://drive.google.com/drive/folders/1SfOq_HghITev13HQcJK_GrrmmbxjxWh0?usp=sharing
PNDB dataset contains (String) features that can be represented by numbers of classes. The PNDB dataset is preprocessed using the script file extract_dataset_csv.m.

- iris (4 features, 3 classes): used only 2 classes to perform SVM from homework 6