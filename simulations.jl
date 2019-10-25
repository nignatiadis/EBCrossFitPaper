using EBayes
using MLJ
using XGBoost
using Random


# Set up the MLJ Machine learning method first
# Here we use XGBoost

MLJ.@load XGBoostRegressor

tree_xgb = XGBoostRegressor(max_depth=5, eta=0.1)
# r_num_round = range(tree, :num_round, lower=2, upper=100)
# nested_ranges = (num_round=r_num_round, )
#                 # gamma=r_gamma)
# tuned_XGBoost = TunedModel(model=tree,
#                           tuning=Grid(resolution=15),
#                           resampling=CV(nfolds=5),
#                           nested_ranges=nested_ranges,
#                           measure=rms)