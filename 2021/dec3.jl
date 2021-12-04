using DelimitedFiles

the_array = readdlm("input3.txt",'\t', String, '\n')

integer_array = map(x -> parse.(Int, split(x[1], "")), eachrow(the_array))

integer_array = transpose(hcat(integer_array...))

function determine_majority(candidates)
    rows, columns = size(candidates)
    return map(x -> Int(2*x >= rows), sum(candidates, dims=1))
end

majority = determine_majority(integer_array)
minority = map(x -> Int(!Bool(x)), majority)

println(parse(Int, join(majority), base=2)*parse(Int, join(minority), base=2))

function yield_candidate(candidates, index, minority)
    rows, columns = size(candidates)
    new_candidates = Array{Int64}(undef, columns, 0)
    selector = determine_majority(candidates)
    if minority
        selector = map(x -> Int(!Bool(x)), selector)
    end
    for candidate in eachrow(candidates)
        if selector[index] == candidate[index]
            new_candidates = hcat(new_candidates, candidate)
        end   
    end
    new_candidates = transpose(new_candidates)
    rows, columns = size(new_candidates)
    if rows > 1
        yield_candidate(new_candidates, index+1, minority)
    else
        return new_candidates
    end
end

majority_final = yield_candidate(integer_array, 1, false)
minority_final = yield_candidate(integer_array, 1, true)

println(parse(Int, join(majority_final), base=2)*parse(Int, join(minority_final), base=2))



