using DelimitedFiles

the_array = readdlm("input5.txt")
the_array = hcat(the_array[:, 1], the_array[:, 3])

parsevec(p::SubString) = parse.(Int,split(p, ","))
rows, columns = size(the_array)
coordinates = map(parsevec, collect(the_array))

max_size = max(vcat(hcat(coordinates...)...)...) + 1
grid = zeros((max_size, max_size))
for index in 1:rows
    (x1, y1, x2, y2) = vcat(coordinates[index, :]...) + ones(Int, 4, 1)
    if x1 == x2
        maxy = max(y1, y2)
        miny = min(y1, y2)
        grid[x1, miny:maxy] .+=1
    elseif y1 == y2
        maxx = max(x1, x2)
        minx = min(x1, x2)
        grid[minx:maxx, y1] .+=1
    end
end

println(sum(map(x -> x > 1, grid)))

grid = zeros((max_size, max_size))
for index in 1:rows
    (x1, y1, x2, y2) = vcat(coordinates[index, :]...) + ones(Int, 4, 1)
    if x1 == x2
        maxy = max(y1, y2)
        miny = min(y1, y2)
        grid[x1, miny:maxy] .+=1
    elseif y1 == y2
        maxx = max(x1, x2)
        minx = min(x1, x2)
        grid[minx:maxx, y1] .+=1
    else
        if x1 < x2
            x_sequence = collect(x1:x2)
        else
            x_sequence = reverse(collect(x2:x1))
        end
        if y1 < y2
            y_sequence = collect(y1:y2)
        else
            y_sequence = reverse(collect(y2:y1))
        end
        for (x,y) in zip(x_sequence, y_sequence)
            grid[x, y] +=1
        end
    end
end

println(sum(map(x -> x > 1, grid)))

