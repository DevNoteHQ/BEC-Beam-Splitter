using FileIO
using JLD2

include("./../../generate_video.jl")

filename = "default_case"
path="data_station/calc_7/"
pathVideos="videos/station/calc_7/"

@load path * filename * ".jld2" xsample ysample density V_plot T timestep length reflectionLineX reflectionLineY
generateVideo(filename, xsample, ysample, density, V_plot, T, timestep, length, reflectionLineX=reflectionLineX, reflectionLineY=reflectionLineY, pathVideos=pathVideos)
