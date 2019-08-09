# Load modules
using Plots, LaTeXStrings
pyplot(reuse=false, grid=false)
closeall()
include("ThinFilmsTools.jl")
using Main.ThinFilmsTools
include("RIdb.jl")
using Main.RIdb: air, dummy, bk7
# include("nplot.jl")

# Define beam
λi = 400 # intial wavelength [nm]
λf = 700 # final wavelength [nm]
λ = LinRange(λi, λf, λf-λi+1) # wavelength range [nm]
λ0 = 509.8
θ = [0.]
beam = PlaneWave(λ, λ0, θ)

# Define layers
layers1 = [ LayerTMMO(type=:GT, n=air(beam.λ), d=0.),
            LayerTMMO(type=:OT, n=dummy(beam.λ, 1.38, 0.), d=1/4.),
            LayerTMMO(type=:OT, n=dummy(beam.λ, 2.15, 0.), d=1/2.),
            LayerTMMO(type=:GT, n=bk7(beam.λ), d=0.) ]

layers2 = [ LayerTMMO(type=:GT, n=air(beam.λ), d=0.),
            LayerTMMO(type=:OT, n=dummy(beam.λ, 1.38, 0.), d=1/4.),
            LayerTMMO(type=:OT, n=dummy(beam.λ, 1.9, 0.), d=1/2.),
            LayerTMMO(type=:GT, n=bk7(beam.λ), d=0.) ]

# call main script
sol1 = TMMOptics(beam, layers1)
sol2 = TMMOptics(beam, layers2)

### Optional examples to plot results

# plot the R, T and A spectra
plot(TMMOplotSpectra1D(), sol1.Beam.λ, sol1.Spectra.Rs, label=L"Ta$_2$O$_5$", line=(:solid), ylims=(0.0, 0.025), xlims=(sol1.Beam.λ[1], sol1.Beam.λ[end]))
plot!(TMMOplotSpectra1D(), sol2.Beam.λ, sol2.Spectra.Rs, label=L"Y$_2$O$_3$", line=(:dashdot))
gui()

# plot the refractive index profile
TMMOplotNprofile(sol1;)
### Note that if you choose θ outside the range it will show the EMF for one extrema. Same for λ.
title!(L"Ta$_2$O$_5$")

TMMOplotNprofile(sol2;)
### Note that if you choose θ outside the range it will show the EMF for one extrema. Same for λ.
title!(L"Y$_2$O$_3$")