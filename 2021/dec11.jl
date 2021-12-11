using DelimitedFiles

the_array = readdlm("testinput.txt", ',', Int, '\n')
the_array = transpose(mapreduce(x -> reverse!(digits(x)), hcat, the_array))

function check_boundaries(neighbours, size)
    correct_neighbours = []
    row_size, col_size = size
    for (row, col) in neighbours
        if 1 <= row <= row_size && 1 <= col <= col_size
            println("banan")
            correct_neighbours = vcat(correct_neighbours, [(row,col)])
        end
    end
    println(correct_neighbours)
end

function neighbouring(pos, size)
    row, col = pos
    neighbours = vec(collect(Iterators.product(row-1:row+1, col-1:col+1)))
    # remove (row, col) itself
    neighbours = hcat(neighbours[1:4], neighbours[6:end])
    neighbours = check_boundaries(neighbours, size)
end

function handle_flashes(to_flash, flashed, the_array)
    if isempty(to_flash)
        return the_array
    else
        new_array = copy(the_array)
        new_to_flash = Set()
        (row, col) = collect(to_flash)[1]
        neighbours = neighbouring((row, col), size(the_array))
        for n in neighbours
            new_array[n..] +=1
        

    end
end

function evolve(the_array)
    the_array .+=1
    to_flash = Set(findall(x -> x > 9, the_array))
    flashed = Set()
    
    for (row, col) in collect(flashing)
        for neighbour in neighbours(row, col, size(the_array))
            if !in(neighbour, flashing)
                neighbour[row, col] +=1
                if neighbour[row, col] > 9
                    flashing = union(flashing, Set([(row, co

end
evolve(the_array)

