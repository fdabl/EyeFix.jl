using Distributions


points = [1, 14, 2, 3, 4, 7, 9, 15, 22, 4]
function GMM(points::Array; k::Int64 = 2, tol::Float64 = .001)

    prior = 1 / k
    n = length(points)
    @assert n > k "Need more data points than latent classes!"

    post = repmat([prior], n, k)
    post = hcat(post, points)

    # initial random latent gaussians
    sd = sqrt(var(points))
    gauss = [Distributions.Normal(rand(points), sd) for i in 1:k]

    est_mu(w, points) = sum(w .* points) / sum(w)
    est_var(w, mu, points) = sum(w .* (points - mu).^2) / sum(w)

    prev = post[:, 1]
    converged = false

    while !converged

        # for each point, compute the posterior of belonging to each latent gaussian
        for i in 1:n
            p = post[i, end]
            normalizer = sum([pdf(norm, p) for norm in gauss]) * prior

            for j in 1:k
                post[i, j] = (pdf(gauss[j], p) * prior) / normalizer
            end
        end

        diff = sum(abs(prev - post[:, 1]))

        if diff < tol
            converged = true
        else
            prev = post[:, 1]
        end

        mus = [est_mu(post[:, i], points) for i in 1:k]
        vars = [est_var(post[:, i], mus[i], points) for i in 1:k]
        gauss = [Distributions.Normal(mus[i], sqrt(vars[i])) for i in 1:k]
    end

    post
end
