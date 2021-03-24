---
layout: post
title: "聚类的逻辑"
author: "Xinghao Gu"
date: "March 15, 2021"
categories: Statistics
permalink: "/blogs/Logic-of-Clustering/"
---

分类算法是我们处理有标签数据的常用做法，但真实世界往往是模糊的，当我们的数据没有标签，聚类算法便应运而生。时至今日，经典的聚类算法层出不穷，它们背后的逻辑是什么，各自又有何优劣，这就是我们今天要探讨的话题。

[K-Means](https://en.wikipedia.org/wiki/K-means_clustering)往往是人们接触的第一个聚类算法。它的逻辑简洁清晰，每一轮迭代只需要计算一遍每个点到各个质心的距离（线性复杂度），因此速度很快。然而，其缺点也很多：1.受制于Euclidean Distance的特性，这种centroid based的算法天然倾向于把样本聚类成球状的簇；2.簇的数量K需要人为设定，而通常我们并没有关于K的先验知识；3.对于outlier比较敏感。

如何克服K-Means的缺点？我们一条一条来看。

在K-Means的基础上加上一个分布，可以使我们不再仅凭距离决定聚类，从而使簇的形状更灵活。一个典型的模型就是[GMM(Gaussian Mixture Model)](https://brilliant.org/wiki/gaussian-mixture-model/)。因为引入了方差，GMM在聚类时可以区分出density不同的类，从形态上可以类比成椭球状。当然，其迭代过程相较于K-Means也更为复杂，但得益于似然函数的凹函数特性，我们依旧可以用[EM算法](http://cs229.stanford.edu/notes-spring2019/cs229-notes8-2.pdf)得到局部最优解。




Dealing with unlabeled data is always a challenging and exciting task. Fortunately, as many great clustering algorithms have been created in past few years, you probably don't need to reinvent the wheel for your task. However, it is still important to understand the differences between those algorithms, especially when you have to pick one for your data.

**K-Means** might be the most famous clustering algorithm. I still remember the first time I learnt K-Means in machine learning class, I was deeply impressed by its elegant logic. K-Means is very efficient, it typically runs very fast because of its linear complexity. However, when you implement it, you have to tell it *the number of clusters* you are trying to find. If your data has pretty high dimension (which means it's hard to visualize it), it is quite hard to have that prior information.

**Mean Shift** might be our good choice when you can't specify the number of clusters. Similar to K-Means, Mean Shifts is also centroid based. In each iteration, it tries to move its centre to the denser region within its window. In Mean Shift, We can start from a bunch of centre points and let them converge during the iterations. This method make the algorithm way slower than K-Means, while we don't necessary to pick the number of clusters in advance. Unfortunately, although we get rid of the number of clusters, now we have another prior parameter to specify: bandwidth parameter (window size/radius).
