# N-queen by Simulated Aneeling
# シミュレーティッドアニーリング（焼きなまし法）によるN-Queen
struct Board
    size::Int64
    unit::Matrix{Int8}

    rows::Vector{Vector{Tuple{Int64,Int64}}}
    cols::Vector{Vector{Tuple{Int64,Int64}}}
    diags::Vector{Vector{Tuple{Int64,Int64}}}

    function Board(size::Int64)
        # 初期化：size個のQueenを配置しておく
        u = zeros(Int8, size, size)
        for i = 1:size
            u[i,i] = 1
        end

        # energy計算用の row, col, diagの座標一覧
        r = [[(x, y) for x = 1:size] for y = 1:size]
        c = [[(y, x) for x = 1:size] for y = 1:size]

        # rightup-diagonal
        d = [[(x, r - x + 1) for x = 1:minimum([r, size]) if r - x < size] for r = 1:(2*size-1)]

        # rightdown-diagonal
        append!(d, [[(x, x) for x = 1:size]])
        append!(d, [[(x, x - l) for x = l+1:size] for l = 1:size-1])
        append!(d, [[(y - l, y) for y = l+1:size] for l = 1:size-1])
        
        new(size, u, r, c, d)
    end
end

function energy(board::Board)
    #
    # エネルギー計算
    # 最適解の場合に、エネルギー=0となる
    #
    # row
    e = sum([(sum([board.unit[x, y] for (x, y) in row]) - 1)^2 for row in board.rows])

    # col
    e += sum([(sum([board.unit[x, y] for (x, y) in col]) - 1)^2 for col in board.cols])

    # diagonal
    e += sum([s * (s-1) for s in [sum([board.unit[x, y] for (x, y) in diag]) for diag in board.diags]])

    # queen
    e += (sum([board.unit[x, y] for x = 1:board.size for y = 1:board.size]) - board.size)^2

    return e
end

function change(board::Board, x, y)
    # 盤上のQueenのある(1)なし(0)を逆転(xor)する
    board.unit[x, y] ⊻= 1
end

function display(board::Board)
    # 表示
    println()
    for y = 1:board.size
        s = []
        for x = 1:board.size
            push!(s, board.unit[x, y])
        end
        println("[" * join(s, ", ") * "]")
    end
end

function run(board::Board, temp_start, temp_end, alpha, temp_iter)
    now_energy = energy(board)

    temperature = temp_start
    while temperature > temp_end && now_energy > 0
        for i = 1:temp_iter
            # 一か所変化させる
            rx = rand(1:board.size)
            ry = rand(1:board.size)
            change(board, rx, ry)

            # エネルギー値の計算
            new_energy = energy(board)
            # 変化前とのエネルギー値の差分
            de = new_energy - now_energy

            # eval
            if exp(- de / temperature) > rand()    # 条件 (de < 0) 含む 
                # 変化を許す
                now_energy = new_energy
                #display(borad)
                #println("energy = ", now_energy, "temp = ", temperature)

                # 解に到達したら終了
                if now_energy == 0
                    return (true, now_energy, temperature)
                end
            else
                # 変化を許さないので元に戻す
                change(board, rx, ry)
            end
        end

        # 温度を減衰
        temperature = temperature * alpha
    end

    return (false, now_energy, temperature)
end


if abspath(PROGRAM_FILE) == @__FILE__
    size = 8
    # 開始温度
    temp_start = size*size*10
    # 減衰率
    alpha = 0.99
    # 終了温度
    temp_end = 0.02
    # 温度当たりの繰り返し数
    temp_iter = size * size

    board = Board(size)
    #display(board)

    (result, ene, temp) = run(board, temp_start, temp_end, alpha, temp_iter)
    display(board)
    println("energy = ", ene, ", temp = ", temp)
    if result
        println("OK")
    end
end
