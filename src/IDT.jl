include("common.jl")

function IDT_algorithm{T <: Real}(time::Array{T, 1}, coords::Array{T, 2}, durthresh, disthresh)
    i = 1
    n = length(time) - 1
    fixcluster = zeros(n)
    D(x, y) = (maximum(x) - minimum(x)) + (maximum(y) - minimum(y))

    while i < n
        window = getwindow(time, coords, durthresh, i)
        dispersion = D(window[:, 1], window[:, 2])
        winsize = size(window, 1)

        if (winsize + i) < n && dispersion <= disthresh
            start = i + winsize

            while dispersion <= disthresh
                start += 1
                window = vcat(window, coords[start, :])
                dispersion = D(window[:, 1], window[:, 2])
            end

            fixcluster[i] = 1
            i += size(window, 1)
        else
            i += 1
        end
    end

    hcat(time, coords, assign(convert(BitArray{1}, fixcluster)))
end


function getwindow{T <: Real}(time::Array{T, 1}, coords::Array{T, 2}, durthresh, start::Int64)

    next = start + 1
    maxn = size(coords, 1)

    while next < maxn && ((time[next] - time[start]) < durthresh)
        next += 1
    end

    coords[start:next, :]
end


function IDT{T <: Real}(time::Array{T, 1}, x::Array{T, 1}, y::Array{T, 1}; durthresh = 0, disthresh = 0)
    IDT_algorithm(time, hcat(x, y), durthresh, disthresh)
end


function IDT{T <: Real}(time::Array{T, 1}, coords::Array{T, 2}; durthresh = 0, disthresh = 0)
    IDT_algorithm(time, coords, durthresh, disthresh)
end


function IDT{T <: Real}(dat::Array{T, 2}; durthresh = 0, disthresh = 0)
    @assert size(dat, 2) == 3
    IDT_algorithm(dat[:, 1], dat[:, 2:3], durthresh, disthresh)
end
