using DelimitedFiles
using Images
using Plots

the_array = readdlm("testinput.txt", ',', String, '\n')
the_array = reduce(vcat, permutedims.(collect.(the_array)))
the_array = parse.(Int, the_array)

indices = findlocalminima(the_array)
risk = mapreduce(x -> the_array[x]+1, + , indices)
println(risk)


function plot()
gr()
data = the_array
return heatmap(1:size(data,1),
    1:size(data,2), data,
    c=cgrad([:blue, :white,:red, :yellow]),
    xlabel="x values", ylabel="y values",
    title="My title")
end

savefig(plot(), "test.png")
