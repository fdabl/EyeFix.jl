include("common.jl")

function IVT_algorithm{T <: Real}(time::Array{T, 1}, coords::Array{T, 2}, velthresh)
    n = length(time) - 1
    tdiff, cdiff = diff(time), diff(coords)

    spacediff = zeros(n)
    for i in 1:n
        spacediff[i] = √(cdiff[i, :] * cdiff[i, :]')[1] # euclidean distance
    end

    veldiff = spacediff ./ tdiff
    isfix = veldiff .< velthresh # boolean array (BitArray{1})
    hcat(time, coords, assign(isfix))
end


function IVT{T <: Real}(time::Array{T, 1}, x::Array{T, 1}, y::Array{T, 1}; velthresh = 0)
    IVT_algorithm(time, hcat(x, y), velthresh)
end


function IVT{T <: Real}(time::Array{T, 1}, coords::Array{T, 2}; velthresh = 0)
    IVT_algorithm(time, coords, velthresh)
end


function IVT{T <: Real}(dat::Array{T, 2}; velthresh = 0)
    @assert size(dat, 2) == 3
    IVT_algorithm(dat[:, 1], dat[:, 2:3], velthresh)
end
