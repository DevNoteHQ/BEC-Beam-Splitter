using FileIO
using JLD2

include("./../2d_potential_calculation.jl")
include("./../potentials.jl")

filename = "lower_angle"
xsample, ysample, density, V_plot, T, timestep, length = calculateBeamSplitter(linearBarrierWithAngle(deg2rad(30), 8.5), 1, 50, filename)
reflectionLineX=0.0
reflectionLineY=-15.0
@save "data/" * filename * ".jld2" xsample ysample density V_plot T timestep length reflectionLineX reflectionLineY
