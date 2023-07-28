using PyPlot
using PyCall

function generateVideo(filename::String, xsample, ysample, density, V_plot, T, timestep, length; reflectionLineX=0.0, reflectionLineY=0.0, pathVideos="videos/")
    rcParams = PyPlot.PyDict(PyPlot.matplotlib."rcParams")
    rcParams["animation.ffmpeg_path"] = "C:/Program Files/ffmpeg/bin/ffmpeg.exe"
    rcParams["axes.labelsize"] = 21
    rcParams["xtick.labelsize"] = 18
    rcParams["ytick.labelsize"] = 18
    rcParams["legend.fontsize"] = 16

    println("starting video rendering...")

    fig, axes = PyPlot.subplots(nrows=1, ncols=1, figsize=(8, 8))

    function animate(i)
        axes.clear()
        axes.contourf(xsample, ysample, density[i + 1], cmap="hot")
        axes.contourf(xsample, ysample, V_plot, alpha=0.3, cmap="Greys")
        if reflectionLineX != 0.0
            axes.plot([-length, length], [reflectionLineX, reflectionLineX], color="black")
        end
        axes.plot([-length, length], [0, 0], linestyle="--", color="black")
        if reflectionLineY != 0.0
            axes.plot([reflectionLineY, reflectionLineY], [-length, length], color="black")
        end
        axes.plot([0, 0], [-length, length], linestyle="--", color="black")
        axes.annotate("t=$(T[i + 1])", xy=[-length + 1, length - 3], fontsize=20)
        axes.set_xlabel(L"$x$ / $\overline{x}$", fontsize = 20)
        axes.set_ylabel(L"$y$ / $\overline{y}$", fontsize = 20)
    end

    animate(0)
    tight_layout()

    anim = pyimport("matplotlib.animation")

    myanim = anim.FuncAnimation(fig, animate, frames=size(T)[1], interval=300*timestep, blit=false)
    myanim[:save](pathVideos * filename * ".mp4", bitrate=-1, extra_args=["-vcodec", "libx264", "-pix_fmt", "yuv420p"])
end
