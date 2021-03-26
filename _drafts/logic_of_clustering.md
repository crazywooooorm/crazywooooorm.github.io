---
layout: post
title: "聚类的逻辑"
author: "Xinghao Gu"
date: "March 15, 2021"
categories: Statistics
permalink: "/blogs/Logic-of-Clustering/"
---

分类算法是我们处理有标签数据的常用做法，但真实世界往往是模糊的，当我们的数据没有标签，聚类算法便应运而生。时至今日，经典的聚类算法层出不穷，它们背后的逻辑是什么，各自又有何优劣，这就是我们今天要探讨的话题。

[K-Means](https://en.wikipedia.org/wiki/K-means_clustering)往往是人们接触的第一个聚类算法。它的逻辑简洁清晰，每一轮迭代只需要计算一遍每个点到各个质心的距离（线性复杂度），因此速度很快。然而，其缺点也很多：1.受制于Euclidean Distance的特性，这种Centroid based的算法天然倾向于把样本聚类成球状的簇；2.簇的数量K需要人为设定，而通常我们并没有关于K的先验知识；3.对于outlier比较敏感。

如何克服K-Means的缺点？我们一条一条来看。

在K-Means的基础上加上一个分布，可以使我们不再仅凭距离决定聚类，从而使簇的形状更灵活。一个典型的模型就是[GMM(Gaussian Mixture Model)](https://brilliant.org/wiki/gaussian-mixture-model/)。因为引入了方差，GMM在聚类时可以区分出density不同的类，从形态上可以类比成椭球状。当然，其迭代过程相较于K-Means也更为复杂，但得益于似然函数的凹函数特性，我们依旧可以用[EM算法](http://cs229.stanford.edu/notes-spring2019/cs229-notes8-2.pdf)得到局部最优解。

GMM和K-Means一样，需要我们指定K，如何在实际中解决这个问题？一个自然的想法是，从1开始逐渐增大K的取值，当聚类的表现无法从更大的K中得到足够多的增益，就停止循环，这种思想就是[Elbow method](https://en.wikipedia.org/wiki/Elbow_method_(clustering))。衡量聚类表现的metric有很多，总体思路基本是比较簇内距离和簇间距离，常见的几种包括[Silhouette](https://scikit-learn.org/stable/auto_examples/cluster/plot_kmeans_silhouette_analysis.html)和[Davies-Bouldin index](https://en.wikipedia.org/wiki/Davies%E2%80%93Bouldin_index),在此不做赘述。

那么，能不能让算法自己寻找最优的K呢？一种可能的选择是[Mean-Shift](https://en.wikipedia.org/wiki/Mean_shift)。Mean-Shift在样本空间内初始化多个质心，然后让质心不断向其邻域内密度较大的区域移动。这些质心将逐渐靠近并重合，最后剩下的簇就是我们的聚类结果。我们解决了K的问题，但问题来了，怎么定义'邻域'？事实上，Mean-Shift的聚类结果对邻域(半径)的选择很敏感，因此我们的问题依旧没有得到完美的解决。

Mean-Shift对于密度的关注启发我们在Density based算法上更进一步，于是我们有了[DBSCAN](https://en.wikipedia.org/wiki/DBSCAN)。DBSCAN定义了核心点的概念，即如果一个点在距离r的邻域内有至少m个点，则称其为一个核心点。从一个核心点出发，如果其邻域内有其它核心点，则以此继续向外延伸。当所有点都被访问过一遍，我们就得到了聚类的结果，而一些outlier因为邻域密度不够，不会被划归为任何簇。显然DBSCAN已经解决了上文提到的K-Means对outlier敏感的问题。同时，DBSCAN聚类的簇可以为任意形状，具有相当的灵活性。我们唯一剩下的问题就是，如何确定邻域的距离参数r和最少点参数m。

在这两个悬而未决的参数中，定义邻域的距离参数毫无疑问更难入手，考虑到数据在不同维度上离散程度的不同，人为选择邻域的大小是极为困难的。因此，为了弥补DBSCAN的不足，我们引入了[Hierarchical clustering](https://en.wikipedia.org/wiki/Hierarchical_clustering)的思想， [HDBSCAN](https://hdbscan.readthedocs.io/en/latest/how_hdbscan_works.html)诞生了。

HDBSCAN首先对上文DBSCAN里的核心点概念做了一修改，我们不再划分核心或非核心点，而是基于最少点参数m，算出每个点的核心距离（core distance），即邻域内包含至少m个点的最短距离。然后，我们定义了可达距离（reachability distance），当两点间的实际距离比任意点的核心距离大时，可达距离即等于实际距离，否则，可达距离等于两点间较大的一个核心距离，公式如下：
```
mutual_reachability_distance(a, b) = max(
    core_distance(a),
    core_distance(b),
    distance(a, b)
)
```
现在我们将任意两点间的可达距离作为权重，通过[Prim's algorithm](https://en.wikipedia.org/wiki/Prim%27s_algorithm)构建[minimum spanning tree](https://en.wikipedia.org/wiki/Minimum_spanning_tree)。

{%include /post_include/logic_of_clustering/hdbscan_tree.html %}





参考文献：
- [1] [Comparing Python Clustering Algorithms](https://hdbscan.readthedocs.io/en/latest/comparing_clustering_algorithms.html)
- [2] [The 5 Clustering Algorithms Data Scientists Need to Know](https://towardsdatascience.com/the-5-clustering-algorithms-data-scientists-need-to-know-a36d136ef68)
- [3] [Silhouette Analysis vs Elbow Method vs Davies-Bouldin Index: Selecting the optimal number of clusters for KMeans clustering](https://gdcoder.com/silhouette-analysis-vs-elbow-method-vs-davies-bouldin-index-selecting-the-optimal-number-of-clusters-for-kmeans-clustering/)
- [4] [Understanding HDBSCAN and Density-Based Clustering](https://towardsdatascience.com/understanding-hdbscan-and-density-based-clustering-121dbee1320e)
