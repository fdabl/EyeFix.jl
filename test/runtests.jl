using EyeFix
using Base.Test


dummy = [
1 1 2
2 2 3
3 3 4
4 9 10
5 10 11
6 11 12
7 20 20
]

res1 = IVT(dummy; velthresh = 3)
res2 = IVT(dummy[:, 1], dummy[:, 2:3]; velthresh = 3)
res3 = IVT(dummy[:, 1], dummy[:, 2], dummy[:, 3]; velthresh = 3)
shouldbe = [1.0, 1.0, 1.0, 2.0, 2.0, 2.0, 3.0]

@assert res1[:, 4] == shouldbe
@assert res2[:, 4] == shouldbe
@assert res3[:, 4] == shouldbe

res1 = IDT(dummy)
res2 = IDT(dummy[:, 1], dummy[:, 2:3])
res3 = IDT(dummy[:, 1], dummy[:, 2], dummy[:, 3])
shouldbe = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]

@assert res1[:, 4] == shouldbe
@assert res2[:, 4] == shouldbe
@assert res3[:, 4] == shouldbe
res = IDT(dummy; durthresh = 10000, disthresh = 100000)

dd = dummy[:, 2:3]
res1 = kmeans(dd; k = 2)
res2 = kmeans(dd[:, 1], dd[:, 2]; k = 2)

res = GMM(dummy[:, 1]; k = 2)
