using FileIO
using JLD2

include("./../2d_potential_calculation.jl")
include("./../potentials.jl")

filename = "default_case_high_g"
xsample, ysample, density, V_plot, T, timestep, length = calculateBeamSplitter(linearBarrierWithAngle(deg2rad(45.0), 5.0), 1, 50, filename)
reflectionLineX=0.0
reflectionLineY=0.0
@save "data/" * filename * ".jld2" xsample ysample density V_plot T timestep length reflectionLineX reflectionLineY
