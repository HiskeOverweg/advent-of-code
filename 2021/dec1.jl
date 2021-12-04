using DelimitedFiles

the_array = vec(readdlm("input1.txt"))

function consecutive(f, A::AbstractVector)
    [ f(A[i+1], A[i]) for i = 1:length(A)-1 ]
end

function three_consecutive(f, A::AbstractVector)
    [ f(A[i+2],f(A[i+1], A[i])) for i = 1:length(A)-2 ]
end

diff = consecutive(-, the_array)
number_of_increments = count(map(x -> x > 0, diff))
println(number_of_increments)

sum_array = three_consecutive(+, the_array)
diff = consecutive(-, sum_array)
number_of_increments = count(map(x -> x > 0, diff))
println(number_of_increments)