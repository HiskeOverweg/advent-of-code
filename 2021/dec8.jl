using DelimitedFiles

the_array = readdlm("input8.txt", ' ', String, '\n')

function find_digits(the_array)
    total_number = 0
    for row in eachrow(the_array)
        numbers = row[1:10]
        code = row[12:15]
        total_number += sum(in([2,3,4,7]).([length(c) for c in code]))
    end
    return total_number
end

println(find_digits(the_array))

function decipher(array)
    unknowns = Array{Set}(undef, 0)
    one = Set()
    seven = Set()
    four = Set()
    eight = Set()
    for elem in array[1:10]
        if length(elem) == 2
            one = Set(split(elem, ""))
        elseif length(elem) == 3
            seven = Set(split(elem, ""))
        elseif length(elem) == 4
            four = Set(split(elem, ""))
        elseif length(elem) == 7
            eight = Set(split(elem, ""))
        else 
            unknowns = vcat(unknowns, Set(split(elem, "")))
        end
    end
    top = setdiff(seven, one)
    in_six = setdiff(eight, seven)
    index_of_six = map(x -> issubset(in_six, x), unknowns)
    six = unknowns[index_of_six][1]
    unknowns = [unknowns[.!index_of_six]...]
    right_top = setdiff(eight, six)
    index_of_five = .!map(x-> issubset(right_top, x), unknowns)
    five = unknowns[index_of_five][1]
    unknowns = unknowns[.!index_of_five]
    left_bottom = setdiff(setdiff(eight, five), right_top)
    nine = setdiff(eight, left_bottom)
    index_of_nine = map(x -> issubset(nine, x), unknowns)
    unknowns = unknowns[.!index_of_nine]
    index_of_three = .!map(x -> issubset(left_bottom, x), unknowns)
    three = unknowns[index_of_three][1]
    unknowns = unknowns[.!index_of_three]
    in_zero = setdiff(eight, three)
    index_of_zero = map(x -> issubset(in_zero, x), unknowns)
    zero = unknowns[index_of_zero][1]
    two = unknowns[.!index_of_zero][1]
    all_numbers = Dict(zero => 0, one => 1, two => 2, three => 3,
    four => 4, five => 5, six => 6, seven => 7, eight => 8, nine => 9)
    #decipher code
    code = [Set(split(number, "")) for number in array[12:15]]
    answer_digits = [all_numbers[c] for c in code]
    answer = sum([answer_digits[k]*10^(4-k) for k=1:length(answer_digits)])
    return answer
end
  
println(mapreduce(decipher, +, eachrow(the_array)))




