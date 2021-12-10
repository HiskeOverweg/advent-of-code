using DelimitedFiles
using Peaks

the_array = readdlm("input9.txt", ',', String, '\n')
the_array = reduce(vcat, permutedims.(collect.(the_array)))
the_array = parse.(Int, the_array)

function minima_in_vec(vec)
    argmins = argminima(vec)
    if vec[1] < vec[2]
        argmins = vcat([1], argmins)
    end
    if vec[end] < vec[end-1]
        argmins = vcat(argmins, length(vec))
    end
    is_minimum = [in(argmins).(x) for x in 1:length(vec)]
    return is_minimum
end

horizontal_minima = transpose(mapreduce(minima_in_vec, hcat, eachrow(the_array)))
vertical_minima = mapreduce(minima_in_vec, hcat, eachcol(the_array))
minima = horizontal_minima .& vertical_minima

println(sum(the_array[minima])+sum(minima))

function neighbouring(x,y, array_size)
    neighbours = []
    if x - 1 > 0
        neighbours = vcat([(x-1,y)], neighbours)
    end
    if x + 1 <= array_size[2]
        neighbours = vcat([(x+1,y)], neighbours)
    end
    if y - 1 > 0
        neighbours = vcat([(x, y-1)], neighbours)
    end
    if y + 1 <= array_size[1]
        neighbours = vcat([(x, y+1)], neighbours)
    end
    return neighbours
end

function explore_basin(visited, to_visit, basin_size)
    if length(to_visit)==0
        return basin_size
    end
    x, y = collect(to_visit)[1]
    if the_array[y, x] < 9
        additional = 1
        new_neighbours = Set(neighbouring(x, y, size(the_array)))
    else
        additional = 0
        new_neighbours = Set()
    end
    newly_visited = union(visited, Set([(x, y)]))
    newly_to_visit = union(to_visit, new_neighbours)
    newly_to_visit = setdiff(newly_to_visit, newly_visited)
    return explore_basin(newly_visited, newly_to_visit, basin_size + additional)
end

function find_basin(x_pos,y_pos, the_array)
    visited = Set([(x_pos, y_pos)])
    to_visit = Set(neighbouring(x_pos,y_pos, size(the_array)))
    basin_size = 1
    return explore_basin(visited, to_visit, basin_size)
end

coordinates_minima = findall(x -> x==true, transpose(minima))

basin_sizes = map(pos -> find_basin(Tuple(pos)..., the_array), coordinates_minima)

sort!(basin_sizes)

println(reduce(*, basin_sizes[end-2:end]))







