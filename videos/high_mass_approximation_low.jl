using FileIO
using JLD2

include("./../generate_video.jl")

filename = "approximation_low_mass"
path="data/"
pathVideos="videos/"

@load path * filename * ".jld2" xsample ysample density V_plot T timestep length reflectionLineX reflectionLineY
generateVideo(filename, xsample, ysample, density, V_plot, T, timestep, length, reflectionLineX=reflectionLineX, reflectionLineY=reflectionLineY, pathVideos=pathVideos)
