# EBCrossFit paper

Code to reproduce the results from the following paper:

Ignatiadis, N., & Wager, S. (2019). Covariate-Powered Empirical Bayes Estimation. To appear in Advances in Neural Information Processing Systems 32 (NeurIPS 2019). [arXiv:1906.01611.](https://arxiv.org/abs/1906.01611)

The method itself has been implemented in the [EBayes.jl](https://github.com/nignatiadis/EBayes.jl) package.

## Overview of this repository

All computations were executed on Julia 1.2. The `Manifest.toml` file provides a specification of all dependencies. The exact package dependencies may thus be reproduced by starting the Julia REPL in this folder, pressing `]` and then typing `instantiate .`.

There are three main results reproduced here:

* **Synthetic experiments (simulations)**, i.e. we reproduce Figure 3 from the manuscript. Running `julia simulations.jl` runs all the simulations, evaluates the methods and stores the mean squared errors (± standard errors) in the `synthetic_benchmark_files` folder. For convenience we also provide precomputed results. The panels of Figure 2 may be generated afterwards by running `julia synthetic_benchmark_plots.jl`.
* **MovieLens analysis**, i.e. we reproduce Figure 2 from the manuscript. The corresponding code is available in the Jupyter notebook `EBCrossFit_Movielens.ipynb`. The preprocessing of the dataset occurs through the [EBayesDatasets.jl](https://github.com/nignatiadis/EBayesDatasets.jl) package.
* **Crimes and communities unnormalized analysis**, i.e. we reproduce Table 1 from the manuscript. The code is available in the Jupyter notebook `EBCrossFit_Crime_And_Communities.ipynb`.

