using DelimitedFiles

function check_boundaries(neighbours, size)
    correct_neighbours = []
    row_size, col_size = size
    for (row, col) in neighbours
        if 1 <= row <= row_size && 1 <= col <= col_size
            correct_neighbours = vcat(correct_neighbours, [(row,col)])
        end
    end
    return correct_neighbours
end

function neighbouring(pos, size)
    row, col = Tuple(pos)
    neighbours = vec(collect(Iterators.product(row-1:row+1, col-1:col+1)))
    # remove (row, col) itself
    neighbours = hcat(neighbours[1:4], neighbours[6:end])
    neighbours = check_boundaries(neighbours, size)
    return neighbours
end

function handle_flashes(to_flash, flashed, the_array)
    if isempty(to_flash)
        return the_array, length(flashed)
    else
        flash_pos = collect(to_flash)[1]
        new_to_flash = setdiff(to_flash, Set([flash_pos]))
        new_flashed = union(flashed, Set([flash_pos]))
        new_array = copy(the_array)
        neighbours = neighbouring(flash_pos, size(the_array))
        for n in neighbours
            new_array[n...] +=1
            if new_array[n...] > 9 && !in(n, new_flashed)
                new_to_flash = union(new_to_flash, Set([n]))
            end
        end
        return handle_flashes(new_to_flash, new_flashed, new_array)
    end
end

function evolve(the_array, total_flashes)
    the_array .+=1
    to_flash = Set(map(Tuple, findall(x -> x > 9, the_array)))
    flashed = Set{CartesianIndex}()
    the_array, number_of_flashes = handle_flashes(to_flash, flashed, the_array)
    the_array[the_array .> 9] .=0
    return (the_array, total_flashes + number_of_flashes)
end

function read_array()
    the_array = readdlm("input11.txt", ',', Int, '\n')
    the_array = transpose(mapreduce(x -> reverse!(digits(x)), hcat, the_array))
    return the_array
end

function main()
    the_array = read_array()
    number_of_flashes = 0
    for i in 1:100
        the_array, number_of_flashes = evolve(the_array, number_of_flashes)
    end
    println(number_of_flashes)

    the_array = read_array()
    number_of_flashes = 0
    all_flash = false
    round = 0
    while all_flash == false
        the_array, number_of_flashes = evolve(the_array, number_of_flashes)
        round +=1
        if sum(the_array) == 0
            all_flash = true
        end
    end
    println(round)
end
main()

