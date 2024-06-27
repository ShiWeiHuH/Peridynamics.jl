module Peridynamics

using Base.Threads, Printf, LinearAlgebra, StaticArrays, PointNeighbors, ProgressMeter,
      WriteVTK, TimerOutputs, MPI, PrecompileTools
@static if Sys.islinux()
    using ThreadPinning
end

import LibGit2, Dates
import Polyester: @batch

# Abstract types
export AbstractMaterial, AbstractBondSystemMaterial, AbstractSpatialSetup, AbstractBody,
       AbstractMultibodySetup, AbstractParameterSetup, AbstractPointParameters,
       AbstractTimeSolver, AbstractJob, AbstractSystem, AbstractPredefinedCrack,
       AbstractCorrection, AbstractStorage, AbstractCondition

# Material models
export BBMaterial, BBPointParameters, OSBMaterial, OSBPointParameters, NOSBMaterial,
       NOSBPointParameters, CKIMaterial

# Systems related types
export BondSystem, NoCorrection, EnergySurfaceCorrection

# Discretization
export Body, point_set!, failure_permit!, material!, velocity_bc!, velocity_ic!,
       forcedensity_bc!, precrack!, MultibodySetup, contact!, uniform_box, uniform_sphere

# Running simulations
export VelocityVerlet, DynamicRelaxation, Job, submit

# Post processing and helpers
export read_vtk, process_each_export, mpi_isroot, force_mpi_run!, force_threads_run!,
       enable_mpi_timers!, disable_mpi_timers!, enable_mpi_progress_bars!,
       reset_mpi_progress_bars!, @mpitime, @mpiroot

function __init__()
    init_mpi()
    @static if Sys.islinux()
        mpi_run() || pinthreads(:cores; force=false)
    end
    BLAS.set_num_threads(1)
    return nothing
end

"""
TODO
"""
abstract type AbstractMaterial end

"""
TODO
"""
abstract type AbstractSpatialSetup end

"""
TODO
"""
abstract type AbstractBody{T<:AbstractMaterial} <: AbstractSpatialSetup end

"""
TODO
"""
abstract type AbstractMultibodySetup <: AbstractSpatialSetup end

"""
TODO
"""
abstract type AbstractParameterSetup end

"""
TODO
"""
abstract type AbstractPointParameters <: AbstractParameterSetup end
abstract type AbstractParamSpec end

"""
TODO
"""
abstract type AbstractTimeSolver end

"""
TODO
"""
abstract type AbstractJob end
abstract type AbstractJobOptions end

"""
TODO
"""
abstract type AbstractSystem end

"""
TODO
"""
abstract type AbstractPredefinedCrack end
abstract type AbstractBodyChunk{S<:AbstractSystem,T<:AbstractMaterial} end
abstract type AbstractParameterHandler <: AbstractParameterSetup end
abstract type AbstractChunkHandler end
abstract type AbstractDataHandler end
abstract type AbstractThreadsDataHandler <: AbstractDataHandler end
abstract type AbstractMPIDataHandler <: AbstractDataHandler end
abstract type AbstractThreadsBodyDataHandler{Sys,M,P,S} <: AbstractThreadsDataHandler end
abstract type AbstractThreadsMultibodyDataHandler <: AbstractThreadsDataHandler end
abstract type AbstractMPIBodyDataHandler{Sys,M,P,S} <: AbstractMPIDataHandler end
abstract type AbstractMPIMultibodyDataHandler <: AbstractMPIDataHandler end

"""
TODO
"""
abstract type AbstractCorrection end

"""
TODO
"""
abstract type AbstractStorage end

"""
TODO
"""
abstract type AbstractCondition end

"""
TODO
"""
abstract type AbstractBondSystemMaterial{Correction} <: AbstractMaterial end

include("auxiliary/function_arguments.jl")
include("auxiliary/io.jl")
include("auxiliary/logs.jl")
include("auxiliary/mpi.jl")

include("conditions/boundary_conditions.jl")
include("conditions/initial_conditions.jl")
include("conditions/condition_checks.jl")

include("physics/force_density.jl")
include("physics/material_parameters.jl")
include("physics/fracture.jl")
include("physics/short_range_force_contact.jl")

include("discretization/point_generators.jl")
include("discretization/predefined_cracks.jl")
include("discretization/point_sets.jl")
include("discretization/body.jl")
include("discretization/multibody_setup.jl")
include("discretization/decomposition.jl")
include("discretization/chunk_handler.jl")
include("discretization/bond_system.jl")
include("discretization/bond_system_corrections.jl")
include("discretization/body_chunk.jl")

include("core/job.jl")
include("core/submit.jl")
include("core/parameter_handler.jl")
include("core/systems.jl")
include("core/materials.jl")
include("core/storages.jl")
include("core/time_solvers.jl")
include("core/halo_exchange.jl")
include("core/data_handler.jl")
include("core/threads_body_data_handler.jl")
include("core/threads_multibody_data_handler.jl")
include("core/mpi_body_data_handler.jl")
include("core/mpi_multibody_data_handler.jl")

include("time_solvers/velocity_verlet.jl")
include("time_solvers/dynamic_relaxation.jl")

include("physics/bond_based.jl")
include("physics/continuum_kinematics_inspired.jl")
include("physics/ordinary_state_based.jl")
include("physics/correspondence.jl")

include("VtkReader/VtkReader.jl")
using .VtkReader

include("AbaqusMeshConverter/AbaqusMeshConverter.jl")
using .AbaqusMeshConverter

include("auxiliary/process_each_export.jl")

try
    include("auxiliary/precompile_workload.jl")
catch err
    @error "precompilation errored\n" exception=err
end

end
