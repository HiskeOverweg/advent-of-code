using DelimitedFiles
using DataStructures
using Statistics

the_array = readdlm("input10.txt", ',', String, '\n')

brackets = Dict('('=>')', '{'=>'}', '['=>']', '<' => '>')
values = Dict(')'=>3, ']'=>57, '}'=>1197, '>'=>25137)
new_values = Dict('('=>1, '['=>2, '{'=>3, '<'=>4)

function value_of_row(row)
    s = Stack{Char}()
    for char in collect(row[1])
        if haskey(brackets, char)
            push!(s, char)
        else
            previous = pop!(s)
            if brackets[previous] != char
                return values[char]
            end
        end
    end
    return 0
end

answer = mapreduce(value_of_row, +, eachrow(the_array))
println(answer)

function new_value_of_row(row)
    s = Stack{Char}()
    for char in collect(row[1])
        if haskey(brackets, char)
            push!(s, char)
        else
            previous = pop!(s)
            if brackets[previous] != char
                return 0
            end
        end
    end
    score = 0
    while !isempty(s)
        last = pop!(s)
        score *= 5
        score += new_values[last]
    end
    return score
end

scores = map(new_value_of_row, eachrow(the_array))
non_zero = filter(x -> x>0, scores)
println(Int(median(non_zero)))







