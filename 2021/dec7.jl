using DelimitedFiles
using Statistics

the_array = vec(readdlm("input7.txt", ',', Int, '\n'))
println(Int(mapreduce(x -> abs(x-median(the_array)), +, the_array)))

function fuel_per_crab(distance)
    return Int(0.5 * (distance + 1) * distance)
end

function total_fuel(position, array)
    return mapreduce(x-> fuel_per_crab(abs(x-position)),+, collect(array))
end

max_pos = maximum(the_array)
min_pos = minimum(the_array)
fuels = map(x -> total_fuel(x, the_array), collect(min_pos:max_pos))
println(minimum(fuels))


