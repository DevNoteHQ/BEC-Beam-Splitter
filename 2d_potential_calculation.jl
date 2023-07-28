using QuantumOptics
using LinearAlgebra

@enum ParticleType begin
    Gauss = 1
    Tanh = 2
    Sech = 3
end

function calculateBeamSplitter(potential, mass, g, filename::String; v0=5, timestep=0.1, timeend=20.0, particleType::ParticleType=Gauss)
    Npoints = 128 #number of states along each axis
    length = 20 #length of each axis

    println("making basis...")

    b_x = PositionBasis(-length, length, Npoints)
    b_y = PositionBasis(-length, length, Npoints)
    b_px = MomentumBasis(b_x)
    b_py = MomentumBasis(b_y)

    b_comp = b_x ⊗ b_y
    b_comp_p = b_px ⊗ b_py

    Txp = transform(b_comp, b_comp_p)
    Tpx = transform(b_comp_p, b_comp)

    x = position(b_x)
    y = position(b_y)

    px = momentum(b_px)
    py = momentum(b_py)

    println("making hamiltonian...")

    Hkinx = LazyTensor(b_comp_p, [1, 2], (px^2/(2 * mass), one(b_py)))
    Hkiny = LazyTensor(b_comp_p, [1, 2], (one(b_px), py^2/(2 * mass)))

    Hkinx_FFT = LazyProduct(Txp, Hkinx, Tpx)
    Hkiny_FFT = LazyProduct(Txp, Hkiny, Tpx)
    Hpsi = diagonaloperator(b_comp, Ket(b_comp).data)
    V = potentialoperator(b_comp, potential)

    H = LazySum(Hkinx_FFT, Hkiny_FFT, Hpsi, V)

    fquantum(t, psi) = (Hpsi.data.nzval .= -g .* abs2.(psi.data); H)
    psi_0 = createState(b_x, b_y, length, v0, mass, particleType)
    normalize!(psi_0)

    println("starting time evolution...")

    T = collect(0.0:timestep:timeend)
    tout, psi_t = timeevolution.schroedinger_dynamic(T, psi_0, fquantum)

    density = [Array(transpose(reshape((abs2.(psi.data)), (Npoints, Npoints)))) for psi=psi_t]
    V_plot = Array(transpose(reshape(real.(diag(V.data)), (Npoints, Npoints))))

    xsample, ysample = samplepoints(b_x), samplepoints(b_y)

    return xsample, ysample, density, V_plot, T, timestep, length
end

function createState(b_x, b_y, length, v0, mass, particleType::ParticleType)
    if particleType == Sech
        return createSechState(b_x, b_y, length, v0, mass)
    elseif particleType == Tanh
        return createTanhState(b_x, b_y, length, v0, mass)
    else
        return createGaussianState(b_x, b_y, length, v0, mass)
    end
end

function createGaussianState(b_x, b_y, length, v0, mass)
    println("creating gauss state")
    psi_0x = gaussianstate(b_x, 0, 0, 1.0)
    psi_0y = gaussianstate(b_y, -length * 0.75, v0 * mass, 1.0)
    return psi_0x ⊗ psi_0y
end

function createTanhState(b_x, b_y, length, v0, mass)
    println("creating tanh state")
    psi_0x = tanstate(b_x, 0, 0, 1.0)
    psi_0y = tanstate(b_y, -length * 0.75, v0 * mass, 1.0)
    return psi_0x ⊗ psi_0y
end

function createSechState(b_x, b_y, length, v0, mass)
    println("creating sech state")
    psi_0x = sechstate(b_x, 0, 0, 1.0)
    psi_0y = sechstate(b_y, -length * 0.75, v0 * mass, 1.0)
    return psi_0x ⊗ psi_0y
end

function tanstate(::Type{T}, b::PositionBasis, x0, p0, sigma) where T
    psi = Ket(T, b)
    dx = spacing(b)
    x = b.xmin
    for i=1:b.N
        psi.data[i] = exp(1im*p0*(x-x0/2)) * sqrt(1 - tanh((x - x0) * sigma)^2) * sqrt(dx)
        x += dx
    end
    return psi
end

tanstate(b::Basis, x0, p0, sigma) = tanstate(ComplexF64, b, x0, p0, sigma)

function sechstate(::Type{T}, b::PositionBasis, x0, p0, sigma) where T
    psi = Ket(T, b)
    dx = spacing(b)
    x = b.xmin
    for i=1:b.N
        psi.data[i] = exp(1im*p0*(x-x0/2)) * sech((x - x0) / sigma) * sqrt(dx)
        x += dx
    end
    return psi
end

sechstate(b::Basis, x0, p0, sigma) = sechstate(ComplexF64, b, x0, p0, sigma)
