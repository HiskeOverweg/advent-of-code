using DelimitedFiles

function read_graph(lines)
    connections = Dict()
    for line in lines
        (x,y) = line
        if y != "start"
            if haskey(connections, x)
                connections[x] = union(connections[x], [y])
            else
                connections[x] = Set([y])
            end
        end
        if x != "start"
            if haskey(connections, y)
                connections[y] = union(connections[y], [x])
            else
                connections[y] = Set([x])
            end
        end
    end
    connections["end"] = Set()
    return connections
end

function check_lowercase(name)
    if lowercase(name)==name && !(name in ["start", "end"])
        return true
    end
    return false
end

function traverse_graph(path, current_node, graph, visited)
    if current_node == "end"
        return path
    end
    candidates = graph[current_node]
    candidates = collect(filter(x -> !⊆([x], visited), candidates))
    if length(candidates)==0
        return []
    else
        paths = []
        for candidate in candidates
            if check_lowercase(candidate)
                visited_nodes = union(visited, Set([candidate]))
                paths = vcat(paths, traverse_graph(path*candidate, candidate, graph, visited_nodes))
            else
                paths = vcat(paths, traverse_graph(path*candidate, candidate, graph, visited))
            end
        end
        return paths
    end
end

function new_traverse_graph(path, current_node, graph, visited)
    if current_node == "end"
        return path
    end
    candidates = collect(graph[current_node])
    if maximum(values(visited)) == 2
        avoid = [k for k in keys(visited) if visited[k]>0]
        candidates = collect(filter(x -> !⊆([x], avoid), candidates))
    end
    if length(candidates)==0
        return []
    else
        paths = []
        for candidate in candidates
            if check_lowercase(candidate)
                visited_nodes = copy(visited)
                visited_nodes[candidate]+=1
                paths = vcat(paths, new_traverse_graph(path*candidate, candidate, graph, visited_nodes))
            else
                paths = vcat(paths, new_traverse_graph(path*candidate, candidate, graph, visited))
            end
        end
        return paths
    end
end

function main()
    the_array = readdlm("input12.txt", ',', String, '\n')
    lines = map(x -> split(x, '-'), the_array)
    connections = read_graph(lines)
    println(length(traverse_graph("", "start", connections, Set([""]))))

    small_caves = Dict(c => 0 for c in keys(connections) if check_lowercase(c))
    println(length(new_traverse_graph("", "start", connections, small_caves)))

end

main()