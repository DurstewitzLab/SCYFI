using Plots
using JLD2

Loss2=load("Descent_Ellips14/test_1-wtf_0.0-L_10-opt_Descent/001/checkpoints/Loss.jld2")["loss"][1:200]
Loss1=load("Descent_Ellips14/test_1-wtf_0.1-L_10-opt_Descent/001/checkpoints/Loss.jld2")["loss"][1:200]

L=similar(Loss2)
for i in 1:200
    if Loss2[i]<4 
        L[i]=Loss2[i]
    else
        L[i]=4
    end
end
Loss1=Loss1/maximum(Loss1)
L=L/4




h=plot(L,xlabel="epoch",ylabel="Loss",linewidth=4,margin=7Plots.mm,size=(900,300),xtickfont=font(20),colorbar=true,  font_family="sans-serif",
 ytickfont=font(20),xguidefontsize=32,yguidefontsize=32,legendfont=font(15),c=ColorSchemes.lighttemperaturemap[2],label=L"\alpha=0")

 p=plot!(Loss1,label=L"\alpha=0.1",xlabel="epoch",ylabel="Loss",linewidth=4,margin=7Plots.mm,size=(800,400),xtickfont=font(14),
colorbar=true,  font_family="sans-serif", ytickfont=font(14),xguidefontsize=17,yguidefontsize=17,legendfont=font(15),
c=ColorSchemes.Greys_9[end-2],legendfontsize=11,legend=:topleft)