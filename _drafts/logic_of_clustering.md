---
layout: post
title: "The Logic of Clustering"
author: "Xinghao Gu"
date: "March 15, 2021"
categories: Statistics
permalink: "/blogs/Logic-of-Clustering/"
---

Dealing with unlabeled data is always a challenging and exciting task. Fortunately, as many great clustering algorithms have been created in past few years, you probably don't need to reinvent the wheel for your task. However, it is still important to understand the differences between those algorithms, especially when you have to pick one for your data.

**K-Means** might be the most famous clustering algorithm. I still remember the first time I learnt K-Means in machine learning class, I was deeply impressed by its elegant logic. K-Means is very efficient, it typically runs very fast because of its linear complexity. However, when you implement it, you have to tell it *the number of clusters* you are trying to find. If your data has pretty high dimension (which means it's hard to visualize it), it is quite hard to have that prior information.

**Mean Shift** might be our good choice when you can't specify the number of clusters. Similar to K-Means, Mean Shifts is also centroid based. In each iteration, it tries to move its centre to the denser region within its window. In Mean Shift, We can start from a bunch of centre points and let them converge during the iterations. This method make the algorithm way slower than K-Means, while we don't necessary to pick the number of clusters in advance. Unfortunately, although we get rid of the number of clusters, now we have another prior parameter to specify: bandwidth parameter (window size/radius).
