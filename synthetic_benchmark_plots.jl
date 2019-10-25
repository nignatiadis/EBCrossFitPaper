using FileIO
using JLD2
using Plots
using LaTeXStrings
using DataFrames

pgfplots()

sim_df = DataFrame(A_sqrt = Float64[],
                   p=Int64[],
                   σ=Float64[],
                   n=Int64[],
                   Unbiased=Float64[],
                   xgboost=Float64[],
                   SURE=Float64[],
                   EBCF = Float64[])

i = 1
to_load =  "synthetic_benchmark_files/benchmark_res_$(i).jld2"
tmp_res = FileIO.load(to_load,"benchmark_res")

methods_text = ["Unbiased" "XGBoost" "SURE" "EBCF"]
method_to_idx = Dict(["Unbiased" "XGBoost" "SURE" "EBCF"] .=> [1 2 3 4])

res1[2]
tmp_df = DataFrame(A_sqrt = tmp_res[:A_sqrt],
             p=tmp_res[:p],
             σ=tmp_res[:σ],
             n=tmp_res[:n],
             mse=vec(tmp_res[:mses]),
             mse_se=vec(tmp_res[:mse_ses]),
             method=vec(methods_text))

wide_df = unstack(tmp_df, [:A_sqrt,:p, :σ, :n], :method, :mse)
#
#for (n, A_sqrt) in eb_params
#     file1 = ebayes_sim_filename(n, A_sqrt)
#     res1 = FileIO.load(file1,"bench_res")
#     res1 = res1[2]
#     push!(sim_df, (A_sqrt, n, res1...))
# end