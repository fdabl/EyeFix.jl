T = [.80 .05 .15 # sunny
     .20 .60 .20 # rainy
     .20 .30 .50] # foggy

E = [.10 .90 # sunny
     .80 .20 # rainy
     .30 .70] # foggy


x = [2, 1, 1] # 1: umbrella 2: no umbrella
states = Dict(1 => "sunny", 2 => "rainy", 3 => "foggy")


function viterbi(x, states, T::Array{Float64, 2}, E::Array{Float64, 2})
    n = length(x)
    p = length(states)
    prior = 1 / p # assume equal priors

    delta = zeros(n, p) # holds the most likely path
    gamma = convert(Array{Int64, 2}, zeros(n, p)) # holds the arguments for the most likely path

    delta[1, :] = prior * E[:, 2]

    for i in 2:n
        b = x[i] # current observation

        for j in 1:p
            a = T[:, j] # transition probability *to* hidden state j {sunny, rainy, foggy}
            prev = delta[i-1, :] # previous deltas

            cont = diag(a * prev)
            delta[i, j] = maximum(cont) * E[j, b]
            _, gamma[i, j] = findmax(cont)
        end
    end

    _, dlast = findmax(delta[n, :])
    sequence = [dlast]

    for i in n:-1:2
        _, prev = findmax(delta[i, :])
        unshift!(sequence, gamma[i, prev])
    end

    return delta, [states[i] for i in sequence]
end
