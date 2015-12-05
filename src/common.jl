function assign(isfix::BitArray{1})
    fix = 1
    n = length(isfix)
    fixcluster = vcat(fix, zeros(n))

    for i in 1:n

        if !isfix[i]
            fix += 1
        end

        fixcluster[i+1] = fix
    end

    fixcluster
end
