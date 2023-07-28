using FileIO
using JLD2

include("./../2d_potential_calculation.jl")
include("./../potentials.jl")

filename = "approximation_low_mass"
xsample, ysample, density, V_plot, T, timestep, length = calculateBeamSplitter(linearBarrierWithAngle(deg2rad(45.0), 0.2), 1, 0, filename, v0=1, timestep=0.1, timeend=100.0)
reflectionLineX=0.0
reflectionLineY=0.0
@save "data/" * filename * ".jld2" xsample ysample density V_plot T timestep length reflectionLineX reflectionLineY
