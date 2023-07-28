using FileIO
using JLD2

include("./../2d_potential_calculation.jl")
include("./../potentials.jl")

filename = "potential_narrow"
xsample, ysample, density, V_plot, T, timestep, length = calculateBeamSplitter(linearBarrierWithAngle(deg2rad(45.0), 5.5, 0.5), 1, 50, filename)
reflectionLineX=1.0
reflectionLineY=0.0
@save "data/" * filename * ".jld2" xsample ysample density V_plot T timestep length reflectionLineX reflectionLineY
