module Peridynamics

using Base.Threads, Printf, LinearAlgebra, StaticArrays, ProgressMeter, WriteVTK,
    TimerOutputs, MPI

export PointCloud

const MPI_INITIALIZED = Ref(false)
const MPI_RANK = Ref(-1)
const MPI_SIZE = Ref(-1)
const SWITCH_TO_THREADS = Ref(false)
const TO = TimerOutput()
@inline mpi_comm() = MPI.COMM_WORLD
@inline mpi_rank() = MPI_RANK[]
@inline mpi_nranks() = MPI_SIZE[]
@inline switch_to_threads() = SWITCH_TO_THREADS[]

function __init__()
    if MPI_INITIALIZED[]
        return nothing
    end
    MPI.Init(finalize_atexit=true)
    MPI_RANK[] = MPI.Comm_rank(MPI.COMM_WORLD)
    MPI_SIZE[] = MPI.Comm_size(MPI.COMM_WORLD)
    MPI_INITIALIZED[] = true
    if !haskey(ENV, "MPI_LOCALRANKID") && MPI_SIZE[] == 1
        SWITCH_TO_THREADS[] = true
    end
    return nothing
end

include("basic_types.jl")

include(joinpath("discretizations", "point_cloud.jl"))

end
