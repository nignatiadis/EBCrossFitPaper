using Pkg
Pkg.activate(".")

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
                   mse=Float64[],
                   mse_se=Float64[],
                   method = String[])


methods_text = ["Unbiased" "XGBoost" "SURE" "EBCF"]
method_to_idx = Dict(["Unbiased" "XGBoost" "SURE" "EBCF"] .=> [1 2 3 4])

for i=1:15
  to_load =  "synthetic_benchmark_files/benchmark_res_$(i).jld2"
  tmp_res = FileIO.load(to_load,"benchmark_res")
  tmp_df = DataFrame(A_sqrt = tmp_res[:A_sqrt],
             p=tmp_res[:p],
             σ=tmp_res[:σ],
             n=tmp_res[:n],
             mse=vec(tmp_res[:mses]),
             mse_se=vec(tmp_res[:mse_ses]),
             method=vec(methods_text))
  append!(sim_df, tmp_df)
end

#-------------------------------------
# Maximum standard errors
#-------------------------------------

rmse_ci_lhs = sqrt.(sim_df[:,:mse] .- 1 .* sim_df[:,:mse_se])
rmse_ci_rhs = sqrt.(sim_df[:,:mse] .+ 1 .* sim_df[:,:mse_se])

ci_widths = rmse_ci_rhs .- rmse_ci_lhs
se_proxies = ci_widths ./ 2
se_delta = sim_df[:,:mse_se] ./ (2 .* sqrt.(sim_df[:,:mse]))

maximum(se_proxies)
maximum(se_delta)

#-------------------------------------
# Preparations towards plotting
#-------------------------------------

wide_df = unstack(sim_df, [:A_sqrt,:p, :σ, :n], :method, :mse)

sub_df = DataFrames.groupby(wide_df, :A_sqrt)

upscale = 0.7#8 #8x upscaling in resolution
default(size=(400*upscale,350*upscale))

#-------------------------------------
#      Figure 2, panel c (A_sqrt = 3)
#-------------------------------------


sub_df_c = sub_df[3]
sim_plot_np_panel_c = plot(sub_df_c[:,:n],
                sqrt.(Matrix(sub_df_c[:, Symbol.(vec(methods_text))])),
                seriestype=:line,
                xlim=(300,2000),
                ylim=(0.0,4.2),
                color = ["grey" "orange" "blue" "black"],
                linestyle = [:dashdotdot :dashdot :dot :dash],
                label=methods_text,
                xlab=L"$n$",
                xticks = [300,1100,1900],
                yticks = [0, 2, 4],
                grid=false,
                legend=:bottomright,
                ylab=L"E[( \hat{\mu}_i - \mu_i)^2]^{\frac{1}{2}}")

savefig(sim_plot_np_panel_c, "simulation_panel_c.pdf")

#-------------------------------------
#      Figure 2, panel a (A_sqrt = 0)
#-------------------------------------

sub_df_a = sub_df[1]
sim_plot_np_panel_a= plot(sub_df_a[:,:n],
                sqrt.(Matrix(sub_df_a[:, Symbol.(vec(methods_text))])),
                seriestype=:line,
                xlim=(300,2000),
                ylim=(0.0,4.2),
                color = ["grey" "orange" "blue" "black"],
                linestyle = [:dashdotdot :dashdot :dot :dash],
                label="",
                xlab=L"$n$",
                xticks = [300,1100,1900],
                yticks = [0, 2, 4],
                grid=false,
                legend=nothing,
                ylab=L"E[( \hat{\mu}_i - \mu_i)^2]^{\frac{1}{2}}")
#
savefig(sim_plot_np_panel_a, "simulation_panel_a.pdf")

#-------------------------------------
#      Figure 2, panel b (A_sqrt = 2)
#-------------------------------------

sub_df_b = sub_df[2]
sim_plot_np_panel_b= plot(sub_df_b[:,:n],
                sqrt.(Matrix(sub_df_b[:, Symbol.(vec(methods_text))])),
                seriestype=:line,
                xlim=(300,2000),
                ylim=(0.0,4.2),
                color = ["grey" "orange" "blue" "black"],
                linestyle = [:dashdotdot :dashdot :dot :dash],
                label="",
                xlab=L"$n$",
                xticks = [300,1100,1900],
                yticks = [0, 2, 4],
                grid=false,
                legend=nothing,
                ylab=L"E[( \hat{\mu}_i - \mu_i)^2]^{\frac{1}{2}}")
#
savefig(sim_plot_np_panel_b, "simulation_panel_b.pdf")