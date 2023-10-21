using JLD2
using Plots
loss=load("Turned off-alpha_0.05-ahead_0/001/checkpoints/Loss.jld2")["loss"]
h=plot(loss,xlabel="epoch",ylabel="Loss",linewidth=4,margin=7Plots.mm,size=(600,450),xtickfont=font(20),colorbar=true,  font_family="sans-serif",
 ytickfont=font(20),xguidefontsize=32,yguidefontsize=32,legendfont=font(15),c=ColorSchemes.lighttemperaturemap[2],label="no look-ahead")


loss=load("Turned on-alpha_0.05-ahead_10/012/checkpoints/Loss.jld2")["loss"]
epoch=load("Turned on-alpha_0.05-ahead_10/012/epoch/_jump.jld2")["epoch"]
plot!(loss,label="look-ahead",xlabel="epoch",ylabel="Loss",linewidth=4,margin=7Plots.mm,size=(600,450),xtickfont=font(14),
colorbar=true,  font_family="sans-serif", ytickfont=font(14),xguidefontsize=17,yguidefontsize=17,legendfont=font(15),
c=ColorSchemes.Greys_9[end-2])

p=plot!(ones(length(0.7:0.1:1.1))*epoch,0.7:0.1:1.1,ylims=(0.7,1.01),linewidth=4,linestyle=:dash,
c=ColorSchemes.grayyellow[end],legend=:topright,legendfontsize=11,label="")#label="look ahead"
savefig(p,"rebuttle_fig1_leg.pdf")


Loss=Matrix{Float64}(undef,1000,6)
Loss[:,1]=load("Turned off-alpha_0.05-ahead_0/001/checkpoints/Loss.jld2")["loss"]
Loss[:,2]=load("Turned off-alpha_0.05-ahead_0/002/checkpoints/Loss.jld2")["loss"]
Loss[:,3]=load("Turned off-alpha_0.05-ahead_0/003/checkpoints/Loss.jld2")["loss"]
Loss[:,4]=load("Turned off-alpha_0.05-ahead_0/004/checkpoints/Loss.jld2")["loss"]
Loss[:,5]=load("Turned off-alpha_0.05-ahead_0/005/checkpoints/Loss.jld2")["loss"]
Loss[:,6]=load("Turned off-alpha_0.05-ahead_0/006/checkpoints/Loss.jld2")["loss"]
L1=mean(Loss,dims=2)
s1=std(Loss,dims=2)/sqrt(6)

h=plot(L1,ribbon=s1,xlabel="epoch",ylabel="Loss",linewidth=4,margin=7Plots.mm,size=(600,450),xtickfont=font(20),colorbar=true,  font_family="sans-serif",
 ytickfont=font(20),xguidefontsize=32,yguidefontsize=32,legendfont=font(15),c=ColorSchemes.lighttemperaturemap[2],label="no look-ahead")



Loss2=Matrix{Float64}(undef,1000,6)
epoch=Vector{Float64}(undef,6)/sqrt(6)

#plot(Loss2[:,6])
Loss2[:,1]=load("Turned on-alpha_0.05-ahead_10/001/checkpoints/Loss.jld2")["loss"]
epoch[1]=load("Turned on-alpha_0.05-ahead_10/001/epoch/_jump.jld2")["epoch"]
Loss2[:,2]=load("Turned on-alpha_0.05-ahead_10/002/checkpoints/Loss.jld2")["loss"]
epoch[2]=load("Turned on-alpha_0.05-ahead_10/002/epoch/_jump.jld2")["epoch"]
Loss2[:,3]=load("Turned on-alpha_0.05-ahead_10/005/checkpoints/Loss.jld2")["loss"]
epoch[3]=load("Turned on-alpha_0.05-ahead_10/005/epoch/_jump.jld2")["epoch"]
Loss2[:,4]=load("Turned on-alpha_0.05-ahead_10/012/checkpoints/Loss.jld2")["loss"]
epoch[4]=load("Turned on-alpha_0.05-ahead_10/012/epoch/_jump.jld2")["epoch"]
Loss2[:,5]=load("Turned on-alpha_0.05-ahead_10/017/checkpoints/Loss.jld2")["loss"]
epoch[5]=load("Turned on-alpha_0.05-ahead_10/017/epoch/_jump.jld2")["epoch"]
Loss2[:,6]=load("Turned on-alpha_0.05-ahead_10/018/checkpoints/Loss.jld2")["loss"]
epoch[6]=load("Turned on-alpha_0.05-ahead_10/018/epoch/_jump.jld2")["epoch"]

L2=mean(Loss2,dims=2)
s2=std(Loss2,dims=2)/sqrt(6)

plot!(L2,ribbon=s2,label="look-ahead",xlabel="epoch",ylabel="Loss",linewidth=4,margin=7Plots.mm,size=(600,450),xtickfont=font(14),
colorbar=true,  font_family="sans-serif", ytickfont=font(14),xguidefontsize=17,yguidefontsize=17,legendfont=font(15),
c=ColorSchemes.Greys_9[end-2],legendfontsize=11)



savefig(h,"fig2.pdf")