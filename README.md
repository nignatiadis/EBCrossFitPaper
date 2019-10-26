# EBCrossFit paper

Code to reproduce the results from the following paper:

Ignatiadis, N., & Wager, S. (2019). Covariate-Powered Empirical Bayes Estimation. To appear in Advances in Neural Information Processing Systems 32 (NeurIPS 2019). [arXiv:1906.01611.](https://arxiv.org/abs/1906.01611)

The method itself has been implemented in the [EBayes.jl](https://github.com/nignatiadis/EBayes.jl) package.

## Overview of this repository

All computations were run on Julia 1.2. The `Manifest.toml` file provides a specification of all dependencies. The exact package dependencies may thus be reproduced by starting the Julia REPL in this folder, pressing `]` and then typing `instantiate .`.

There are two main results reproduced here:

* Simulation results
* MovieLens analysis

