using DelimitedFiles
using Statistics

the_array = vec(readdlm("input7.txt", ',', Int, '\n'))
println(mapreduce(x -> abs(x-median(the_array)), +, the_array))
