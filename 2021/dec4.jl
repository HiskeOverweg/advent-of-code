using DelimitedFiles

function check_bingo(card)
    for row in eachrow(card)
        if all(row)
            return true
        end
    end
    for col in eachcol(card)
        if all(col)
            return true
        end
    end
    return false
end

function main()
    data = readdlm("input4.txt", header=true)

    sequence = parse.(Int, split(data[2][1], ","))

    cards = round.(Int, data[1])
    rows, columns = size(cards)
    number_of_cards = Int(rows/columns)
    cards = reshape(vec(cards), (columns, number_of_cards, columns))
    cards = permutedims(cards, [1,3,2])

    drawn = falses(size(cards))

    winning_number = -1
    winning_card = -1
    for num in sequence
        idx = findall(x -> x==num, cards)
        [drawn[i] = true for i in idx]
        bingos = [check_bingo(drawn[:, :, i]) for i in 1:number_of_cards]
        if any(bingos)
            println("bingo!")
            idx = findall(x->x, bingos)
            winning_number = num
            winning_card = idx
            break
        end    
    end

    winning_sum = sum(cards[:,:, winning_card][.!drawn[:,:, winning_card]])
    println(winning_sum * winning_number)

    losing_number = -1
    losing_card = -1
    previous_bingos = 0
    for num in sequence
        idx = findall(x -> x==num, cards)
        [drawn[i] = true for i in idx]
        bingos = [check_bingo(drawn[:, :, i]) for i in 1:number_of_cards]
        if all(bingos)
            losing_card = findall(x->!x, previous_bingos)[1]
            losing_number = num
            break
        else
            previous_bingos = bingos
        end    
    end

    losing_sum = sum(cards[:,:, losing_card][.!drawn[:,:, losing_card]])
    println(losing_sum * losing_number)
end

main()
