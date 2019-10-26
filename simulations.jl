using Pkg
Pkg.activate(".")

using EBayes
using MLJ
using Random
using JLD2

# Set up the MLJ Machine learning method first
# Here we use XGBoost with iterations chosen by cross-validation

MLJ.@load XGBoostRegressor

tree_xgb = XGBoostRegressor(max_depth=5, eta=0.1)
r_num_round = range(tree_xgb, :num_round, lower=2, upper=100)

tuned_XGBoost = TunedModel(model=tree_xgb,
                           tuning=Grid(resolution=15),
                           resampling=CV(nfolds=5),
                           ranges=r_num_round,
                           measure=rms)

ebcf_tuned_xgb = EBayesCrossFit(tuned_XGBoost, num_folds=5)

# Function that calculates the MSEs
function main_simulation_eval_mse(sim::EBayes.FriedmanFayHerriotSimulation;
                                  nreps = 200)
   mse_vec = zeros(4, nreps)
   for i=1:nreps
       sim_res = rand(sim)
       # MLE pred
       ss = sim_res.ss
       Xs = sim_res.X
       true_μs = sim_res.true_μs

       # Unbiased/MLE prediction
       pred_unbiased = response(ss)
       mse_vec[1, i] = mean( (pred_unbiased .- true_μs).^2 )

       # SURE prediction
       fit_sure = fit(Normal(), SURE(), GrandMeanLocation(), ss)
       pred_sure = predict(fit_sure)
       mse_vec[3, i] = mean( (pred_sure .- true_μs).^2 )

       # XGBoost and EBCF prediction
       fit_ebcf_reg = fit(ebcf_tuned_xgb, Xs, ss, verbosity=1)
       pred_ebcf = predict(fit_ebcf_reg)
       pred_reg = fit_ebcf_reg.reg_preds

       mse_vec[2, i] = mean( (pred_reg .- true_μs).^2 )
       mse_vec[4, i] = mean( (pred_ebcf .- true_μs).^2 )
    end
    #order in mse_vec is ["Unbiased" "XGBoost" "SURE" "EBCF"]
    (all_res = mse_vec, mses = mean(mse_vec; dims=2),
     mse_ses = std(mse_vec; dims=2)./sqrt(nreps),
     A_sqrt = sim.A_sqrt, n = sim.n, p = sim.p, σ = sim.σ)
 end


#-----------------------------
# Simulation settings
#------------------------------

# MSE calculated by averaging 100 Monte Carlo replicates
nreps = fill(100,15)
# For n=300 realizations more noisy, so average 400 Monte carlo replicates
nreps[1:3] .= 400


ns = Int.(collect(range(300; stop=2000, length=5)))
p = 15
σ = 2.0
As_sqrt = [0.0; 2.0; 3.0]

sim_param_combs = vec([(n,A_sqrt) for A_sqrt in As_sqrt, n in ns])


#tst_fh = EBayes.FriedmanFayHerriotSimulation(1000, 5 , 0.5, 1.0)
#tmp = main_simulation_eval_mse(tst_fh; nreps=3)


for i in 1:length(sim_param_combs)
    tupl = sim_param_combs[i]
    @show tupl
    n = tupl[1]
    A_sqrt = tupl[2]
    sim_fh = EBayes.FriedmanFayHerriotSimulation(n, p , A_sqrt, σ)
    benchmark_res = main_simulation_eval_mse(sim_fh; nreps=nreps[i])
    @JLD2.save "synthetic_benchmark_files/benchmark_res_$(i).jld2" benchmark_res
 end


