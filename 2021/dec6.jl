using DelimitedFiles
using StatsBase
using DataStructures: SortedDict

function evolve_fish(fish, days)
    if days == 1
        return sum(fish)
    else
        future_fish =  vcat(fish[2:9], fish[1])
        future_fish[7] += fish[1]
        return evolve_fish(future_fish, days-1)
    end
end

data = vec(readdlm("input6.txt", ',', Int, '\n'))
grouped_fish = countmap(data)
for i in 1:9
    if !(i in keys(grouped_fish))
        grouped_fish[i] = 0
    end
end
sorted_fish = [val for val in values(SortedDict(grouped_fish))]

println(evolve_fish(sorted_fish, 80))
println(evolve_fish(sorted_fish, 256))
