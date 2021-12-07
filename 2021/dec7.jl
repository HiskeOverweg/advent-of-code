using DelimitedFiles
using Statistics

the_array = vec(readdlm("input7.txt", ',', Int, '\n'))

starting_point = median(the_array)

function calculate_fuel(point, crabs)
    return mapreduce(x -> abs(x-point), +, crabs)
end

println(Int(calculate_fuel(starting_point, the_array)))