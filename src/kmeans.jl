function kmeans_algorithm{T <: Real}(coords::Array{T, 2}, k::Int64)
    nochanges = 0
    n = size(coords, 1)
    @assert n >= k "Number of observations must not be greater than number of clusters"

    coords = hcat(coords, zeros(n))
    init = convert(Array{Int64, 1}, ceil(rand(k) * n))
    centroids = coords[init, 1:2]

    while nochanges < 2

        # for each data point
        for i in 1:n
            closest = Inf
            mindist = Inf

            # get the cluster from which the distance is smallest
            for j in 1:k
                d = abs(centroids[j, 1:2] - coords[i, 1:2])
                distance = √(d * d')[1]

                if distance < mindist
                    mindist = distance
                    closest = j
                end
            end

            # TODO: wrong termination step
            if coords[i, 3] == closest
                nochanges += 1
            else
                coords[i, 3] = closest
                nochanges = 0
            end

        end

        # recompute clusters
        for j in 1:k
            centroids[j, :] = mean(coords[coords[:, 3] .== j, 1:2], 1)
        end
    end

    coords
end


function kmeans{T <: Real}(x::Array{T, 1}, y::Array{T, 1}; k::Int64 = 1)
    kmeans_algorithm(hcat(x, y), k)
end


function kmeans{T <: Real}(coords::Array{T, 2}; k::Int64 = 1)
    @assert size(coords, 2) == 2
    kmeans_algorithm(coords, k)
end
