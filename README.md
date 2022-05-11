# Fluctuation-based-Outlier-Detection
There are two main functions included in our model, graph generation and feature value propagation. The user runs the demo file and adjusts the relevant parameters to run successfully.

Outlier detection is an important topic in machine learning and has been used in a wide range of applications. Outliers are objects that are few in number and deviate from the majority of objects. As a result of these two properties, we show that outliers are susceptible to a mechanism called fluctuation. This article proposes a method called fluctuation-based outlier detection (FBOD) that achieves a low linear time complexity and detects outliers purely based on the concept of fluctuation without employing any distance, density or isolation measure, fundamentally different from all existing methods. FBOD first converts the Euclidean structure datasets into graphs by using random links, then propagates the feature value according to the connection of the graph. Finally, by comparing the difference between the fluctuation of an object and its neighbors, FBOD determines the object with a larger difference as an outlier. The results of experiments comparing FBOD with four state-of-the-art algorithms on eight real-world tabular datasets and three video datasets show that FBOD outperforms its competitors in the majority of cases and that FBOD has only 5% of the execution time of the fastest algorithm.
