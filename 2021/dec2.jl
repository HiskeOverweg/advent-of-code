using DelimitedFiles

the_array = readdlm("input2.txt")

directions = Dict{String,AbstractVector}("forward"=>[1,0], "down"=>[0,1], "up"=>[0, -1])
instructions = mapslices(x -> directions[x[1]] .* x[2], the_array, dims=2)
position = sum(instructions, dims=1)
result = prod(position)
println(result)

function travel((hp, depth, aim), command)
    direction, distance = command
    if direction == "down"
      return (hp, depth, aim + distance)
    elseif direction == "up"
       return (hp, depth, aim - distance)
    elseif direction == "forward"
      return (hp + distance, depth + aim * distance, aim)   
    end
end

(hp, depth, aim) = foldl(travel, eachrow(the_array), init=(0,0,0))
println(hp*depth)
